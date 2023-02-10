view: client_info {
  derived_table: {sql:select distinct id,name,vale from idp.modelled.campaign_management_clients where agency_id = 'uber';;}
  dimension: id {
    primary_key: yes
    type :  string
    sql: ${TABLE}.id ;;
  }
  dimension: name {
    type :  string
    sql: ${TABLE}.name ;;
  }
  dimension: budget {
    type :  number
    sql: ${TABLE}.value ;;
  }
  }
