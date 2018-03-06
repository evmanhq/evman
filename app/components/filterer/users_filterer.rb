module Filterer
  class UsersFilterer < Base
    include Rails.application.routes.url_helpers

    def initialize(scope: nil, payload: {}, current_team: nil)
      raise ArgumentError, '`current_team` is required' unless current_team
      payload ||= {}

      @scope = scope || current_team.users
      @scope = @scope.merge(current_team.users)
      constrain_fields = [
          {
              name: 'name',
              type: 'text',
              conditions: BASIC_TEXT_CONDITIONS
          },

          {
              name: 'organization',
              type: 'text',
              conditions: BASIC_TEXT_CONDITIONS
          },

          {
              name: 'job_title',
              type: 'text',
              conditions: BASIC_TEXT_CONDITIONS
          },

          {
              name: 'email',
              type: 'text',
              conditions: BASIC_TEXT_CONDITIONS
          },

          {
              name: 'phone',
              type: 'text',
              conditions: BASIC_TEXT_CONDITIONS
          },

          {
              name: 'twitter',
              type: 'text',
              conditions: BASIC_TEXT_CONDITIONS
          },

          {
              name: 'github',
              type: 'text',
              conditions: BASIC_TEXT_CONDITIONS
          }
      ]


      sort_rule_fields = [
          { name: 'name' },
          { name: 'organization' }
      ]


      super(constrain_fields: constrain_fields,
            sort_rule_fields: sort_rule_fields,
            payload: payload)
    end

    private

    def filter_name(values, condition)
      perform_filter_text('users.name', values, condition)
    end

    def filter_organization(values, condition)
      perform_filter_text('users.organization', values, condition)
    end

    def filter_job_title(values, condition)
      perform_filter_text('users.job_title', values, condition)
    end

    def filter_email(values, condition)
      @scope = @scope.joins(:emails)
      perform_filter_text('user_emails.email', values, condition)
      @scope = @scope.distinct
    end

    def filter_phone(values, condition)
      perform_filter_text('users.phone', values, condition)
    end

    def filter_twitter(values, condition)
      perform_filter_text('users.twitter', values, condition)
    end

    def filter_github(values, condition)
      perform_filter_text('users.github', values, condition)
    end

    def sort_name(direction)
      @scope = @scope.order(name: direction)
    end

    def sort_organization(direction)
      @scope = @scope.order(name: direction)
    end
  end
end