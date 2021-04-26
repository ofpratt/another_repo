# project_name: "op_fresh_and_free_space"

# constant: bq_project_id {
#   value: "{% if  _model._name == 'bq_core_kpis'
#   or _model._name == 'bq_core_operations'
#   or _model._name == 'bq_core_finance'
#   or _model._name == 'bq_core_sales_marketing'
#   or _model._name == 'bq_spoke_personal_production'
#   or _model._name == 'bq_spoke_personal_sandbox'
#   or _model._name == 'zendesk'%}{{ _user_attributes[\"bq_project_name\"] }}{% else %}gc-prd-data-hub-prod-21c3{% endif %}"
#   export: none }


# constant: test_user_attr {
#   value: "
#   {% if _user_attributes[\"country\"] == 'USA'%}
#   flights
#   {% else $}
#   events
#   {% endif %}
#   "
#   export: override_required
# }
