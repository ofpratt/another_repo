view: json_data {
  sql_table_name: public.json_data ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: data {
    type: string
    sql: ${TABLE}."data" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
