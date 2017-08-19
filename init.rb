require 'redmine' 

require_dependency 'watcher_groups/views_issues_hook'
require_dependency 'watcher_groups_helper' 
require_dependency 'watcher_groups_issue_hook'
Rails.logger.info 'Starting Watcher Groups plugin for Redmine'
 

Rails.configuration.to_prepare do

  unless Issue.included_modules.include?(WatcherGroupsIssuePatch)
    Issue.send(:include, WatcherGroupsIssuePatch)
  end

  unless IssuesController.included_modules.include?(WatcherGroupsIssuesControllerPatch)
    IssuesController.send(:include, WatcherGroupsIssuesControllerPatch)
  end

  unless WatchersController.included_modules.include?(WatcherGroupsWatchersControllerPatch)
    WatchersController.send(:include, WatcherGroupsWatchersControllerPatch)
  end

end

Redmine::Plugin.register :redmine_watcher_groups do
  name 'Redmine Watcher Groups plugin'
  author 'Kamen Ferdinandov, Massimo Rossello, Stephane Lapie'
  description 'This is a plugin for Redmine to add watcher groups functionality'
  version '1.0.0'
  url 'http://github.com/maxrossello/redmine_watcher_groups'
  author_url 'http://github.com/maxrossello'

  settings :default => {"redmine_watcher_groups_log_watchers_setting" => 'no'}, :partial => 'settings/redmine_watcher_groups_settings'
end
