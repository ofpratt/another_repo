connection: "thelook"

# include all the views
include: "/views/**/*.view"

datagroup: op_fresh_and_free_space_default_datagroup {
  sql_trigger: SELECT CURDATE();;
  max_cache_age: "1 hour"
}


persist_with: op_fresh_and_free_space_default_datagroup

explore: connection_reg_r3 {}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: flights {}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}


####### AGG AWARENESS TEST EXPLORE
explore: order_items {
  label: "Agg Awareness"
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
  aggregate_table: rollup__orders_created_date {
    query: {
      dimensions: [orders.created_date]
      measures: [order_items.count, order_items.aggregation]
      timezone: "EST"
    }
    materialization: {
      datagroup_trigger: op_fresh_and_free_space_default_datagroup
    }
  }
  ###### Year rollup doesnt use this
# #    aggregate_table: rollup__orders_created_week {
# #     query: {
# #        dimensions: [orders.created_week]
# #        measures: [count]
# #        timezone: "UTC"
# #      }
# #
# #      materialization: {
# #        datagroup_trigger: op_fresh_and_free_space_default_datagroup
# #     }
# #   }
# #   aggregate_table: rollup__users_created_month__users_gender {
# #     query: {
# #       dimensions: [users.created_month, users.gender]
# #       measures: [order_items.count]
# #       filters: [users.created_month: "before 2019/04/09"]
# #       timezone: "UTC"
# #     }
# #     materialization: {
# #       datagroup_trigger: op_fresh_and_free_space_default_datagroup
# #     }
#   }

}

explore: orders {
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

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
