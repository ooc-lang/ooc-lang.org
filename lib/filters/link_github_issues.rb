class LinkGitHubIssues < Nanoc::Filter

  identifier :link_github_issues

  def run(content, params={})
    content.gsub(/#(\d+)/) do |m|
      num = m[1..-1]
      %[<a href="http://github.com/nddrylliog/rock/issues/#{num}">##{num}</a>]
    end
  end

end