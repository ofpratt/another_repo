view: sme_lookml_dt {
  derived_table: {
    sql: SELECT
          (DATE(`created_at`)) AS `orders.created_date`,
          `id` AS `orders.id`,
          case when
          orders.user_id > 1000 then "apples"
          when orders.user_id > 500 then "pears"
          when orders.user_id > 0 then "banana"
          else null
          end
           AS `orders.name_to_num_id`,
          `user_id` AS `orders.user_id`,
          `status` AS `orders.status_dim`
      FROM
          `demo_db`.`orders` AS `orders`
      where
          {% condition date_selector %} `created_at` {% endcondition %}
          and
          {% condition fruit_selector %}
                    case when
          orders.user_id > 1000 then "apples"
          when orders.user_id > 500 then "pears"
          when orders.user_id > 0 then "banana"
          else null
          end
          {% endcondition %}
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  parameter: date_format {
    type: unquoted
    allowed_value: {
      label: "US"
      value: "us"
    }
    allowed_value: {
      label: "EU"
      value: "eu"
    }
  }

  filter: fruit_selector {
    type: string
    suggest_dimension: fruits
  }

  filter: date_selector {
    type: date
  }

  dimension: created_date {
    hidden: yes
    type: date
    sql: ${TABLE}.`orders.created_date` ;;
    }


  dimension: date {
    sql: ${created_date} ;;
    html:
    {% if date_format._parameter_value == 'us' %}
    {{ rendered_value | date: "%b %d, %y" }}
    {% elsif date_format._parameter_value == 'eu' %}
   {{ rendered_value | date: "%d %b, %y" }}
    {% else %}
   null
    {% endif %};;
  }



  dimension: id {
    type: number
    sql: ${TABLE}.`orders.id` ;;
  }

  dimension: fruits {
    type: string
    sql: ${TABLE}.`orders.name_to_num_id` ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.`orders.user_id` ;;
  }

  dimension: status_dim {
    type: string
    sql: ${TABLE}.`orders.status_dim` ;;
  }

  set: detail {
    fields: [created_date, id, fruits, user_id, status_dim]
  }
}
