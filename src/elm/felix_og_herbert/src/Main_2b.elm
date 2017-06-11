module Main exposing (main)

import Svg exposing (svg, circle, rect, image)
import Svg.Attributes as A

import Mouse exposing (Position)
import Html


type Msg
    = MouseAt Position


initModel =
    let
        herbert =
            { cx = 100
            , cy = 150
            , width = 50
            , height = 30
            , url = "mouse1-a.svg"
            }
    in
        { herbert = herbert
        }


init = ( initModel, Cmd.none )


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

moveHerbertTo x y fig
    = { fig
          | cx = x
          , cy = y
      }


update msg model =
    case msg of MouseAt pos ->
        ( { model | herbert = ( moveHerbertTo pos.x pos.y model.herbert ) }
        , Cmd.none)


subscriptions model =
    Sub.batch [ Mouse.moves MouseAt ]


view model =
    svg
      [ A.width "480", A.height "360", A.viewBox "0 0 480 360" ]
      [ image [ A.xlinkHref "brick_wall2.png", A.x "0", A.y "0", A.width "480", A.height "360" ] []
      , image [ A.xlinkHref model.herbert.url
              , A.x (toString model.herbert.cx)
              , A.y (toString model.herbert.cy)
              , A.width (toString model.herbert.width)
              , A.height (toString model.herbert.height)
              ] []
      ]
