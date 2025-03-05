// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract crdfund is ERC721URIStorage, ReentrancyGuard, Ownable, Pausable {
    using Counters for Counters.Counter;

    struct Campaign {
        address creator;
        string title;
        string description;
        uint256 goal;
        uint256 deadline;
        uint256 fundsRaised;
        bool completed;
        bool cancelled;
    }

    struct Milestone {
        uint256 amount;
        bool approved;
    }

    Counters.Counter private _campaignIdCounter;
    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => Milestone[]) public milestones;
    mapping(uint256 => mapping(address => uint256)) public contributions;
    mapping(uint256 => mapping(address => bool)) public milestoneVotes;

    event CampaignCreated(uint256 indexed campaignId, address indexed creator, uint256 goal, uint256 deadline);
    event ContributionMade(uint256 indexed campaignId, address indexed backer, uint256 amount);
    event MilestoneApproved(uint256 indexed campaignId, uint256 indexed milestoneIndex, address indexed voter);
    event FundsWithdrawn(uint256 indexed campaignId, uint256 amount);
    event CampaignCancelled(uint256 indexed campaignId);
    event RefundClaimed(uint256 indexed campaignId, address indexed backer, uint256 amount);
    event NFTMinted(address indexed backer, uint256 indexed tokenId);

    constructor() ERC721("BackerNFT", "BNFT") Ownable(msg.sender) {}

    function createCampaign(
        string memory title,
        string memory description,
        uint256 goal,
        uint256 deadline,
        uint256[] memory milestoneAmounts
    ) external whenNotPaused {
        require(goal > 0, "Invalid goal");
        require(deadline > block.timestamp, "Invalid deadline");

        _campaignIdCounter.increment();
        uint256 campaignId = _campaignIdCounter.current();

        campaigns[campaignId] = Campaign(msg.sender, title, description, goal, deadline, 0, false, false);

        for (uint256 i = 0; i < milestoneAmounts.length; i++) {
            milestones[campaignId].push(Milestone(milestoneAmounts[i], false));
        }

        emit CampaignCreated(campaignId, msg.sender, goal, deadline);
    }

    function contribute(uint256 campaignId) external payable whenNotPaused nonReentrant {
        Campaign storage campaign = campaigns[campaignId];
        require(block.timestamp < campaign.deadline, "The Campaign has ended");
        require(msg.value > 0, "Zero contribution");

        campaign.fundsRaised += msg.value;
        contributions[campaignId][msg.sender] += msg.value;

        _tokenIdCounter.increment();
        uint256 newTokenId = _tokenIdCounter.current();
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, "https://example.com/nft-metadata.json");

        emit ContributionMade(campaignId, msg.sender, msg.value);
        emit NFTMinted(msg.sender, newTokenId);
    }

    function approveMilestone(uint256 campaignId, uint256 milestoneIndex) external {
        require(contributions[campaignId][msg.sender] > 0, "Not a backer");
        require(!milestoneVotes[campaignId][msg.sender], "Already voted");

        milestoneVotes[campaignId][msg.sender] = true;
        milestones[campaignId][milestoneIndex].approved = true;

        emit MilestoneApproved(campaignId, milestoneIndex, msg.sender);
    }

    function withdrawFunds(uint256 campaignId, uint256 milestoneIndex) external nonReentrant {
        Campaign storage campaign = campaigns[campaignId];
        require(msg.sender == campaign.creator, "Not creator");
        require(milestones[campaignId][milestoneIndex].approved, "Milestone not approved");
        require(!campaign.completed, "Already completed");

        uint256 amount = milestones[campaignId][milestoneIndex].amount;
        require(amount > 0, "No funds");

        campaign.fundsRaised -= amount;
        payable(msg.sender).transfer(amount);

        emit FundsWithdrawn(campaignId, amount);
    }

    function cancelCampaign(uint256 campaignId) external {
        Campaign storage campaign = campaigns[campaignId];
        require(msg.sender == campaign.creator, "Not creator");
        require(!campaign.cancelled, "Already cancelled");

        campaign.cancelled = true;
        emit CampaignCancelled(campaignId);
    }

    function claimRefund(uint256 campaignId) external nonReentrant {
        Campaign storage campaign = campaigns[campaignId];
        require(campaign.cancelled, "Not cancelled");
        require(contributions[campaignId][msg.sender] > 0, "No contributions");

        uint256 refundAmount = contributions[campaignId][msg.sender];
        contributions[campaignId][msg.sender] = 0;

        payable(msg.sender).transfer(refundAmount);
        emit RefundClaimed(campaignId, msg.sender, refundAmount);
    }

    function pauseContract() external onlyOwner {
        _pause();
    }

    function unpauseContract() external onlyOwner {
        _unpause();
    }
}

