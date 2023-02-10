view: html_sample {
  derived_table: {sql:select distinct id,name from idp.modelled.campaign_management_clients where agency_id = 'uber';;}
  dimension: name {
    type :  string
    sql: ${TABLE}.name ;;
    html: <button type="button">{{value}}</button> ;;
  }
   }
