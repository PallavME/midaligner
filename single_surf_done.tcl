
set distanceext 4



#ELEMENT SLECTION

    *saveviewmask "2" 0  


#		if {[hm_entityinfo exist components "elems___1"] == 0} {
#			
#			*collectorcreateonly components "elems___1" "" 5
#	    }  else {
#		    *createmark comps 1 "elems___1"
            
			
#	    }

        
		
*settopologydisplaytype 1
		
*createmarkpanel surfaces 1
set twosurf [hm_getmark surfs 1]

set dupsurf1 [lindex $twosurf 0]
set dupsurf2 [lindex $twosurf 1] 

#SURF1 SELECTION 

if {[hm_entityinfo exist components "dup1"] == 0} {
			
			*collectorcreateonly components "dup1" "" 4
	    }  else {
		    *createmark comps 1 "dup1"
            *deletemark comps 1
			*collectorcreateonly components "dup1" "" 4
	    }
		
		*clearmark surfs 1
        *createmark surfaces 1 $dupsurf1
        *duplicatemark surfaces 1 1
        *createmark surfs 1 -1
        set suf1 [hm_getmark surfs 1]


        *createmark surfs 1 $suf1
        *movemark surfaces 1 "dup1" 
        
	*createmark components 1 "dup1"
    *transparencymark 1
    *settransparency 1
    *transparencyvalue 3	
	

#SURF2 SELECTION

		if {[hm_entityinfo exist components "dup2"] == 0} {
			
			*collectorcreateonly components "dup2" "" 3
	    }  else {
		    *createmark comps 1 "dup2"
            *deletemark comps 1
			*collectorcreateonly components "dup2" "" 3
	    }

        *clearmark surfs 1
        *createmark surfaces 1 $dupsurf2
        *duplicatemark surfaces 1 1
        *createmark surfs 1 -1
        set suf2 [hm_getmark surfs 1]


        *createmark surfs 1 $suf2
        *movemark surfaces 1 "dup2"	
	

   	




#ELEMENT SLECTION
        *settopologydisplaytype 0
		
		*createmark comps 1 dup1
		set compname1 [hm_getmark comps 1]
		*setcomptopologydisplay $compname1 1
		
		*createmark comps 1 dup2
		set compname2 [hm_getmark comps 1]
		*setcomptopologydisplay $compname2 1

 *createmark components 1 "dup2" "dup1"
    *transparencymark 1
    *settransparency 1
    *transparencyvalue 7
	
	
		
        *createmarkpanel elems 1 
	    #*movemark elems 1 "elems___1"
		
		*morphcreatedomaindc elements 1 7 0 0 0 0
		*createmark domains 1 -1
		set doamianelem [hm_getmark domains 1]

        
        *morphupdateparameter "handlesize" 0.1

#SURF1 EXTEND		
		
      	
		
		*createmark components 2 "dup1"
        *createstringarray 2 "elements_on" "geometry_on"
        *isolateonlyentitybymark 2 1 2
       

       

        *clearmark surfs 1
        *clearmark lines 1

*createmark surfaces 1 $suf1
*createmark surfaces 2
*createmark lines 1 "displayed"
*createmark lines 2
*connect_surfaces_11 1 2 4 0 $distanceext 15 45 1 0 2 30 3 0

*createmark surf 1 -1
set extsurf1 [hm_getmark surfs 1]

*clearmark surfs 1
*clearmark lines 1
*clearmark surfs 2
*clearmark lines 2

		
*createmark components 2 "dup1"
*createstringarray 2 "elements_on" "geometry_on"
*hideentitybymark 2 1 2


#SURF2 SELECTION AND EXTEND



		
		*createmark components 2 "dup2"
        *createstringarray 2 "elements_on" "geometry_on"
        *isolateonlyentitybymark 2 1 2
       

       

        *clearmark surfs 1
        *clearmark lines 1

*createmark surfaces 1 $suf2
*createmark surfaces 2
*createmark lines 1 "displayed"
*createmark lines 2
*connect_surfaces_11 1 2 4 0 $distanceext 15 45 1 0 2 30 3 0

*createmark surf 1 -1
set extsurf2 [hm_getmark surfs 1]

*clearmark surfs 1
*clearmark lines 1
*clearmark surfs 2
*clearmark lines 2



*createmark components 2 "dup2"
*createstringarray 2 "elements_on" "geometry_on"
*hideentitybymark 2 1 2


#MID GENERATE AND ALIGN NODE

*createmark surfaces 1 $extsurf1 $extsurf2
*midsurfaceextract surfaces 1 1 0 0 0 undefined 0 0 1

*createmark surf 1 -1
set midsurftoelem [hm_getmark surfs 1]

 
      
	  

*createmark elements 1 "by domains" $doamianelem
*markprojectnormallytosurface elements 1 $midsurftoelem

*createmark components 2 "Middle Surface"
*createstringarray 2 "elements_on" "geometry_on"
*hideentitybymark 2 1 2

#	if {[hm_entityinfo exist components "ALIGNED_ELEMENTS"] == 0} {
			
#			*collectorcreateonly components "ALIGNED_ELEMENTS" "" 4
#			*createmark elements 1 "by comps" "elems___1"
#            *movemark elems 1 "ALIGNED_ELEMENTS"
			
			
			
#	}  else {
#			*createmark elements 1 "by comps" "elems___1"
 #           *movemark elems 1 "ALIGNED_ELEMENTS"
	#}
	
*restoreviewmask "2" 0