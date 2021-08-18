# view: test_liquid {
#   derived_table: {
#     sql:
#     select `products`.`brand`,`products`.`department` from (
#     SELECT
#           `products`.`brand` AS brand,
#           `products`.`department` AS `products.department`,
#           COUNT(DISTINCT products.id ) AS `products.count`
#       FROM
#           `demo_db`.`order_items` AS `order_items`
#           LEFT JOIN `demo_db`.`inventory_items` AS `inventory_items` ON `order_items`.`inventory_item_id` = `inventory_items`.`id`
#           LEFT JOIN `demo_db`.`products` AS `products` ON `inventory_items`.`product_id` = `products`.`id`
#       WHERE
#           {{ _view._name }} <> " "

#       GROUP BY
#           1,
#           2
#       ORDER BY
#           COUNT(DISTINCT products.id ) as ranked DESC
#       LIMIT 500)
#       where ranked.brand <> " "
#       ;;
#   }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

#   dimension: products_brand {
#     type: string
#     sql: ${TABLE}.`products.brand` ;;
#   }

#   dimension: products_department {
#     type: string
#     sql: ${TABLE}.`products.department` ;;
#   }

#   dimension: products_count {
#     type: number
#     sql: ${TABLE}.`products.count` ;;
#   }

#   set: detail {
#     fields: [products_brand, products_department, products_count]
#   }
# }

# view: test_sql_table_name {
#   derived_table: {
#     sql: SELECT * FROM ${test_liquid.SQL_TABLE_NAME} ;;
#   }
#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

#   dimension: products_brand {
#     type: string
#     sql: ${TABLE}.`products.brand` ;;
#   }

#   dimension: products_department {
#     type: string
#     sql: ${TABLE}.`products.department` ;;
#   }

#   dimension: products_count {
#     type: number
#     sql: ${TABLE}.`products.count` ;;
#   }

#   set: detail {
#     fields: [products_brand, products_department, products_count]
#   }
# }
