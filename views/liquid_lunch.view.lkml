view: liquid_lunch {
  sql_table_name: public.liquid_lunch ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: orders {
    type: number
    sql: ${TABLE}."orders" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."state" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
