view: stats {
  derived_table: {sql:select client_id,campaign_id,job_group_id,event_publisher_date,coalesce(dbg_original_publisher,publisher_id) publisher_id,
   sum(dbg_cd_spend) as CDSPEND,
  sum( case when (
        event_type = 'CLICK'
        and is_valid = true
      ) then event_count
      else 0
    end) as CLICKS,
    sum(case
      when (
        event_type = 'CONVERSION'
        and conversion_type = 'APPLY'
      ) then event_count
      else 0
    end) as APPLIES
from tracking.modelled.view_tracking_event
where agency_id = 'uber'
and date(event_publisher_date) >=  date('2022-11-01')
and date(event_publisher_date) <=  current_date
and should_contribute_to_joveo_stats = TRUE
group by client_id,campaign_id,job_group_id,event_publisher_date,coalesce(dbg_original_publisher,publisher_id);;}
  dimension: client_id {
    type :  string
    sql: ${TABLE}.client_id ;;
  }
  dimension: campaign_id {
    type :  string
    sql: ${TABLE}.campaign_id ;;
  }
  dimension: job_group_id {
    type :  string
    sql: ${TABLE}.job_group_id ;;
  }
  dimension: publisher_id {
    type :  string
    sql: ${TABLE}.publisher_id ;;
  }
  dimension: Spend {
    type :  number
    sql: ${TABLE}.CDSPEND ;;
  }
  dimension: Clicks {
    type :  number
    sql: ${TABLE}.CLICKS ;;
  }
  dimension: Applies {
    type :  number
    sql: ${TABLE}.APPLIES ;;
  }
  dimension: date {
    type :  date
    sql: ${TABLE}.event_publisher_date ;;
  }
  measure: sum_total {
    type: sum
    sql: ${Spend} ;;
    value_format: "0.00"

  }
  measure: click_total {
    type:  sum
    sql: ${Clicks}   ;;
  }
  measure: applies_total {
    type: sum
    sql:  ${Applies} ;;
  }
  measure: cpc {
    type: number
    sql: ${sum_total}/NULLIF(${click_total},0) ;;
    value_format: "0.00"
  }
  measure: cpa {
    type: number
    sql: ${sum_total}/NULLIF(${applies_total},0) ;;
    value_format: "0.00"
  }
  measure: cta {
    type: number
    sql: ${applies_total}*100/NULLIF(${click_total},0) ;;
    value_format: "0.00"
  }

  }
