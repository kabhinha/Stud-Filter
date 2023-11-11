// SPDX-License-Identifier: MIT
pragma solidity >=0.8.1 <0.9.0;

contract Twitter {
    
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[]) public tweets;
    uint16 public MAX_TWEET_LENGTH = 280;
    address owner;
    event createdTweet(uint256 id, string content, address author, uint256 timestamp);
    event likedTweet(uint256 tweetId, address tweetAuthor, uint256 tweetLikes);
    event dislikedTweet(uint256 tweetId, address tweetAuthor, uint256 tweetLikes);
    
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner==msg.sender, "You are not the owner");
        _;
    }

    function changeMaxTweet(uint16 inputLength) public onlyOwner{
        MAX_TWEET_LENGTH = inputLength;
    }

    function createTweet(string memory _tweet) public {
        // string take tremendous amount of data that's why we have use memory to specify data location
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Your Tweet is too long");
        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender, // msg is the object via wallet
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);
        emit createdTweet(newTweet.id, newTweet.content, newTweet.author, newTweet.timestamp);
    }

    function getTweetAtIndex(address _owner, uint16 _i) public view returns (Tweet memory) {
        return tweets[_owner][_i];
    }

    function getALLTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }

    function deleteTweet(address _owner, uint16 _i) public {
        delete tweets[_owner][_i];
    }

    function likeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet doesn't exist");
        tweets[author][id].likes++;
        emit likedTweet(id, author, tweets[author][id].likes);
    }

        function dislikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet doesn't exist");
        require(tweets[author][id].likes > 0, "There is no like");
        tweets[author][id].likes--;
        emit dislikedTweet(id, author, tweets[author][id].likes);
    }
}
