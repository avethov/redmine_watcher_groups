module WatcherGroupsWatchersControllerPatch
    def self.included(base) # :nodoc:
	base.send(:include, InstanceMethods)
	base.class_eval do
	    alias_method_chain :create, :journal
	end
    end

    WatchersController.class_eval do
        module InstanceMethods
	    def create_with_journal
	        create_without_journal
		user_ids = []
		if params[:watcher].is_a?(Hash)
		    user_ids << (params[:watcher][:user_ids] || params[:watcher][:user_id])
		else
		    user_ids << params[:user_id]
		end
		@watchables.each do |watched|
		    watched.add_watcher_journal(:label_watcher_user_add, user_ids.flatten.compact.uniq.collect { |user_id| User.find(user_id).name }.join(", "))
		end
	    end
	end
    end
end

