view: orders {
  sql_table_name: demo_db.orders ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: status_dim {
    hidden: no
    type: string
    description: "This shows what stage an order is in"
    sql: ${TABLE}.status ;;
  }

#   filter: status {
#     type: string
#     description: "this is a status"
#     #suggest_dimension: status_dim
#     sql: {% condition status %} ${status_dim} {% endcondition %};;
#   }


  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name, order_items.count]
  }
}
