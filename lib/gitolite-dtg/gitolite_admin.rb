require 'abbrev'

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
		
		# repo_name - the repository name 
		# username - the authenticated user name
		# resource_path - the path relative to the repository root that
		#                 the user is requesting access to
		# wanted_access - the type of access the user is requesting. can
		#                 be 'R' or 'W'
		def authorize(repo_name, username, resource_path, wanted_access)
			if @config == nil
				return false
			end
			repo = @config.repos[repo_name]
			if repo != nil
				repo.permissions.each do |perm_hash|
					perm_hash.each do |perm, list|
					  #process a permission line
					  list.each do |refex, users|
						
						ul = []
					  	users.each do |user|
							if user[0,1]=='@'
							    gname = user.gsub('@', '')
							    if ((@config.special_groups.include? gname) == false)
									grp = @config.flat_groups[gname]
									ul.concat(grp)
								else
									ul.push(user)
							    end
							else
								ul.push(user)
							end
					  	end
					  	ul.uniq!
					  	
					  	user_matches = false
					  	if ((ul.include? "@all") || ((ul.include? "@raven") && (username != nil)) || (ul.include? username))
							user_matches = true
					  	end
					  	
					  	if user_matches == false
							next
						end
						
						
						refex_applies = false;
						if refex == ''
							refex_applies = true;
						else
							dirs = []
							dirs.push(refex)
							dirs.push(resource_path)
	 
							common_prefix = dirs.abbrev.keys.min_by {|key| key.length}.chop
							common_directory = common_prefix.sub(%r{/[^/]*$}, '')
							
							if common_directory != ''
								refex_applies = true
							end
						end
						if !refex_applies
							next # if rule refex does not refer to the resource the user requested, go to the next rule
						end
						
					  	
					  	access_matches = false
					  	if (perm.include? wanted_access)
							access_matches = true
					  	end
					  	
					  	# authorization cases. at this point, user_matches==true and refex_applies==true:
					  	if (perm == "-")
							return false
						elsif (user_matches && access_matches)
							#print "Access allowed by matching rule: " + perm + " "
							#print list
							#print "\n"
							return true
						else
							next
					  	end

					  end
					end
				end
			end
			return false
		end

		private
		  def load_data
		    head = @gl_admin.commits(@branch).first
		    config_blob = head.tree / File.join(@confdir, @conf)
		    if config_blob != nil
				@config = Config.new(config_blob)
			else
				@config = nil
				print 'gitolite configuration could not be found in repository at ' + File.join(@path,@confdir,@conf)
			end
		  end
		  
	end
  end
end
