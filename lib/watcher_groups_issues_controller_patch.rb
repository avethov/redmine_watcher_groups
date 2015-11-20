require_dependency 'watcher_groups_helper' 

module WatcherGroupsIssuesControllerPatch

    def self.included(base) # :nodoc:
        base.class_eval do
          helper :watcher_groups
          include WatcherGroupsHelper

          def new
            respond_to do |format|
              format.html { 
                render :action => 'new', :layout => !request.xhr? 
              }
              format.js {
                #this is needed for proper rendering /projects/:project/issues/new.js
                render :action => 'new', formats: [:js], :layout => false
              }
            end
          end  
        end
    end

end


