--dml triggers (INSERT,UPDATE,DELETE) (BEFORE, AFTER), (STATEMENT LEVEL,ROW LEVEL) 
--ddl triggers (create/drop object)
--system triggers(logon,logoff)
--instead of triggers(triggers on views)
--compound triggers(combined dml triggers)

--can we use commit inside trigger - No (Except written with Autonomus Transaction Block)

--Statement Level Trigger                                		Row Level Trigger
	--Triggered only once even when no records are affected    		Triggered to the number of records getting affected
	--Statement Level Triggers are Default Triggers            		Row Level Trigger you need to mention 'For Each'
	--Cannt use Corelational Identifiers (:Old and :New)       

