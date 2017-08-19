#encoding: utf-8
module WatcherGroupsIssueHooks
  class WatcherGroupsIssueAfterSaveHooks < Redmine::Hook::ViewListener
    # Context:
    # * :issue => Issue being saved
    # * :params => HTML parameters
    #

    def controller_issues_new_after_save(context={})
      if "watcher_group_ids".in? context[:params][:issue]
        context[:issue].watcher_groups_ids = context[:params][:issue]["watcher_group_ids"]
        context[:issue].save
        context[:issue].reload

	if Setting['plugin_redmine_watcher_groups']['redmine_watcher_groups_log_watchers_setting'] == 'yes'
	  group_ids = context[:params][:issue]["watcher_group_ids"]
	  if Redmine::Plugin.installed? :redmine_advanced_issue_history
	    notes = []
            group_ids.each do |group_id|
	      group_users = Group.find(group_id.to_i).users.uniq
	      group_users.each do |user|
		notes.append("Watcher #{user.name} was added")
	      end
	    end
	    add_system_journal(notes, context[:issue]) if notes.any?
	  else
	    watcher_name = group_ids.collect { |group_id| Group.find(group_id).name }.join(", ")
	    context[:issue].add_watcher_journal(:label_watcher_group_add, watcher_name)
	  end
        end
      end

    end
  end
end
