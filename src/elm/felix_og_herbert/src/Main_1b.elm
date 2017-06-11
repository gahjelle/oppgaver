module Main exposing (main)

import Svg exposing (svg, circle, rect, image)
import Svg.Attributes as A


init =
    let
        --start_herbert
        herbert =
            { cx = 100
            , cy = 150
            , width = 50
            , height = 30
            , url = "mouse1-a.svg"
            }
        --end_herbert
    in
        { herbert = herbert
        }


main = view init


view model =
    svg
      [ A.width "480", A.height "360", A.viewBox "0 0 480 360" ]
      [ image [ A.xlinkHref "brick_wall2.png", A.x "0", A.y "0", A.width "480", A.height "360" ] []
      --start_tegn
      , image [ A.xlinkHref model.herbert.url
              , A.x (toString model.herbert.cx)
              , A.y (toString model.herbert.cy)
              , A.width (toString model.herbert.width)
              , A.height (toString model.herbert.height)
              ] []
      --end_tegn
      ]
