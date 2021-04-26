connection: "thelook"

# include all the views
include: "/views/**/*.view"
include: "/test_dash.dashboard"

datagroup: op_fresh_and_free_space_default_datagroup {
  sql_trigger: SELECT CURDATE();;
  max_cache_age: "1 hour"
}


persist_with: op_fresh_and_free_space_default_datagroup

explore: connection_reg_r3 {}

#explore: test_liquid {}

#explore: test_sql_table_name {}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

###git rid of this committ

#########Testing
explore: flights {
  # aggregate_table: rollup__dep_date {
  #   query: {
  #     dimensions: [dep_date]
  #     measures: [count]
  #     timezone: "UTC"
  #   }

  #   materialization: {
  #     datagroup_trigger: op_fresh_and_free_space_default_datagroup
  #   }
  # }
}
#####################################################
#####################################################


explore: inventory_items {
#   access_filter: {
#     field: products.department
#     user_attribute: op_test_department
#   }
  label: "Inventory Items - Not Agg Aware"
  join: products {
    #fields: [test*]
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
  #########
#   aggregate_table: rollup__created_date {
#     query: {
#       dimensions: [created_date]
#       measures: [products.count]
#       timezone: "UTC"
#     }
#     materialization: {
#       datagroup_trigger: op_fresh_and_free_space_default_datagroup
#     }
#   }
  ####### Week rollup
#   aggregate_table: rollup__created_week {
#     query: {
#       dimensions: [created_week]
#       measures: [count]
#       #filters: [products.department: "Women"]
#       timezone: "UTC"
#     }
#     materialization: {
#       datagroup_trigger: op_fresh_and_free_space_default_datagroup
#     }
#   }
  #####Count Distinct + filter
#   aggregate_table: rollup__created_month {
#     query: {
#       dimensions: [
#         # "products.department" is automatically filtered on in an access_filter.
#         # Uncomment to allow all possible filters to work with aggregate awareness.
#         # products.department,
#         created_month]
#       measures: [products.price_count_dist]
#       filters: [
#         # "products.department" is automatically filtered on in an access_filter in this query.
#         # Remove this filter to allow all possible filters to work with aggregate awareness.
#         products.department: "Women",
#       ]
#     }
#
#     materialization: {
#       datagroup_trigger: op_fresh_and_free_space_default_datagroup
#     }
#   }
}


####### AGG AWARENESS TEST EXPLORE
explore: order_items {
  label: "Big ol order items 😎"
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  #### AGG TABLES - change order_items.count to orders.count
#   aggregate_table: rollup__orders_created_date {
#     query: {
#       dimensions: [orders.created_date]
#       measures: [order_items.count, order_items.aggregation]
#       timezone: "America/New_York"
#     }
#     materialization: {
#       datagroup_trigger: op_fresh_and_free_space_default_datagroup
#     }
#   }
  ###### Year rollup doesnt use this
#    aggregate_table: rollup__orders_created_week {
#     query: {
#        dimensions: [orders.created_week]
#        measures: [count]
#        timezone: "UTC"
#      }
#
#      materialization: {
#        datagroup_trigger: op_fresh_and_free_space_default_datagroup
#     }
#   }
#   aggregate_table: rollup__users_created_month__users_gender {
#     query: {
#       dimensions: [users.created_month, users.gender]
#       measures: [order_items.count]
#       filters: [users.created_month: "before 2019/04/09"]
#       timezone: "UTC"
#     }
#     materialization: {
#       datagroup_trigger: op_fresh_and_free_space_default_datagroup
#     }
#   }

}

##################################EXTENDS

# explore: orders {
#   view_label: "Orders"
#   join: users {
#     type: left_outer
#     sql_on: ${orders.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
#   join: extended_orders {
#    view_label: "Orders"
#     type: inner
#     relationship: one_to_one
#     sql_on: ${extended_orders.id} = ${orders.id} ;;
#    fields: [extended_orders.filtered_count]
#   }
# }

explore: orders {
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: sme_lookml_dt{
    type: left_outer
    sql_on: ${sme_lookml_dt.id} = ${orders.id}  ;;
    relationship: many_to_many
  }}



explore: products {}

explore: schema_migrations {}

explore: user_data {
  join: users {
    type: left_outer
    sql_on: ${user_data.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users {}

explore: xin_test_for_bug2 {}
