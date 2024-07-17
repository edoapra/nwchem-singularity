#!/usr/bin/env bash
rm -f scalasl2.patch
cat > scalasl2.patch <<EOF
--- $1/global/src/scalapack.F.org	2024-07-17 12:30:40.311056254 -0700
+++ $1/global/src/scalapack.F	2024-07-17 13:06:10.100675916 -0700
@@ -1334,7 +1334,7 @@
       if (use_direct) then
         call SLinit3(g_A)
       else
-        call SLinit()
+        call SLinit2(n)
       endif
 c      oactive=iam.lt.maxproc
       oactive=.true.
@@ -1342,8 +1342,8 @@
 
 c**** Find SBS format parameters
       if(oactive) then
-         mpA = numroc(n, nb, myrow, zero4, nprow)
-         nqA = numroc(n, nb, mycol, zero4, npcol)
+         mpA = numroc(n, nb, myrow2, zero4, nprow2)
+         nqA = numroc(n, nb, mycol2, zero4, npcol2)
          ldA = max(one4,mpA)
          
          
@@ -1366,7 +1366,7 @@
          
 c**** Copy ga to A using SBS ScaLAPACK format      
          if (.not.use_direct) then
-           call ga_to_SL(g_a, n, n, nb, nb, dbl_mb(adrA), ldA, mpA, nqA)
+          call ga_to_SL2(g_a, n, n, nb, nb, dbl_mb(adrA), ldA, mpA, nqA)
          endif
          endif
          call ga_sync()
@@ -1387,7 +1387,7 @@
 c**** and zero the L/U triangle part according to uplo         
             if (hsA.eq.-1) then
               if (.not.use_direct) then
-                call ga_from_SL(g_A, dimA1, dimA2, nb, nb, dbl_mb(adrA),
+               call ga_from_SL2(g_A, dimA1, dimA2, nb, nb, dbl_mb(adrA),
      &             mpA, ldA, nqA)
               endif
             endif
@@ -1436,7 +1436,7 @@
       if (use_direct) then
         call slexit3
       else
-        call slexit
+        call slexit2
       endif
       end
 
@@ -1751,15 +1751,15 @@
       if (use_direct) then
         call SLinit3(g_A)
       else
-        call SLinit()
+        call SLinit2(n)
       endif
 c      oactive=iam.lt.maxproc
       oactive=.true.
       call ga_sync()
       if(oactive) then
 c**** Find SBS format parameters
-        mpA = numroc(n, nb, myrow, zero4, nprow)
-        nqA = numroc(n, nb, mycol, zero4, npcol)
+        mpA = numroc(n, nb, myrow2, zero4, nprow2)
+        nqA = numroc(n, nb, mycol2, zero4, npcol2)
         ldA = max(one4, mpA)
 
 
@@ -1775,7 +1775,7 @@
                    if (.not.status)
      &               call ga_error(' ga_llt_i: mem alloc failed A ', -1)
 c****       copy g_A to A using SBS SL format
-                   call ga_to_SL(g_A, n, n, nb, nb, dbl_mb(adrA),
+                   call ga_to_SL2(g_A, n, n, nb, nb, dbl_mb(adrA),
      &                           ldA, mpA, nqA)
                 else
                    hA = hsA
@@ -1805,7 +1805,7 @@
           if (info.eq.0) then
 c****    Copy the inverse matrix back to A
 c****    and symmetrize it         
-             call ga_from_SL(g_A, dimA1, dimA2, nb, nb, dbl_mb(adrA),
+             call ga_from_SL2(g_A, dimA1, dimA2, nb, nb, dbl_mb(adrA),
      &            mpA, ldA, nqA)
          
           endif
EOF
patch -p0 -s -N < ./scalasl2.patch
echo scalasl2.patch applied
