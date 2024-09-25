import random as rnd

def S5(x, y):
  z = [0 for _ in range(13)]

  refX_7 = rnd.randrange(0,2)
  refX_8 = rnd.randrange(0,2)
  refX_9 = rnd.randrange(0,2)
  refX_10 = rnd.randrange(0,2)
  refX_11 = rnd.randrange(0,2)
  refX_12 = rnd.randrange(0,2)
  refY_7 = rnd.randrange(0,2)
  refY_8 = rnd.randrange(0,2)
  refY_9 = rnd.randrange(0,2)
  refY_10 = rnd.randrange(0,2)
  refY_11 = rnd.randrange(0,2)
  refY_12 = rnd.randrange(0,2)
  refZ_7 = rnd.randrange(0,2)
  refZ_8 = rnd.randrange(0,2)
  refZ_9 = rnd.randrange(0,2)
  refZ_10 = rnd.randrange(0,2)
  refZ_11 = rnd.randrange(0,2)
  refZ_12 = rnd.randrange(0,2)
  v0 = rnd.randrange(0,2)
  v1 = rnd.randrange(0,2)
  v2 = rnd.randrange(0,2)
  v3 = rnd.randrange(0,2)
  v4 = rnd.randrange(0,2)
  v5 = rnd.randrange(0,2)
  v6 = rnd.randrange(0,2)
  srnd7_0 = rnd.randrange(0,2)
  srnd7_1 = rnd.randrange(0,2)
  srnd7_2 = rnd.randrange(0,2)
  srnd7_3 = rnd.randrange(0,2)
  srnd7_4 = rnd.randrange(0,2)
  srnd7_5 = rnd.randrange(0,2)
  srnd8_0 = rnd.randrange(0,2)
  srnd8_1 = rnd.randrange(0,2)
  srnd8_2 = rnd.randrange(0,2)
  srnd8_3 = rnd.randrange(0,2)
  srnd8_4 = rnd.randrange(0,2)
  srnd8_5 = rnd.randrange(0,2)
  srnd9_0 = rnd.randrange(0,2)
  srnd9_1 = rnd.randrange(0,2)
  srnd9_2 = rnd.randrange(0,2)
  srnd9_3 = rnd.randrange(0,2)
  srnd9_4 = rnd.randrange(0,2)
  srnd9_5 = rnd.randrange(0,2)
  srnd10_0 = rnd.randrange(0,2)
  srnd10_1 = rnd.randrange(0,2)
  srnd10_2 = rnd.randrange(0,2)
  srnd10_3 = rnd.randrange(0,2)
  srnd10_4 = rnd.randrange(0,2)
  srnd10_5 = rnd.randrange(0,2)
  srnd11_0 = rnd.randrange(0,2)
  srnd11_1 = rnd.randrange(0,2)
  srnd11_2 = rnd.randrange(0,2)
  srnd11_3 = rnd.randrange(0,2)
  srnd11_4 = rnd.randrange(0,2)
  srnd11_5 = rnd.randrange(0,2)
  srnd12_0 = rnd.randrange(0,2)
  srnd12_1 = rnd.randrange(0,2)
  srnd12_2 = rnd.randrange(0,2)
  srnd12_3 = rnd.randrange(0,2)
  srnd12_4 = rnd.randrange(0,2)
  srnd12_5 = rnd.randrange(0,2)
  r0_1 = rnd.randrange(0,2)
  r0_2 = rnd.randrange(0,2)
  r0_3 = rnd.randrange(0,2)
  r0_4 = rnd.randrange(0,2)
  r0_5 = rnd.randrange(0,2)
  r1_2 = rnd.randrange(0,2)
  r1_3 = rnd.randrange(0,2)
  r1_4 = rnd.randrange(0,2)
  r1_5 = rnd.randrange(0,2)
  r2_3 = rnd.randrange(0,2)
  r2_4 = rnd.randrange(0,2)
  r2_5 = rnd.randrange(0,2)
  r3_4 = rnd.randrange(0,2)
  r3_5 = rnd.randrange(0,2)
  r4_5 = rnd.randrange(0,2)


  x0 = x[0]
  x1 = x[1]
  x2 = x[2]
  x3 = x[3]
  x4 = x[4]
  x5 = x[5]
  x6 = x[6]
  x7 = x[7] ^ refX_7
  x8 = x[8] ^ refX_8
  x9 = x[9] ^ refX_9
  x10 = x[10] ^ refX_10
  x11 = x[11] ^ refX_11
  x12 = x[12] ^ refX_12

  y0 = y[0]
  y1 = y[1]
  y2 = y[2]
  y3 = y[3]
  y4 = y[4]
  y5 = y[5]
  y6 = y[6]
  y7 = y[7] ^ refY_7
  y8 = y[8] ^ refY_8
  y9 = y[9] ^ refY_9
  y10 = y[10] ^ refY_10
  y11 = y[11] ^ refY_11
  y12 = y[12] ^ refY_12

  #(* ----------Phase 1---------- *)

  #(* line 1 *)
  t1_1_0 = x1 & y0
  t2_1_0 = t1_1_0 ^ r0_1
  t3_1_0 = x0 & y1
  t4_1_0 = t3_1_0 ^ t2_1_0


  #(* line 2 *)
  t1_2_0 = x2 & y0
  t2_2_0 = t1_2_0 ^ r0_2
  t3_2_0 = x0 & y2
  t4_2_0 = t3_2_0 ^ t2_2_0

  t1_2_1 = x2 & y1
  t2_2_1 = t1_2_1 ^ r1_2
  t3_2_1 = x1 & y2
  t4_2_1 = t3_2_1 ^ t2_2_1


  #(* line 3 *)
  t1_3_0 = x3 & y0
  t2_3_0 = t1_3_0 ^ r0_3
  t3_3_0 = x0 & y3
  t4_3_0 = t3_3_0 ^ t2_3_0

  t1_3_1 = x3 & y1
  t2_3_1 = t1_3_1 ^ r1_3
  t3_3_1 = x1 & y3
  t4_3_1 = t3_3_1 ^ t2_3_1

  t1_3_2 = x3 & y2
  t2_3_2 = t1_3_2 ^ r2_3
  t3_3_2 = x2 & y3
  t4_3_2 = t3_3_2 ^ t2_3_2


  #(* line 4 *)
  t1_4_0 = x4 & y0
  t2_4_0 = t1_4_0 ^ r0_4
  t3_4_0 = x0 & y4
  t4_4_0 = t3_4_0 ^ t2_4_0

  t1_4_1 = x4 & y1
  t2_4_1 = t1_4_1 ^ r1_4
  t3_4_1 = x1 & y4
  t4_4_1 = t3_4_1 ^ t2_4_1

  t1_4_2 = x4 & y2
  t2_4_2 = t1_4_2 ^ r2_4
  t3_4_2 = x2 & y4
  t4_4_2 = t3_4_2 ^ t2_4_2

  t1_4_3 = x4 & y3
  t2_4_3 = t1_4_3 ^ r3_4
  t3_4_3 = x3 & y4
  t4_4_3 = t3_4_3 ^ t2_4_3


  #(* line 5 *)
  t1_5_0 = x5 & y0
  t2_5_0 = t1_5_0 ^ r0_5
  t3_5_0 = x0 & y5
  t4_5_0 = t3_5_0 ^ t2_5_0

  t1_5_1 = x5 & y1
  t2_5_1 = t1_5_1 ^ r1_5
  t3_5_1 = x1 & y5
  t4_5_1 = t3_5_1 ^ t2_5_1

  t1_5_2 = x5 & y2
  t2_5_2 = t1_5_2 ^ r2_5
  t3_5_2 = x2 & y5
  t4_5_2 = t3_5_2 ^ t2_5_2

  t1_5_3 = x5 & y3
  t2_5_3 = t1_5_3 ^ r3_5
  t3_5_3 = x3 & y5
  t4_5_3 = t3_5_3 ^ t2_5_3

  t1_5_4 = x5 & y4
  t2_5_4 = t1_5_4 ^ r4_5
  t3_5_4 = x4 & y5
  t4_5_4 = t3_5_4 ^ t2_5_4

  u0 = x0 & y0
  u1 = x1 & y1
  u2 = x2 & y2
  u3 = x3 & y3
  u4 = x4 & y4
  u5 = x5 & y5

  #(* ----------Phase 2---------- *)

  #(* line 6 *)
  w1_6_0 = x0 & y6
  w2_6_0 = w1_6_0 ^ v0
  w3_6_0 = x6 & y0
  w4_6_0 = w3_6_0 ^ w2_6_0

  w1_6_1 = x1 & y6
  w2_6_1 = w1_6_1 ^ v1
  w3_6_1 = x6 & y1
  w4_6_1 = w3_6_1 ^ w2_6_1

  w1_6_2 = x2 & y6
  w2_6_2 = w1_6_2 ^ v2
  w3_6_2 = x6 & y2
  w4_6_2 = w3_6_2 ^ w2_6_2

  w1_6_3 = x3 & y6
  w2_6_3 = w1_6_3 ^ v3
  w3_6_3 = x6 & y3
  w4_6_3 = w3_6_3 ^ w2_6_3

  w1_6_4 = x4 & y6
  w2_6_4 = w1_6_4 ^ v4
  w3_6_4 = x6 & y4
  w4_6_4 = w3_6_4 ^ w2_6_4

  w1_6_5 = x5 & y6
  w2_6_5 = w1_6_5 ^ v5
  w3_6_5 = x6 & y5
  w4_6_5 = w3_6_5 ^ w2_6_5


  #(* line 7 *)
  w1_7_0 = x0 & y7
  w2_7_0 = w1_7_0 ^ v0
  w3_7_0 = x7 & y0
  w4_7_0 = w3_7_0 ^ w2_7_0

  w1_7_1 = x1 & y7
  w2_7_1 = w1_7_1 ^ v1
  w3_7_1 = x7 & y1
  w4_7_1 = w3_7_1 ^ w2_7_1

  w1_7_2 = x2 & y7
  w2_7_2 = w1_7_2 ^ v2
  w3_7_2 = x7 & y2
  w4_7_2 = w3_7_2 ^ w2_7_2

  w1_7_3 = x3 & y7
  w2_7_3 = w1_7_3 ^ v3
  w3_7_3 = x7 & y3
  w4_7_3 = w3_7_3 ^ w2_7_3

  w1_7_4 = x4 & y7
  w2_7_4 = w1_7_4 ^ v4
  w3_7_4 = x7 & y4
  w4_7_4 = w3_7_4 ^ w2_7_4

  w1_7_5 = x5 & y7
  w2_7_5 = w1_7_5 ^ v5
  w3_7_5 = x7 & y5
  w4_7_5 = w3_7_5 ^ w2_7_5


  #(* line 8 *)
  w1_8_0 = x0 & y8
  w2_8_0 = w1_8_0 ^ v0
  w3_8_0 = x8 & y0
  w4_8_0 = w3_8_0 ^ w2_8_0

  w1_8_1 = x1 & y8
  w2_8_1 = w1_8_1 ^ v1
  w3_8_1 = x8 & y1
  w4_8_1 = w3_8_1 ^ w2_8_1

  w1_8_2 = x2 & y8
  w2_8_2 = w1_8_2 ^ v2
  w3_8_2 = x8 & y2
  w4_8_2 = w3_8_2 ^ w2_8_2

  w1_8_3 = x3 & y8
  w2_8_3 = w1_8_3 ^ v3
  w3_8_3 = x8 & y3
  w4_8_3 = w3_8_3 ^ w2_8_3

  w1_8_4 = x4 & y8
  w2_8_4 = w1_8_4 ^ v4
  w3_8_4 = x8 & y4
  w4_8_4 = w3_8_4 ^ w2_8_4

  w1_8_5 = x5 & y8
  w2_8_5 = w1_8_5 ^ v5
  w3_8_5 = x8 & y5
  w4_8_5 = w3_8_5 ^ w2_8_5


  #(* line 9 *)
  w1_9_0 = x0 & y9
  w2_9_0 = w1_9_0 ^ v0
  w3_9_0 = x9 & y0
  w4_9_0 = w3_9_0 ^ w2_9_0

  w1_9_1 = x1 & y9
  w2_9_1 = w1_9_1 ^ v1
  w3_9_1 = x9 & y1
  w4_9_1 = w3_9_1 ^ w2_9_1

  w1_9_2 = x2 & y9
  w2_9_2 = w1_9_2 ^ v2
  w3_9_2 = x9 & y2
  w4_9_2 = w3_9_2 ^ w2_9_2

  w1_9_3 = x3 & y9
  w2_9_3 = w1_9_3 ^ v3
  w3_9_3 = x9 & y3
  w4_9_3 = w3_9_3 ^ w2_9_3

  w1_9_4 = x4 & y9
  w2_9_4 = w1_9_4 ^ v4
  w3_9_4 = x9 & y4
  w4_9_4 = w3_9_4 ^ w2_9_4

  w1_9_5 = x5 & y9
  w2_9_5 = w1_9_5 ^ v5
  w3_9_5 = x9 & y5
  w4_9_5 = w3_9_5 ^ w2_9_5


  #(* line 10 *)
  w1_10_0 = x0 & y10
  w2_10_0 = w1_10_0 ^ v0
  w3_10_0 = x10 & y0
  w4_10_0 = w3_10_0 ^ w2_10_0

  w1_10_1 = x1 & y10
  w2_10_1 = w1_10_1 ^ v1
  w3_10_1 = x10 & y1
  w4_10_1 = w3_10_1 ^ w2_10_1

  w1_10_2 = x2 & y10
  w2_10_2 = w1_10_2 ^ v2
  w3_10_2 = x10 & y2
  w4_10_2 = w3_10_2 ^ w2_10_2

  w1_10_3 = x3 & y10
  w2_10_3 = w1_10_3 ^ v3
  w3_10_3 = x10 & y3
  w4_10_3 = w3_10_3 ^ w2_10_3

  w1_10_4 = x4 & y10
  w2_10_4 = w1_10_4 ^ v4
  w3_10_4 = x10 & y4
  w4_10_4 = w3_10_4 ^ w2_10_4

  w1_10_5 = x5 & y10
  w2_10_5 = w1_10_5 ^ v5
  w3_10_5 = x10 & y5
  w4_10_5 = w3_10_5 ^ w2_10_5


  #(* line 11 *)
  w1_11_0 = x0 & y11
  w2_11_0 = w1_11_0 ^ v0
  w3_11_0 = x11 & y0
  w4_11_0 = w3_11_0 ^ w2_11_0

  w1_11_1 = x1 & y11
  w2_11_1 = w1_11_1 ^ v1
  w3_11_1 = x11 & y1
  w4_11_1 = w3_11_1 ^ w2_11_1

  w1_11_2 = x2 & y11
  w2_11_2 = w1_11_2 ^ v2
  w3_11_2 = x11 & y2
  w4_11_2 = w3_11_2 ^ w2_11_2

  w1_11_3 = x3 & y11
  w2_11_3 = w1_11_3 ^ v3
  w3_11_3 = x11 & y3
  w4_11_3 = w3_11_3 ^ w2_11_3

  w1_11_4 = x4 & y11
  w2_11_4 = w1_11_4 ^ v4
  w3_11_4 = x11 & y4
  w4_11_4 = w3_11_4 ^ w2_11_4

  w1_11_5 = x5 & y11
  w2_11_5 = w1_11_5 ^ v5
  w3_11_5 = x11 & y5
  w4_11_5 = w3_11_5 ^ w2_11_5


  #(* line 12 *)
  w1_12_0 = x0 & y12
  w2_12_0 = w1_12_0 ^ v0
  w3_12_0 = x12 & y0
  w4_12_0 = w3_12_0 ^ w2_12_0

  w1_12_1 = x1 & y12
  w2_12_1 = w1_12_1 ^ v1
  w3_12_1 = x12 & y1
  w4_12_1 = w3_12_1 ^ w2_12_1

  w1_12_2 = x2 & y12
  w2_12_2 = w1_12_2 ^ v2
  w3_12_2 = x12 & y2
  w4_12_2 = w3_12_2 ^ w2_12_2

  w1_12_3 = x3 & y12
  w2_12_3 = w1_12_3 ^ v3
  w3_12_3 = x12 & y3
  w4_12_3 = w3_12_3 ^ w2_12_3

  w1_12_4 = x4 & y12
  w2_12_4 = w1_12_4 ^ v4
  w3_12_4 = x12 & y4
  w4_12_4 = w3_12_4 ^ w2_12_4

  w1_12_5 = x5 & y12
  w2_12_5 = w1_12_5 ^ v5
  w3_12_5 = x12 & y5
  w4_12_5 = w3_12_5 ^ w2_12_5


  u6 = x6 & y6
  u7 = x7 & y7
  u8 = x8 & y8
  u9 = x9 & y9
  u10 = x10 & y10
  u11 = x11 & y11
  u12 = x12 & y12

  #(* ----------Phase 3---------- *)

  z0_0 = v0 ^ u0
  z0_1 = v1 ^ u1
  z0_2 = v2 ^ u2
  z0_3 = v3 ^ u3
  z0_4 = v4 ^ u4
  z0_5 = v5 ^ u5
  z0_6 = v6 ^ u6


  #(* line 0 *)
  z1_0 = z0_0 ^ r0_1
  z2_0 = z1_0 ^ r0_2
  z3_0 = z2_0 ^ r0_3
  z4_0 = z3_0 ^ r0_4
  z5_0 = z4_0 ^ r0_5


  #(* line 1 *)
  z1_1 = z0_1 ^ t4_1_0
  z2_1 = z1_1 ^ r1_2
  z3_1 = z2_1 ^ r1_3
  z4_1 = z3_1 ^ r1_4
  z5_1 = z4_1 ^ r1_5


  #(* line 2 *)
  z1_2 = z0_2 ^ t4_2_0
  z2_2 = z1_2 ^ t4_2_1
  z3_2 = z2_2 ^ r2_3
  z4_2 = z3_2 ^ r2_4
  z5_2 = z4_2 ^ r2_5


  #(* line 3 *)
  z1_3 = z0_3 ^ t4_3_0
  z2_3 = z1_3 ^ t4_3_1
  z3_3 = z2_3 ^ t4_3_2
  z4_3 = z3_3 ^ r3_4
  z5_3 = z4_3 ^ r3_5


  #(* line 4 *)
  z1_4 = z0_4 ^ t4_4_0
  z2_4 = z1_4 ^ t4_4_1
  z3_4 = z2_4 ^ t4_4_2
  z4_4 = z3_4 ^ t4_4_3
  z5_4 = z4_4 ^ r4_5


  #(* line 5 *)
  z1_5 = z0_5 ^ t4_5_0
  z2_5 = z1_5 ^ t4_5_1
  z3_5 = z2_5 ^ t4_5_2
  z4_5 = z3_5 ^ t4_5_3
  z5_5 = z4_5 ^ t4_5_4

  z[0] = z5_0
  z[1] = z5_1
  z[2] = z5_2
  z[3] = z5_3
  z[4] = z5_4
  z[5] = z5_5

  #(* ----------Phase 4---------- *)

  z0_6 = w4_6_0 ^ u6
  ref0_7 = srnd7_0 ^ w4_7_0
  z0_7 = ref0_7 ^ u7
  ref0_8 = srnd8_0 ^ w4_8_0
  z0_8 = ref0_8 ^ u8
  ref0_9 = srnd9_0 ^ w4_9_0
  z0_9 = ref0_9 ^ u9
  ref0_10 = srnd10_0 ^ w4_10_0
  z0_10 = ref0_10 ^ u10
  ref0_11 = srnd11_0 ^ w4_11_0
  z0_11 = ref0_11 ^ u11
  ref0_12 = srnd12_0 ^ w4_12_0
  z0_12 = ref0_12 ^ u12


  #(* line 6 *)
  z1_6 = z0_6 ^ w4_6_1
  z2_6 = z1_6 ^ w4_6_2
  z3_6 = z2_6 ^ w4_6_3
  z4_6 = z3_6 ^ w4_6_4
  z5_6 = z4_6 ^ w4_6_5

  #(* line 7 *)
  ref1_7 = srnd7_1 ^ w4_7_1
  z1_7 = z0_7 ^ ref1_7
  ref2_7 = srnd7_2 ^ w4_7_2
  z2_7 = z1_7 ^ ref2_7
  ref3_7 = srnd7_3 ^ w4_7_3
  z3_7 = z2_7 ^ ref3_7
  ref4_7 = srnd7_4 ^ w4_7_4
  z4_7 = z3_7 ^ ref4_7
  ref5_7 = srnd7_5 ^ w4_7_5
  z5_7 = z4_7 ^ ref5_7


  #(* line 8 *)
  ref1_8 = srnd8_1 ^ w4_8_1
  z1_8 = z0_8 ^ ref1_8
  ref2_8 = srnd8_2 ^ w4_8_2
  z2_8 = z1_8 ^ ref2_8
  ref3_8 = srnd8_3 ^ w4_8_3
  z3_8 = z2_8 ^ ref3_8
  ref4_8 = srnd8_4 ^ w4_8_4
  z4_8 = z3_8 ^ ref4_8
  ref5_8 = srnd8_5 ^ w4_8_5
  z5_8 = z4_8 ^ ref5_8


  #(* line 9 *)
  ref1_9 = srnd9_1 ^ w4_9_1
  z1_9 = z0_9 ^ ref1_9
  ref2_9 = srnd9_2 ^ w4_9_2
  z2_9 = z1_9 ^ ref2_9
  ref3_9 = srnd9_3 ^ w4_9_3
  z3_9 = z2_9 ^ ref3_9
  ref4_9 = srnd9_4 ^ w4_9_4
  z4_9 = z3_9 ^ ref4_9
  ref5_9 = srnd9_5 ^ w4_9_5
  z5_9 = z4_9 ^ ref5_9


  #(* line 10 *)
  ref1_10 = srnd10_1 ^ w4_10_1
  z1_10 = z0_10 ^ ref1_10
  ref2_10 = srnd10_2 ^ w4_10_2
  z2_10 = z1_10 ^ ref2_10
  ref3_10 = srnd10_3 ^ w4_10_3
  z3_10 = z2_10 ^ ref3_10
  ref4_10 = srnd10_4 ^ w4_10_4
  z4_10 = z3_10 ^ ref4_10
  ref5_10 = srnd10_5 ^ w4_10_5
  z5_10 = z4_10 ^ ref5_10


  #(* line 11 *)
  ref1_11 = srnd11_1 ^ w4_11_1
  z1_11 = z0_11 ^ ref1_11
  ref2_11 = srnd11_2 ^ w4_11_2
  z2_11 = z1_11 ^ ref2_11
  ref3_11 = srnd11_3 ^ w4_11_3
  z3_11 = z2_11 ^ ref3_11
  ref4_11 = srnd11_4 ^ w4_11_4
  z4_11 = z3_11 ^ ref4_11
  ref5_11 = srnd11_5 ^ w4_11_5
  z5_11 = z4_11 ^ ref5_11


  #(* line 12 *)
  ref1_12 = srnd12_1 ^ w4_12_1
  z1_12 = z0_12 ^ ref1_12
  ref2_12 = srnd12_2 ^ w4_12_2
  z2_12 = z1_12 ^ ref2_12
  ref3_12 = srnd12_3 ^ w4_12_3
  z3_12 = z2_12 ^ ref3_12
  ref4_12 = srnd12_4 ^ w4_12_4
  z4_12 = z3_12 ^ ref4_12
  ref5_12 = srnd12_5 ^ w4_12_5
  z5_12 = z4_12 ^ ref5_12


  #(* ----------Refreshing Outputs---------- *)

  z[6] = z5_6
  z[7] = z5_7 ^ refZ_7
  z[8] = z5_8 ^ refZ_8
  z[9] = z5_9 ^ refZ_9
  z[10] = z5_10 ^ refZ_10
  z[11] = z5_11 ^ refZ_11
  z[12] = z5_12 ^ refZ_12

  return(z)

for i in range(100):
  x = [rnd.randrange(0,2) for _ in range(13)]
  y = [rnd.randrange(0,2) for _ in range(13)]

  z = S5(x,y)

  X = 0
  Y = 0
  Z = 0
  for j in range(7):
    X ^= x[j]
    Y ^= y[j]
    Z ^= z[j]
  assert(X&Y == Z)


print("S5 AND gadget computes x&y correctly for 100 random inputs")
print("Number of XORs: 247")
print("Number of ANDs: 127")
