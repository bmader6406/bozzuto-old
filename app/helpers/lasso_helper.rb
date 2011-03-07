module LassoHelper
  def lasso_hidden_fields(community)
    if community.respond_to?(:lasso_account) && community.lasso_account.present?
      lasso = community.lasso_account

      fields = ''

      fields << hidden_field_tag('LassoUID', lasso.uid)
      fields << hidden_field_tag('ClientID', lasso.client_id)
      fields << hidden_field_tag('ProjectID', lasso.project_id)
      fields << hidden_field_tag('SignupThankyouLink', thank_you_home_community_lasso_submissions_url(community))

      lasso.analytics_id.if_present? do |id|
        fields << hidden_field_tag('domainAccountId', id)
        fields << hidden_field_tag('guid')
      end

      fields.html_safe
    end
  end
end
