require "uri"
require "http/client"

module VersionFinder
  abstract def crystal_version
end

class Version
  include VersionFinder

  getter :sha_branch_tag, :interpreter

  def initialize(@sha_branch_tag : String, @interpreter : Bool); end

  def crystal_version
    sha_branch_tag
  end

  # ignoring all of this for now
  private def tag_exists?(tag : String) : Bool?
    commit = nil

    with_retry do 
      json_string = HTTP::Client.get("#{api_url}/releases/tags/#{encode_part(tag)}").body
      structure = JSON.parse(json_string)

      commit = structure["tarball_url"].as_s
    rescue Crest::NotFound
      next(nil)
    end

    !commit.nil?
  end

  private def fetch_commit_from_branch(branch : String) : String?
    commit = nil

    with_retry do
      json_string = HTPP::Client.get("#{api_url}/branches/#{encode_part(branch)}").body
      structure = JSON.parse(json_string)

      commit = structure["commit"].as_h["sha"].as_s
    rescue ex : Crest::NotFound | JSON::ParseException
      next(nil)
    end      

    commit
  end

  private def resolve_version
  
  end

  private def api_url
    "https://api.github.com/repos/crystal-lang/crystal"
  end

  private def encode_part(str : String)
    URI.encode_path_segment(str)
  end

  private def is_git_rev_hash?(str : String)
    /^[0-9a-f]{7,40}$/i.matches?(str)
  end

  private def with_retry(current : Int32 = 0, &block : ->)
    begin
      block.call
    rescue ex
      raise RetryExceeded.new("Failed to download after #{@retry} retries: #{ex}") if current >= @retry
      with_retry(current.succ, &block)
    end
  end
end
