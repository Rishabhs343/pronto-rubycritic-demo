# frozen_string_literal: true

# Demonstrates: high complexity (flog), nested iterators, DuplicateMethodCall.
class ComplexRouter
  def route(request)
    if request.method == 'GET'
      if request.path.start_with?('/api/')
        if request.content_type == 'application/json'
          request.body.include?('secret') ? :forbidden : :api_json
        else
          :api_other
        end
      else
        :web
      end
    elsif request.method == 'POST'
      if request.authenticated?
        request.admin? ? :admin : :user
      else
        :unauthorized
      end
    else
      :method_not_allowed
    end
  end
end
