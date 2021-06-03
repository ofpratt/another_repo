view: products {
  sql_table_name: demo_db.products ;;
  drill_fields: [id]
  set: test {
    fields: [id,brand]
  }

  dimension: id {
    description: "This is another ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  ####################

  measure: total_retail_price {
    type: sum
    sql: ${retail_price} ;;
  }

  measure: running_retail_price {
    type: running_total
    sql: ${total_retail_price} ;;
  }

  parameter: select_retail {
    allowed_value: {label: "Sum"
      value: "1"}
    allowed_value: {label: "Running total"
      value: "2"}
  }

  measure: dynamic_select {
    sql: case when
    {% parameter select_retail %} = 1 then ${total_retail_price}
    when
    {% parameter select_retail %} = 2 then ${running_retail_price}
    else null end;;
  }

################

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

dimension: just_null {
  type: number
  sql:  null ;;
}

measure: sum_null {
  type: sum
  sql: ${just_null} ;;
}

  measure: conversion_rate_site{
    type: number
    sql: ${count}/NULLIF(${retail_price},0.49) ;;
    value_format_name: percent_1
    label: "Conversion Rate"
    html: {{rendered_value}} || Total Selected Used: {{count}} ;;
    #drill_fields: [town,zip_code,registrations,count_used]
}

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
#     link: {
#       label: "Drill Look"
#       url:"/looks/1910?&f[products.brand]={{ products.brand }}&f[users.city]={{ _filters['users.city'] | url_encode }}"
#     }
  }

  measure: price_count_dist {
    type: count_distinct
    sql: ${retail_price} ;;
  }
}
