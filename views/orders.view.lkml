view: orders {
  sql_table_name: demo_db.orders ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  parameter: date_selector{
    type:  date
  }

dimension: is_before {
  type: yesno
  sql: ${created_date} < {% parameter date_selector %} ;;
}

parameter: filter_bug_test {
    type: string
    allowed_value: {value: "(All)"}
    allowed_value: {value: "Access Group"}
}

dimension: goes_with_filter_bug_test {
  type:  string
  sql:
   {% if filter_bug_test._parameter_value == "''" %}                                          NULl
        {% elsif filter_bug_test._parameter_value == "'(All)'" %}                               ${all_values}
        {% elsif filter_bug_test._parameter_value == "'Access Group'" %}                         ${status_dim}
        {% endif %};;
}

  dimension: all_values {
    label: "A sum of all group values"
    type: string
    sql: 'all' ;;
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

  parameter: date_bucket {
    type: string
    default_value: "Month"
    allowed_value: { value: "Month" }
    allowed_value: { value: "Quarter" }
    allowed_value: { value: "Year" }
  }

  dimension: opportunity_close_bucket {
    label_from_parameter: date_bucket
    sql:
    {% if date_bucket._parameter_value == "'Month'" %}
    cast(${created_month} as string)
    {% elsif date_bucket._parameter_value == "'Quarter'" %}
    cast(${created_quarter} as string)
    {% elsif date_bucket._parameter_value == "'Year'" %}
    cast(${created_year} as string)

    {% endif %};;
    html: {% if date_bucket._parameter_value == "'Month'" %}
      {{ opportunity_close_month._rendered_value | date: "%b %y" }}
      {% elsif date_bucket._parameter_value == "'Quarter'" %}
      {{ opportunity_close_quarter._rendered_value }}
      {% endif %};;
  }

  dimension: status_dim {
    hidden: no
    type: string
    description: "This shows what stage an order is in"
    sql: ${TABLE}.status ;;
  }

  dimension: yes_no_status {
    type: yesno
    sql: ${status_dim} = "pending" ;;
  }

  measure: sum_of_cancelled{
    type: sum
    sql: ${id};;
    filters: [status_dim: "cancelled"]
  }

  measure: count_of_cancelled {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [status_dim: "cancelled"]
  }

  measure: addition_of_cancelled{
    type: number
    sql: ${sum_of_cancelled} + ${count_of_cancelled} ;;
    link: {
      label: "Test Drill"
      url: "/explore/op_fresh_and_free_space/orders?fields=orders.id&f[orders.yes_no_status]=yes&sorts=orders.id&"

    }
  }

#   filter: status {
#     type: string
#     description: "this is a status"
#     #suggest_dimension: status_dim
#     sql: {% condition status %} ${status_dim} {% endcondition %};;
#   }

filter: test_user_id {
  type: number
  sql: {% condition %}${user_id}{% endcondition %} ;;
}


  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
    link: {
      label: "SME Lookml Dashboard Link"
      url: "/dashboards/1133?Created+Date={{ _filters['orders.created_date'] }}&ID={{ value | url_encode }}&Name+to+Num+ID={{ orders.name_to_num_id._value }}"
      }
      link: {
        label: "SME LookML Explore Link"
        url: "/explore/op_fresh_and_free_space/orders?fields=orders.id,orders.user_id,orders.status_dim&f[orders.status_dim]=&f[orders.user_id]={{ value }}&f[orders.created_date]={{ _filters['orders.created_date'] }}"
      }

  }

  measure: count_distinct {
    type: count_distinct
    sql: ${user_id} ;;
  }

  dimension: name_to_num_id {
    type: string
    sql: case when
    ${user_id} < 100 then "apples"
    when ${user_id} < 200 then "pears"
    when ${user_id} < 300 then "banana"
    else null
    end
    ;;
  }

  parameter: name_to_num_filter {
    type: unquoted
    allowed_value: {
      label: "apples"
      value: "1"
    }
    allowed_value: {
      label: "pears"
      value: "2"
    }
    allowed_value: {
      label: "banana"
      value: "3"
    }
  }

  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name, order_items.count]
    link: {
      label: "This is another drill"
      url: "/explore/op_fresh_and_free_space/order_items?qid=AEvUVirUn64drymbj11cXg"
    }

  }
}
