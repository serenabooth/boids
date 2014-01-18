(* ADAPTED BY JO BOOTH AND CLAIRE STOLZ FROM 
$Id: simple.ml,v 1.1 2003/09/25 13:54:10 raffalli Exp $ *)

let gen_boid b =
  GlMat.mode `modelview; 
  let (red,grn,blu) = b#get_color_tuple in 
  GlDraw.color (red, grn, blu);    
  GlMat.load_identity ();
  let (boid_x,boid_y) = b#get_pos in
  GlMat.translate ~x:boid_x ~y:boid_y ~z:(0.0) ();
  GlMat.scale ~x:0.05 ~y:0.05 ~z:0.05 ();
  GlMat.rotate ~angle:(Helpers.heading b#get_vel) ~z:1.0 ();
  GlDraw.begins `polygon;
  GlDraw.vertex ~x:(0.0) ~y:(0.2) ();
  GlDraw.color (0.0, 0.0, 0.0);
  GlDraw.vertex ~x:(0.1) ~y:(-0.2) ();
  GlDraw.vertex ~x:(0.0) ~y:(-0.05) ();
  GlDraw.vertex ~x:(-0.1) ~y:(-0.2) ();
  GlDraw.ends ()

let gen_predator p =
  GlMat.mode `modelview;  
  let (red,grn,blu) = p#get_color_tuple in 
  GlDraw.color (red, grn, blu);    
  GlMat.load_identity ();
  let (pred_x,pred_y) = p#get_pos in
  GlMat.translate ~x:pred_x ~y:pred_y ~z:(0.0) ();
  GlMat.scale ~x:0.1 ~y:0.1 ~z:0.1 ();
  GlMat.rotate ~angle:(Helpers.heading p#get_vel) ~z:1.0 ();
  GlDraw.begins `polygon;
  GlDraw.vertex ~x:(0.0) ~y:(0.2) ();
  GlDraw.color (0.0, 0.0, 0.0);
  GlDraw.vertex ~x:(0.1) ~y:(-0.2) ();
  GlDraw.vertex ~x:(0.0) ~y:(-0.05) ();
  GlDraw.vertex ~x:(-0.1) ~y:(-0.2) ();
  GlDraw.ends ()

let gen_obstacle o =
  GlMat.mode `modelview;  
  let (red,grn,blu) = o#get_color_tuple in 
  GlDraw.color (red, grn, blu);   
  GlMat.load_identity ();
  let (obs_x,obs_y) = o#get_pos in
  GlMat.translate ~x:obs_x ~y:obs_y ~z:(0.0) ();
  GlMat.scale ~x:0.3 ~y:0.3 ~z:0.3 ();
  GlDraw.begins `polygon;
  GlDraw.vertex ~x:(-0.05) ~y:(-0.05) ();
  GlDraw.vertex ~x:(-0.05) ~y:(0.05) ();
  GlDraw.vertex ~x:(0.05) ~y:(0.05) ();
  GlDraw.vertex ~x:(0.05) ~y:(-0.05) ();
  GlDraw.ends ()

let gen_food f =
  GlMat.mode `modelview;  
  let (red,grn,blu) = f#get_color_tuple in 
  GlDraw.color (red, grn, blu);    
  GlMat.load_identity ();
  let (fd_x,fd_y) = f#get_pos in
  GlMat.translate ~x:fd_x ~y:fd_y ~z:(0.0) ();
  GlMat.scale ~x:0.05 ~y:0.05 ~z:0.1 ();
  GlDraw.begins `polygon;
  GlDraw.vertex ~x:(-0.05) ~y:(-0.05) ();
  GlDraw.vertex ~x:(-0.05) ~y:(0.05) ();
  GlDraw.vertex ~x:(0.05) ~y:(0.05) ();
  GlDraw.vertex ~x:(0.05) ~y:(-0.05) ();
  GlDraw.ends ()

let main () =
  ignore(Glut.init Sys.argv);
  Glut.initDisplayMode ~alpha:true ~depth:true () ;
  Glut.initWindowSize ~w:1770 ~h:1000 ;
  ignore(Glut.createWindow ~title:"lablglut & LablGL");
  Glut.displayFunc ~cb:
    begin fun () -> (* display callback *)
      Event.Event.fire_event World.time_event ();
      GlClear.color (0.00, 0.0, 0.0);
      GlClear.clear [`color];
      GlMat.mode `projection;
      GlMat.load_identity ();
      GlMat.ortho ~x:(-0.0,1.77) ~y:(-0.0,1.0) ~z:(-1.0,1.0);
      World.iter_all (fun x -> match x#get_name with 
      | "boid" -> gen_boid x
      | "obstacle" -> gen_obstacle x
      | "food" -> gen_food x
      | "predator" -> gen_predator x
      | _ -> () 
      );
      Gl.flush ()
    end;
      let rec _timedUpdate ~value = 
      (*planet#tick (Unix.gettimeofday()); *)
      Glut.postRedisplay();
      Glut.timerFunc ~ms:20 ~cb:_timedUpdate ~value:0
      in
  Glut.timerFunc ~ms:20 ~cb:_timedUpdate ~value:0; 
  (* ignore (Timer.add ~ms:10000 ~callback:(fun () -> exit 0));  *)
  Glut.keyboardFunc ~cb:(fun ~key ~x ~y -> match key with
    | 119 (*W*) -> ( match !(World.mv_world) with 
                   | None -> ()
                   | Some w -> w#move_up)
    | 97  (*A*) -> ( match !(World.mv_world) with 
                   | None -> ()
                   | Some w -> w#move_left)
    | 115 (*S*) -> ( match !(World.mv_world) with 
                   | None -> ()
                   | Some w -> w#move_down)
    | 100 (*D*) -> ( match !(World.mv_world) with 
                   | None -> ()
                   | Some w -> w#move_right)
    | 61  (*+*) ->  
      ignore (World.add (new Boid.boid (World.rand_pos()) (World.rand_vel())))
    | 45  (*-*) -> ignore (World.take "boid")
    | 112 (*P*) ->( match World.has_mv () with 
                   | true ->  (ignore (World.remove_mv())) 
                   | false -> (ignore (World.add_mv (new Predator.predator 
                         (World.rand_pos()) (World.rand_vel())))))
    | 104 (*H*) -> ( match World.has_mv () with 
                   | true ->  (ignore (World.remove_mv())) 
                   | false -> (ignore (World.add_mv (new PuppetBoid.puppet
                         (World.rand_pos()) (World.rand_vel())))))
    | 114 (*R*) -> ignore (World.take "obstacle")
    | _ -> ());
  Glut.mouseFunc ~cb:(fun ~button ~state ~x ~y -> match(button,state,x,y) with
    | (Glut.LEFT_BUTTON,Glut.DOWN,x1,x2) -> 
      let x = 
      (float_of_int(x1) /. float_of_int(Glut.get(Glut.WINDOW_WIDTH))) *. 1.77 in
      let y = float_of_int(x2) /. float_of_int(Glut.get(Glut.WINDOW_HEIGHT)) in
        for i = 1 to 12 do
          ignore (World.add (new Food.food (World.rand_pos_near (x,1. -. y))))
        done
        (* Make breadcrumbs *) 
    | (Glut.RIGHT_BUTTON,Glut.DOWN,x1,x2) ->
      let x = 
      (float_of_int(x1) /. float_of_int(Glut.get(Glut.WINDOW_WIDTH))) *. 1.77 in
      let y = float_of_int(x2) /. float_of_int(Glut.get(Glut.WINDOW_HEIGHT)) in
        ignore (World.add (new Obstacle.obstacle (x, 1. -. y)))
    | _ -> ());
  Glut.mainLoop()
  

let _ =
  print_string " \n\n            OCAMLBOIDS!!!!!111 \n \n";
  print_string "     Press '+' to add boids; '-' to remove \n";
  print_string "     Press 'P' to add/remove a predator \n";
  print_string "     Press 'H' to add/remove a puppet boid \n"; 
  print_string "     Steer with WASD \n"; 
  print_string "     Left-click to scatter food \n"; 
  print_string "     Right-click to set an obtactle \n";
  print_string "     Press 'R' to remove obstacles \n"; 
  print_string "     Have fun! \n\n";

  flush_all()

let _ = main ()

