class LinkGitHubNicks < Nanoc::Filter

  identifier :link_github_nicks

  def run(content, params={})
    content.gsub(/@(\w+)/) do
      username = $1
      %[<a href="http://github.com/#{username}">@#{username}</a>]
    end
  end

end