view: products {
  sql_table_name: demo_db.products ;;
  drill_fields: [id]
  set: test {
    fields: [id,brand]
  }

  dimension: id {
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

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
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
