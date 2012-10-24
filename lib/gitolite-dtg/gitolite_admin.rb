module Gitolite
  module Dtg
    class GitoliteAdmin
		attr_accessor :gl_admin, :config

		CONF = "gitolite.conf"
		CONFDIR = "conf"
		BRANCH = "master"

		# Intialize with the path to
		# the gitolite-admin repository
		def initialize(path, options = {})
		  @path = path
		  @gl_admin = Grit::Repo.new(path)

		  @conf = options[:conf] || CONF
		  @confdir = options[:confdir] || CONFDIR
		  @branch  = options[:branch] || BRANCH

		  # Load the configuration
		  load_data
		end

		# This method will destroy the in-memory data structures and reload everything
		# from the file system
		def reload!
		  load_data
		end

		#Checks to see if the given path is a gitolite-admin repository
		#A valid repository contains a conf folder, keydir folder,
		#and a configuration file within the conf folder
		def self.is_gitolite_admin_repo?(dir)
		  # First check if it is a git repository
		  begin
			repo = Grit::Repo.new(dir)
		  rescue Grit::InvalidGitRepositoryError
			return false
		  end

		  # If we got here it is a valid git repo,
		  # now check directory structure
		  cbl = repo.tree / 'conf/gitolite.conf'
		  if cbl != nil
			return true
		  else
			return false
		  end
		end

		private
		  def load_data
		    head = @gl_admin.commits(@branch).first
		    config_blob = head.tree / File.join(@confdir, @conf)
		    if config_blob != nil
				@config = Config.new(config_blob)
			else
				@config = nil
			end
		  end
		  
	end
  end
end
