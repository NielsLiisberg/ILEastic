        // -----------------------------------------------------------------------------
        // This example runs a simple servlet using ILEastic framework
        // Note: It requires your RPG code to be reentrant and compiled
        // for multithreading. Each client request is handled by a seperate thread.
        // Start it:
        // SBMJOB CMD(CALL PGM(DEMO01)) JOB(ILEASTIC1) JOBQ(QSYSNOMAX) ALWMLTTHD(*YES)        
        // -----------------------------------------------------------------------------     
        ctl-opt copyright('Sitemule.com  (C), 2018');
        ctl-opt decEdit('0,') datEdit(*YMD.) main(main);
        ctl-opt debug(*yes) bndDir('ILEASTIC/ILEASTIC');
        ctl-opt thread(*CONCURRENT);
        /include headers/ileastic.rpgle
        // -----------------------------------------------------------------------------
        // Main
        // -----------------------------------------------------------------------------     
        dcl-proc main;

            dcl-ds config likeds(il_config);

            config.port = 44001; 
            config.host = '*ANY';

            il_listen (config : %paddr(myservlet));

        end-proc;
        // -----------------------------------------------------------------------------
        // Servlet call back implementation
        // -----------------------------------------------------------------------------     
        dcl-proc myservlet;

            dcl-pi *n;
                request  likeds(il_request);
                response likeds(il_response);
            end-pi;

            dcl-s file varchar(256);
            dcl-s err  ind;

            // lCopy - copy from the internal HTTP pointers
            file = il_getVarcharValue(request.resource);

            // Serve any static files from the IFS
            err = il_serveStatic (response : file);
            if err;
                response.status = 404;
                il_responseWrite(response:'File ' + file + ' not found');
            endif;

        end-proc;
