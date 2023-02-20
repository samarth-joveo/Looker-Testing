view: stats_unpivoted {
  derived_table: {
    sql:  (select client_id,coalesce(dbg_original_publisher,publisher_id) publisher_id ,'Clicks' type,
  sum( case when (
        event_type = 'CLICK'
        and is_valid = true
      ) then event_count
      else 0
    end) as value
from tracking.modelled.view_tracking_event
where client_id = '18457b0e-361a-4ad5-88e3-9be503cfcc2b'
and date(event_publisher_date) >=  date('2023-01-01')
and date(event_publisher_date) <  date('2023-02-01')
and should_contribute_to_joveo_stats = TRUE
group by client_id,coalesce(dbg_original_publisher,publisher_id))
union all
(select client_id,coalesce(dbg_original_publisher,publisher_id) publisher_id,'Spend' type,
  sum(case
    when is_valid = true then (event_spend * (1E0 / (1E0 - (publisher_entity_markdown / 100))) * (1E0 + (agency_markup / 100)) * (1E0 + (effective_cd_markup / 100)) * d_logic_ratio)
    else 0E0
  end) as value
from tracking.modelled.view_tracking_event
where client_id = '18457b0e-361a-4ad5-88e3-9be503cfcc2b'
and date(event_publisher_date) >=  date('2023-01-01')
and date(event_publisher_date) <  date('2023-02-01')
and should_contribute_to_joveo_stats = TRUE
group by client_id,coalesce(dbg_original_publisher,publisher_id))
union all
(select client_id,coalesce(dbg_original_publisher,publisher_id) publisher_id, 'Applies' type,
  sum(case
      when (
        event_type = 'CONVERSION'
        and conversion_type = 'APPLY'
      ) then event_count
      else 0
    end) as value
from tracking.modelled.view_tracking_event
where client_id = '18457b0e-361a-4ad5-88e3-9be503cfcc2b'
and date(event_publisher_date) >=  date('2023-01-01')
and date(event_publisher_date) <  date('2023-02-01')
and should_contribute_to_joveo_stats = TRUE
group by client_id,coalesce(dbg_original_publisher,publisher_id))
;;
  }
  dimension: client_id {
    type :  string
    sql:  ${TABLE}.client_id ;;

  }
  dimension: publisher_id {
    type :  string
    sql:  ${TABLE}.publisher_id ;;

  }
  dimension: filter_metric {
    type :  string
    sql:  ${TABLE}.type ;;

  }
  dimension: filter_val {
    type :  number
    sql:  ${TABLE}.value ;;

  }
  measure: Value {
    type: sum
    sql: ${filter_val} ;;
  }
}
