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
end
