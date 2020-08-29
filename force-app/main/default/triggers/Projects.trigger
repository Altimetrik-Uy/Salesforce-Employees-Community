/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Project doesn't have CloseDate
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Schubert Tonarelli   <stonarelli@altimetrik.com>
* @created        2020-05-15
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
trigger Projects on Opportunity ( before insert, before update ) {
    
    for( Opportunity o: Trigger.New ){ 
        if( o.CloseDate == NULL ){
            o.CloseDate = Date.today().addYears(1);
        }
        if( String.isEmpty( o.StageName ) ){
            o.StageName = 'In Progress';
        }
    }
}