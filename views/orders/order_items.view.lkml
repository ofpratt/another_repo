view: order_items {
  sql_table_name: demo_db.order_items ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  parameter: aggregation_type {
    type: string
    allowed_value: {
      label: "Count"
      value: "count"
    }
    allowed_value: {
      label: "Total Sale Price"
      value: "total_sale_price"
    }
    allowed_value: {
      label: "Average Sale Price"
      value: "average_sale_price"
    }
  }

  measure: aggregation {
    label_from_parameter: aggregation_type
    type: number
    #value_format: "$0.0,\"K\""
    sql:
    CASE
      WHEN {% parameter aggregation_type %} = 'count'
        THEN ${count}
      WHEN {% parameter aggregation_type %} = 'total_sale_price'
        THEN ${total_sale_price}
      WHEN {% parameter aggregation_type %} = 'average_sale_price'
        THEN ${average_sale_price}
      ELSE NULL
    END ;;
  }

  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price}  ;;
  }

  measure: total_profit {
    hidden: yes
    type: number
    sql: ${total_sale_price}-${inventory_items.total_cost} ;;
    value_format_name: usd
  }

#LINK LIQUID VARIABLE EXAMPLES
  measure: count_test_1 {
    group_label: "Link Liquid Variable Examples"
    label: "Count with Filtered Drill Modal"
    description: "When we drill into this measure, the results in the drill modal will only show records where Total Profit >= 50000. This link uses the link parameter."
    type: count
    drill_fields: [products.category, order_items.total_profit]
    link: {
      label: "Filtered Drill Modal"
      url: "{{ link }}&f[order_items.total_profit]=>=50000"
    }
  }

  measure: count_test_2 {
    group_label: "Link Liquid Variable Examples"
    label: "Count with Filtered Linked Explore"
    description: "When we drill into this measure, we will be sent to an explore that will show records where Total Profit >= 50000. This link uses the HTML parameter."
    type: count
    drill_fields: [products.category, order_items.total_profit]
    html: <a href="{{ link }}&f[order_items.total_profit]=>=50000&f[orders.status_dim]=complete">{{ rendered_value }}</a> ;;}


}
