view: users {
  sql_table_name: demo_db.users ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    html: <a href="/explore/{{ _user_attributes['city_name'] }}EC2%20Instance%20Id={{value}}">{{ value }}</a> ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    group_label: "Created date!"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      week_of_year,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  parameter: timeframe_picker {
    label: "Date Granularity"
    type: string
    allowed_value: { value: "Date" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    allowed_value: { value: "Quarter"}
    default_value: "Date"
  }

  dimension: dynamic_timeframe {
    type: string
    sql:
    CASE
    WHEN {% parameter timeframe_picker %} = 'Date' THEN ${users.created_date}
    WHEN {% parameter timeframe_picker %} = 'Week' THEN ${users.created_week_of_year}
    WHEN{% parameter timeframe_picker %} = 'Month' THEN ${users.created_month}
    WHEN{% parameter timeframe_picker %} = 'Quarter' THEN ${users.created_quarter}
    END ;;
  }

  dimension: fiscal_quarter {
    description: "This starts in Feb"
    group_label: "Created date!"
    type: date_fiscal_quarter
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
    html: <a href="{{ link }}&f[users.city]=New+York">{{ value }}</a> ;;
  }

  measure: number_time {
    type: number
    sql: ${zip} - ${count} ;;
    drill_fields: [detail*]
    html: <a href="{{ link }}&f[users.city]=New+York">{{ value }}</a> ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      first_name,
      last_name,
      events.count,
      orders.count,
      user_data.count
    ]
  }
}
