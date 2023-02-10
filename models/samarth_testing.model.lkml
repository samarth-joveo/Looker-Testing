connection: "idp"
include: "/views/*.view"

datagroup: samarth_testing_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: samarth_testing_default_datagroup
label: "Samarth Testing"
explore : stats {
  join: client_info {
    type :  left_outer
    sql_on: ${client_info.id} = ${stats.client_id} ;;
    relationship: many_to_one
  }
  join : campaign_info {
    type :  left_outer
    sql_on: ${campaign_info.id} = ${stats.campaign_id} ;;
    relationship: many_to_one
  }
  join : jg_info {
    type: left_outer
    sql_on: ${jg_info.id} = ${stats.job_group_id} ;;
    relationship: many_to_one
  }
}

explore: html_sample {}
