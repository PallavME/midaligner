
set extentdistance 4






*settopologydisplaytype 1


   *createmarkpanel surfs 1
   set surflist1 [hm_getmark surfs 1]
   *clearmark surfs 1
 


   *createmarkpanel surfs 1
   set surflist2 [hm_getmark surfs 1]
   *clearmark surfs 1
 

set nossufs [concat $surflist1 $surflist2]






if { [llength $nossufs] == 3} {

set untrim1 [lindex $nossufs 0]
set untrim2 [lindex $nossufs 1]
set untrim3 [lindex $nossufs 2]


#proc 1sttrim{} {untrim1 untrim2 

# ###### fs is used as prefix before each variable for fisrt surface operation
   
#create component named untrimed
     if {[hm_entityinfo exist components "fsuntrimed"] == 0} {
			
			*collectorcreateonly components "fsuntrimed" "" 3
	    }  else {
		    *createmark comps 1 "fsuntrimed"
            *deletemark comps 1
			*collectorcreateonly components "fsuntrimed" "" 3
	    }

        *clearmark surfs 1
		*clearmark surfs 2
# ############################################################		
       
#duplicate selected surfaces move in comp untrimmed
*createmark surfaces 2 $untrim1 $untrim2 

*duplicatemark surfaces 2 1
*createmarklast surfaces 1
set fsdupsurflist [hm_getmark surfs 1]

*createmark surfs 1 $fsdupsurflist
*movemark surfaces 1 "fsuntrimed"	


# #############################################################


#  untrimming both surfaces

set fssplitsurf1 [lindex $fsdupsurflist 0]
set fssplitsurf2 [lindex $fsdupsurflist 1]

*createmark surfaces 2 $fssplitsurf1 $fssplitsurf2 
*surfacemarkuntrim 2
# ########################################

#calculating area
set fsara1 [eval hm_getareaofsurface surfs $fssplitsurf1]

set fsara2 [eval hm_getareaofsurface surfs $fssplitsurf2]



#check greater area and delete small surface
    
	if { $fsara1 >= $fsara2} {
	    
		*createmark surfs 1 $fssplitsurf2
		*deletemark surfs 1
	 } else  {
         
         *createmark surfs 1 $fssplitsurf1		 
		 *deletemark surfs 1
     }
# #####################################################

#finding nearby edges and supress them

*createmark surfaces 1 "by comps" fsuntrimed
set fsuntrimedsurf [hm_getmark surfs 1]

set fsalledges [eval hm_getsurfaceedges $fsuntrimedsurf]

set fsedgelist [lindex $fsalledges 0]


set fslast [lindex $fsedgelist end-0]		
set fslast3 [lindex $fsedgelist end-2]      


*edgesmerge $fslast $fslast3 0.1


set fsalledges1 [eval hm_getsurfaceedges $fsuntrimedsurf]

set fsedgelist1 [lindex $fsalledges1 0]


set fslast1 [lindex $fsedgelist1 end-0]


*edgesuppress $fslast1	

*createmark lines 1 "by comps" fsuntrimed
	
		
# $fsuntrimedsurf is our main surface for extension


# }

#ELEMENT SLECTION

    *saveviewmask "2" 0  


#		if {[hm_entityinfo exist components "elems___1"] == 0} {
#			
#			*collectorcreateonly components "elems___1" "" 5
#	    }  else {
#		    *createmark comps 1 "elems___1"
            
			
#	    }

        
		

		
 

#SURF1 SELECTION 

if {[hm_entityinfo exist components "dup1"] == 0} {
			
			*collectorcreateonly components "dup1" "" 5
	    }  else {
		    *createmark comps 1 "dup1"
            *deletemark comps 1
			*collectorcreateonly components "dup1" "" 5
	    }
		
		*clearmark surfs 1
        *createmark surfaces 1 $fsuntrimedsurf
        *duplicatemark surfaces 1 1
        *createmark surfs 1 -1
        set suf1 [hm_getmark surfs 1]


        *createmark surfs 1 $suf1
        *movemark surfaces 1 "dup1" 
        
	*createmark components 1 "dup1"
    *transparencymark 1
    *settransparency 1
    *transparencyvalue 7
	
#SURF2 SELECTION

		if {[hm_entityinfo exist components "dup2"] == 0} {
			
			*collectorcreateonly components "dup2" "" 3
	    }  else {
		    *createmark comps 1 "dup2"
            *deletemark comps 1
			*collectorcreateonly components "dup2" "" 3
	    }

        *clearmark surfs 1
        *createmark surfaces 1 $untrim3
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
    *transparencyvalue 4
	
	
		
        *createmarkpanel elems 1 
	    #*movemark elems 1 "elems___1"
		
		*morphcreatedomaindc elements 1 7 0 0 0 0
		*createmark domains 1 -1
		set doamianelem [hm_getmark domains 1]

        
        *morphupdateparameter "handlesize" 0.1
		
		
#MID GENERATE AND ALIGN NODE

*createmark surfaces 1 $suf1 $suf2
*midsurfaceextract surfaces 1 1 0 0 0 undefined 0 0 1

*createmark surf 1 -1
set midsurftoelem [hm_getmark surfs 1]

 			#mid surface extend  EXTEND

		if {[hm_entityinfo exist components "midforextend"] == 0} {
			
			*collectorcreateonly components "midforextend" "" 3
	    }  else {
		    *createmark comps 1 "midforextend"
            *deletemark comps 1
			*collectorcreateonly components "midforextend" "" 3
	    }

        *createmark surfs 1 $midsurftoelem
        *movemark surfaces 1 "midforextend"	
					
					*createmark components 2 "midforextend"
					*createstringarray 2 "elements_on" "geometry_on"
					*isolateonlyentitybymark 2 1 2
				   
set lsalledges1 [eval hm_getsurfaceedges $midsurftoelem]

set lsedgelist1 [lindex $lsalledges1 0]


set lslast1 [lindex $lsedgelist1 end-0]


*edgesuppress $lslast1

					*clearmark surfs 1
					*clearmark lines 1

			*createmark surfaces 1 $midsurftoelem
			*createmark surfaces 2
			*createmark lines 1 "displayed"
			*createmark lines 2
			*connect_surfaces_11 1 2 4 0 $extentdistance 15 45 1 0 2 30 3 0

			*createmark surf 1 -1
			set extsurf2 [hm_getmark surfs 1]

			*clearmark surfs 1
			*clearmark lines 1
			*clearmark surfs 2
			*clearmark lines 2



			*createmark components 2 "dup2"
			*createstringarray 2 "elements_on" "geometry_on"
			*hideentitybymark 2 1 2

      
	  

*createmark elements 1 "by domains" $doamianelem
*markprojectnormallytosurface elements 1 $extsurf2

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
	*createmark comps 1 "lsuntrimed" "lsuntrimed" "fsuntrimed"
    *deletemark comps 1
*restoreviewmask "2" 0		
		

}


if { [llength $nossufs] == 4} {

set untrim1 [lindex $nossufs 0]
set untrim2 [lindex $nossufs 1]
set untrim3 [lindex $nossufs 2]
set untrim4 [lindex $nossufs 3]


#proc 1sttrim{} {untrim1 untrim2 

# ###### fs is used as prefix before each variable for fisrt surface operation
   
#create component named untrimed
     if {[hm_entityinfo exist components "fsuntrimed"] == 0} {
			
			*collectorcreateonly components "fsuntrimed" "" 3
	    }  else {
		    *createmark comps 1 "fsuntrimed"
            *deletemark comps 1
			*collectorcreateonly components "fsuntrimed" "" 3
	    }

        *clearmark surfs 1
		*clearmark surfs 2
# ############################################################		
       
#duplicate selected surfaces move in comp untrimmed
*createmark surfaces 2 $untrim1 $untrim2 

*duplicatemark surfaces 2 1
*createmarklast surfaces 1
set fsdupsurflist [hm_getmark surfs 1]

*createmark surfs 1 $fsdupsurflist
*movemark surfaces 1 "fsuntrimed"	


# #############################################################


#  untrimming both surfaces

set fssplitsurf1 [lindex $fsdupsurflist 0]
set fssplitsurf2 [lindex $fsdupsurflist 1]

*createmark surfaces 2 $fssplitsurf1 $fssplitsurf2 
*surfacemarkuntrim 2
# ########################################

#calculating area
set fsara1 [eval hm_getareaofsurface surfs $fssplitsurf1]

set fsara2 [eval hm_getareaofsurface surfs $fssplitsurf2]



#check greater area and delete small surface
    
	if { $fsara1 >= $fsara2} {
	    
		*createmark surfs 1 $fssplitsurf2
		*deletemark surfs 1
	 } else  {
         
         *createmark surfs 1 $fssplitsurf1		 
		 *deletemark surfs 1
     }
# #####################################################

#finding nearby edges and supress them

*createmark surfaces 1 "by comps" fsuntrimed
set fsuntrimedsurf [hm_getmark surfs 1]

set fsalledges [eval hm_getsurfaceedges $fsuntrimedsurf]

set fsedgelist [lindex $fsalledges 0]


set fslast [lindex $fsedgelist end-0]		
set fslast3 [lindex $fsedgelist end-2]      


*edgesmerge $fslast $fslast3 0.1


set fsalledges1 [eval hm_getsurfaceedges $fsuntrimedsurf]

set fsedgelist1 [lindex $fsalledges1 0]


set fslast1 [lindex $fsedgelist1 end-0]


*edgesuppress $fslast1	

*createmark lines 1 "by comps" fsuntrimed
	
		
# $fsuntrimedsurf is our main surface for extension


# }


#proc {} 2ndtrim { untrim3 untrim4


# ###### ls is used as prefix before each variable for 2nd surface operation
   
#create component named untrimed
     if {[hm_entityinfo exist components "lsuntrimed"] == 0} {
			
			*collectorcreateonly components "lsuntrimed" "" 5
	    }  else {
		    *createmark comps 1 "lsuntrimed"
            *deletemark comps 1
			*collectorcreateonly components "lsuntrimed" "" 5
	    }

        *clearmark surfs 1
		*clearmark surfs 2
# ############################################################		
       
#duplicate selected surfaces move in comp untrimmed
*createmark surfaces 2  $untrim3  $untrim4

*duplicatemark surfaces 2 1
*createmarklast surfaces 1
set lsdupsurflist [hm_getmark surfs 1]

*createmark surfs 1 $lsdupsurflist
*movemark surfaces 1 "lsuntrimed"	


# #############################################################


#  untrimming both surfaces

set lssplitsurf1 [lindex $lsdupsurflist 0]
set lssplitsurf2 [lindex $lsdupsurflist 1]

*createmark surfaces 2 $lssplitsurf1 $lssplitsurf2 
*surfacemarkuntrim 2
# ########################################

#calculating area
set lsara1 [eval hm_getareaofsurface surfs $lssplitsurf1]

set lsara2 [eval hm_getareaofsurface surfs $lssplitsurf2]



#check greater area and delete small surface
    
	if { $lsara1 >= $lsara2} {
	    
		*createmark surfs 1 $lssplitsurf2
		*deletemark surfs 1
	 } else  {
         
         *createmark surfs 1 $lssplitsurf1		 
		 *deletemark surfs 1
     }
# #####################################################

#finding nearby edges and supress them

*createmark surfaces 1 "by comps" lsuntrimed
set lsuntrimedsurf [hm_getmark surfs 1]

set lsalledges [eval hm_getsurfaceedges $lsuntrimedsurf]

set lsedgelist [lindex $lsalledges 0]


set lslast [lindex $lsedgelist end-0]		
set lslast3 [lindex $lsedgelist end-2]      


*edgesmerge $lslast $lslast3 0.1


set lsalledges1 [eval hm_getsurfaceedges $lsuntrimedsurf]

set lsedgelist1 [lindex $lsalledges1 0]


set lslast1 [lindex $lsedgelist1 end-0]


*edgesuppress $lslast1	

*createmark lines 1 "by comps" lsuntrimed

		
# $lsuntrimedsurf is our main surface for extension

# }

 

#ELEMENT SLECTION

    *saveviewmask "2" 0  


#		if {[hm_entityinfo exist components "elems___1"] == 0} {
#			
#			*collectorcreateonly components "elems___1" "" 5
#	    }  else {
#		    *createmark comps 1 "elems___1"
            
			
#	    }

        
		

		
 

#SURF1 SELECTION 

if {[hm_entityinfo exist components "dup1"] == 0} {
			
			*collectorcreateonly components "dup1" "" 5
	    }  else {
		    *createmark comps 1 "dup1"
            *deletemark comps 1
			*collectorcreateonly components "dup1" "" 5
	    }
		
		*clearmark surfs 1
        *createmark surfaces 1 $fsuntrimedsurf
        *duplicatemark surfaces 1 1
        *createmark surfs 1 -1
        set suf1 [hm_getmark surfs 1]


        *createmark surfs 1 $suf1
        *movemark surfaces 1 "dup1" 
        
	*createmark components 1 "dup1"
    *transparencymark 1
    *settransparency 1
    *transparencyvalue 7
	
#SURF2 SELECTION

		if {[hm_entityinfo exist components "dup2"] == 0} {
			
			*collectorcreateonly components "dup2" "" 3
	    }  else {
		    *createmark comps 1 "dup2"
            *deletemark comps 1
			*collectorcreateonly components "dup2" "" 3
	    }

        *clearmark surfs 1
        *createmark surfaces 1 $lsuntrimedsurf
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
    *transparencyvalue 4
	
	
		
        *createmarkpanel elems 1 
	    #*movemark elems 1 "elems___1"
		
		*morphcreatedomaindc elements 1 7 0 0 0 0
		*createmark domains 1 -1
		set doamianelem [hm_getmark domains 1]

        
        *morphupdateparameter "handlesize" 0.1

#SURF1 EXTEND		
		
      	
#					
#					*createmark components 2 "dup1"
#					*createstringarray 2 "elements_on" "geometry_on"
#					*isolateonlyentitybymark 2 1 2
#				   

				   

#					*clearmark surfs 1
#					*clearmark lines 1

#			*createmark surfaces 1 $suf1
#			*createmark surfaces 2
#			*createmark lines 1 "displayed"
#			*createmark lines 2
#			*connect_surfaces_11 1 2 4 0 10.0 15 45 1 0 2 30 3 0
#
#			*createmark surf 1 -1
#			set extsurf1 [hm_getmark surfs 1]
#
#			*clearmark surfs 1
#			*clearmark lines 1
#			*clearmark surfs 2
#			*clearmark lines 2
#
#					
#			*createmark components 2 "dup1"
#			*createstringarray 2 "elements_on" "geometry_on"
#			*hideentitybymark 2 1 2
#
#

				
			#SURF2 SELECTION AND EXTEND



					
#					*createmark components 2 "dup2"
#					*createstringarray 2 "elements_on" "geometry_on"
#					*isolateonlyentitybymark 2 1 2
#				   
#
#
#					*clearmark surfs 1
#					*clearmark lines 1
#
#			*createmark surfaces 1 $suf2
#			*createmark surfaces 2
#			*createmark lines 1 "displayed"
#			*createmark lines 2
#			*connect_surfaces_11 1 2 4 0 10.0 15 45 1 0 2 30 3 0
#
#			*createmark surf 1 -1
#			set extsurf2 [hm_getmark surfs 1]
#
#			*clearmark surfs 1
#			*clearmark lines 1
#			*clearmark surfs 2
#			*clearmark lines 2
#
#

#			*createmark components 2 "dup2"
#			*createstringarray 2 "elements_on" "geometry_on"
#			*hideentitybymark 2 1 2
#

#MID GENERATE AND ALIGN NODE

*createmark surfaces 1 $suf1 $suf2
*midsurfaceextract surfaces 1 1 0 0 0 undefined 0 0 1

*createmark surf 1 -1
set midsurftoelem [hm_getmark surfs 1]

 			#mid surface extend  EXTEND

		if {[hm_entityinfo exist components "midforextend"] == 0} {
			
			*collectorcreateonly components "midforextend" "" 3
	    }  else {
		    *createmark comps 1 "midforextend"
            *deletemark comps 1
			*collectorcreateonly components "midforextend" "" 3
	    }

        *createmark surfs 1 $midsurftoelem
        *movemark surfaces 1 "midforextend"	
					
					*createmark components 2 "midforextend"
					*createstringarray 2 "elements_on" "geometry_on"
					*isolateonlyentitybymark 2 1 2
				   
set lsalledges1 [eval hm_getsurfaceedges $midsurftoelem]

set lsedgelist1 [lindex $lsalledges1 0]


set lslast1 [lindex $lsedgelist1 end-0]


*edgesuppress $lslast1

					*clearmark surfs 1
					*clearmark lines 1

			*createmark surfaces 1 $midsurftoelem
			*createmark surfaces 2
			*createmark lines 1 "displayed"
			*createmark lines 2
			*connect_surfaces_11 1 2 4 0 $extentdistance 15 45 1 0 2 30 3 0

			*createmark surf 1 -1
			set extsurf2 [hm_getmark surfs 1]

			*clearmark surfs 1
			*clearmark lines 1
			*clearmark surfs 2
			*clearmark lines 2



			*createmark components 2 "dup2"
			*createstringarray 2 "elements_on" "geometry_on"
			*hideentitybymark 2 1 2

      
	  

*createmark elements 1 "by domains" $doamianelem
*markprojectnormallytosurface elements 1 $extsurf2

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
	*createmark comps 1 "lsuntrimed" "lsuntrimed" "fsuntrimed"
    *deletemark comps 1
*restoreviewmask "2" 0
}


if { [llength $nossufs] == 2} {

#ELEMENT SLECTION

     *saveviewmask "2" 0  


#		if {[hm_entityinfo exist components "elems___1"] == 0} {
#			
#			*collectorcreateonly components "elems___1" "" 5
#	    }  else {
#		    *createmark comps 1 "elems___1"
            
			
#	    }


		



set dupsurf1 [lindex $nossufs 0]
set dupsurf2 [lindex $nossufs 1] 

#SURF1 SELECTION 

if {[hm_entityinfo exist components "dup1"] == 0} {
			
			*collectorcreateonly components "dup1" "" 5
	    }  else {
		    *createmark comps 1 "dup1"
            *deletemark comps 1
			*collectorcreateonly components "dup1" "" 5
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
    *transparencyvalue 7	
	

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
*connect_surfaces_11 1 2 4 0 4.0 15 45 1 0 2 30 3 0

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
*connect_surfaces_11 1 2 4 0 10.0 15 45 1 0 2 30 3 0

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

}