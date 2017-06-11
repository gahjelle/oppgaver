module Main exposing (main)

import Svg exposing (svg, circle, rect, image)
import Svg.Attributes as A

import Mouse exposing (Position)
import Html


type alias Figure =
    { cx : Int
    , cy : Int
    , width : Int
    , height : Int
    , url : String
    }


type alias Model =
    { herbert : Figure
    , felix : Figure
    }


type Msg
    = MouseAt Position


initModel : Model
initModel =
    let
        herbert =
            { cx = 100
            , cy = 150
            , width = 50
            , height = 30
            , url = "mouse1-a.svg"
            }
        felix =
            { cx = 300
            , cy = 200
            , width = 95
            , height = 111
            , url = "cat1-a.svg"
            }
    in
        { herbert = herbert
        , felix = felix
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
      , viewFigure model.herbert
      , viewFigure model.felix
      ]


viewFigure figure =
    let
        x = figure.cx - figure.width // 2
        y = figure.cy - figure.height // 2
    in
        image [ A.xlinkHref figure.url
              , A.x (toString x)
              , A.y (toString y)
              , A.width (toString figure.width)
              , A.height (toString figure.height)
              ] [ ]
