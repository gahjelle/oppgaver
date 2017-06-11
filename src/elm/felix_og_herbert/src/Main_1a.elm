module Main exposing (main)

import Svg exposing (svg, circle, rect, image)
import Svg.Attributes as A

init =
    let
        herbert =
            { cx = 100
            , cy = 150
            , url = "mouse1-a.svg"
            }
    in
        { herbert = herbert
        }


main = view init

view model =
    svg
      [ A.width "480", A.height "360", A.viewBox "0 0 480 360" ]
      [ image [ A.xlinkHref "brick_wall2.png", A.x "0", A.y "0", A.width "480", A.height "360" ] []
      , image [ A.xlinkHref model.herbert.url
              , A.x (toString model.herbert.cx)
              , A.y (toString model.herbert.cy)
              ] []
      ]
