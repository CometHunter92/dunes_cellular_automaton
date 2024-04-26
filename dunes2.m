%% to do:
%% rewrite it with nested functions 
%% implement avalanching with selectable moore neirghborhood
%% usare mod per tutte le next altrimenti con it ++ va fuori bounds (raramente)

function [grid,grid_init] = dunes2(rows, cols, min_sand, sand, wind, steps, slope, erosion,fact)
    % Initialize the game grid with random values (1 or 0)
    grid = randi([min_sand, sand], rows, cols);
    grid_init = grid;
    % Display the initial state of the grid
    %disp('Initial State:');
    %disp(grid);
    imagesc(grid)
    colorbar    

if wind == 0 || wind > 15
   return    
end

%if max(grid,[],"all") > 350
  %  wind = wind +1;
%end

ticks = round(wind*fact*rows*cols);
hop = round(wind);

    % Iterate through steps
    c = 1;
    for c = 1:steps
        % Sand movement
        i = 1;
  for i = 1:ticks
      x = randi(cols);
      y = randi(rows);

  if grid(y,x) == 0                  %% barebone cell
     continue
  end
  %% shadowed cell
  
  %for sx = -3:-1
  sx = -1;
  if x + sx  < 1
      x_shad = x + sx + cols;
  else
      x_shad = x + sx;
  end
  if (grid(y,x_shad) - grid(y,x)) > (abs(sx)) + 24   
     continue
  end
  %end

  grid(y,x) = grid(y,x) - 1;   % erosion
 
  deposited = 0;
  ite = 1;
  while deposited == 0
  jump = hop*ite;
  if hop*ite > cols
     jump = jump - cols;
  end
  x_next = x + jump;
  if x_next > cols
      x_next = x_next - cols;
  end
  prob = rand;
  if grid(y,x_next) == 0 && prob <= 0.2
    deposited = 1;
  elseif grid(y,x_next) ~= 0 && prob <= 0.8
    deposited = 1;
  else
      ite = ite + 1;
  end
  end
  grid(y,x_next) = grid(y,x_next) + 1;  %deposition

  %check avalanching
  % Move sand to neighboring cells
  idx = 8;
  i_n = 0;
  slope_map = zeros(1,idx);
            for dx = -1:1
            %dx = 1;
                for dy = -1:1
                    if dx == 0 && dy == 0
                        continue;  % Skip the current cell
                    end

                    if x + dx  < 1
                      x_neigh = x + dx + cols;
                    elseif x + dx > cols
                       x_neigh = x + dx - cols;
                    else
                       x_neigh = x + dx;
                     end
                    if y + dy  < 1
                        y_neigh = y + dy + rows;
                    elseif y + dy > rows
                        y_neigh = y + dy - rows;
                    else
                     y_neigh = y + dy;
                     end
                    i_n = i_n + 1;
                    slope_map(1,i_n) =  grid(y,x) - grid(y_neigh,x_neigh);
                end   
            end
  weight_dist = [0.71, 1, 0.71, 1, 1, 0.71, 1, 0.71];
  slope_map = slope_map./weight_dist;

  if mean(slope_map) > slope
      grid(y,x) = grid(y,x) - erosion;
      ava_prob = rand;
      erosion_boo = 0;

    while erosion_boo == 0
      if ava_prob > 0.2
         x_ava = x + (randi(2) - 1);
         %x_ava = x + 1;
         if x_ava > cols
         x_ava = x_ava - cols;
         end
          y_ava = y + (randi(3) - 2);
          if y_ava < 1
           y_ava = y_ava + rows;
           elseif y_ava > rows
           y_ava = y_ava - rows;
           end
      else 
         x_ava = x + 1;
         if x_ava > cols
         x_ava = x_ava - cols;
          end
          y_ava = y;
      end
  if y_ava == y && x_ava == x
      erosion_boo = 0;
  else
      erosion_boo = 1;
  end
    end
    grid(y_ava,x_ava) = grid(y_ava,x_ava) + erosion;
  end

        
        
  end
  %imagesc(grid)
        %colorbar

        % Pause to observe the evolution
        %pause(0.1);
end
%writematrix(out,'out.dat','Delimiter',';');
%writematrix(init,'init.dat','Delimiter',';');
end
