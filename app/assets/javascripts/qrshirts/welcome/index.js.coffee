QRShirts.Welcome = {} if QRShirts.Welcome is undefined

QRShirts.Welcome.Index =->
  twitter          = $('#twitter')
  twitter_username = twitter.data('username')
  twitter_link     = "http://twitter.com/#{twitter_username}"
  twitter_url      = "https://api.twitter.com/1/statuses/user_timeline.json?callback=?&count=4"
  twitter_avatar   = "http://api.twitter.com/1/users/profile_image/#{twitter_username}.json"

  populateTwitterBlock = (data)->
    data = data
    # name = $('<h4/>', { class: 'name'})
    # link = $('<a/>', {
    #   href: 'http://twitter.com/' + twitter_username,
    #   text: 'Follow ' + twitter_username,
    #   "class":            "twitter-follow-button",
    #   "data-show-count":  false,
    #   "data-button":      "blue",
    #   "data-width":       "224px"

    # })

    # twitter.append(name)
    twitter.children(".name").text(twitter_username)

    for tweet in data
      twitter.append "<p class=\"text\"><a href=\"#{twitter_link}\" target=\"_blank\"><img src=\"#{twitter_avatar}\" class=\"twitter_avatar\" /></a>#{tweet.text}</p>"

    # twitter.append(link)

  fetchLatestTweets = ->
    self = this
    $.getJSON(twitter_url, {screen_name: twitter_username}, (data)->
      populateTwitterBlock(data)
    )
  
  fetchLatestTweets()