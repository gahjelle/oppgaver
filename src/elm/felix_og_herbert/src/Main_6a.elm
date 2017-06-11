module Main exposing ( main )

import Html exposing ( Html )
import Svg
import Svg.Attributes as A

import Mouse exposing ( Position )
import Time exposing ( Time )


-- Game constants

felixVelocity = 60 / Time.second
stepTime = Time.second / 6
reviveTime = 0.5 * Time.second


-- Model

type alias Model =
    { herbert : Figure
    , felix : Figure
    , points : Float
    }


type alias Figure =
    { cx : Float
    , cy : Float
    , width : Float
    , height : Float
    , angle : Float
    , costume : Costume
    , state : State
    }


type alias Costume =
    { costumeNumber : Int
    , getLivingCostume : Int -> String
    }


type State
    = DeadSince Time
    | Alive


type Msg
    = MouseAt Position
    | Tick Time


-- main

main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


-- init

init = ( initModel, Cmd.none )


initModel : Model
initModel =
    let
        herbertCostume =
            { costumeNumber = 0
            , getLivingCostume = getHerbertLivingCostume
            }
        felixCostume =
            { costumeNumber = 0
            , getLivingCostume = getFelixLivingCostume
            }
        herbert =
            { cx = 300
            , cy = 200
            , width = 50
            , height = 30
            , angle = 180
            , costume = herbertCostume
            , state = Alive
            }
        felix =
            { cx = 100
            , cy = 200
            , width = 95
            , height = 111
            , angle = 0
            , costume = felixCostume
            , state = Alive
            }
    in
        { herbert = herbert
        , felix = felix
        , points = 0
        }


getFelixLivingCostume : Int -> String
getFelixLivingCostume i =
    case rem i 2 of
        0 -> "cat1-a.svg"
        1 -> "cat1-b.svg"
        _ -> "" -- Fallback required by the Elm compiler


getHerbertLivingCostume : Int -> String
getHerbertLivingCostume _ =
    "mouse1-a.svg"


-- Subscriptions

subscriptions model =
    Sub.batch
        [ Mouse.moves MouseAt
        , Time.every stepTime Tick
        ]


-- Update

update msg model =
    ( case msg of
          MouseAt pos ->
              { model | herbert =
                    ( model.herbert
                    |> lookTo model.felix
                    |> moveToPosition pos
                    )
              }
          Tick time ->
              { model | felix =
                    ( model.felix
                    |> lookTo model.herbert
                    |> moveStep
                    |> nextCostume
                    )
              }
              |> handleCollisions time
              |> handleRevival time
              |> incrementPoints
    , Cmd.none)


lookTo : Figure -> Figure -> Figure
lookTo to from =
    let
        angle = angleBetween from to
    in
        { from | angle = angle }


angleBetween : Figure -> Figure -> Float
angleBetween fig1 fig2 =
    let
        dx = fig2.cx - fig1.cx
        dy = fig2.cy - fig1.cy
        angleInRadians = atan2 dy dx
        angleInDegrees = angleInRadians / pi * 180
    in
        angleInDegrees


moveToPosition : Position -> Figure -> Figure
moveToPosition pos fig =
    { fig
        | cx = toFloat pos.x
        , cy = toFloat pos.y
    }


moveStep : Figure -> Figure
moveStep fig =
    { fig
        | cx = fig.cx + (cos (degrees fig.angle)) * felixVelocity * stepTime
        , cy = fig.cy + (sin (degrees fig.angle)) * felixVelocity * stepTime
    }


nextCostume : Figure -> Figure
nextCostume fig =
    let
        oldCostume = fig.costume
        newCostume = { oldCostume | costumeNumber = oldCostume.costumeNumber + 1 }
    in
        { fig | costume = newCostume }


handleCollisions : Time -> Model -> Model
handleCollisions time model =
    let
        felix = model.felix
        herbert = model.herbert
        points = model.points
        distance = figureDistance felix herbert
        collisionDistance = (figureRadius felix) + (figureRadius herbert)
        hasAlreadyCollided = isDead herbert
    in
        if not hasAlreadyCollided && distance < collisionDistance
        then
            { model
                 | herbert =
                   { herbert
                       | state = DeadSince time
                   }
                 , points = points - 10
             }
        else
            model


figureDistance : Figure -> Figure -> Float
figureDistance fig1 fig2 =
    let
        dx = fig2.cx - fig1.cx
        dy = fig2.cy - fig1.cy
    in
        sqrt (dx * dx + dy * dy)


figureRadius : Figure -> Float
figureRadius fig =
    (min fig.width fig.height) / 2


isDead : Figure -> Bool
isDead fig =
    case fig.state of
        DeadSince _ -> True
        _ -> False


handleRevival : Time -> Model -> Model
handleRevival now model =
    case model.herbert.state of
        DeadSince timeOfDeath ->
            let
                timeDead = now - timeOfDeath
                deadHerbert = model.herbert
                livingHerbert = { deadHerbert | state = Alive }
            in
                if timeDead > reviveTime
                then { model | herbert = livingHerbert }
                else model
        _ -> model


incrementPoints : Model -> Model
incrementPoints model =
    { model | points = model.points + Time.inSeconds stepTime }


-- View

view : Model -> Html.Html Msg
view model =
    Svg.svg
        [ A.width "480"
        , A.height "360"
        , A.viewBox "0 0 480 360"
        ]
        [ Svg.image
              [ A.xlinkHref "brick_wall2.png"
              , A.x "0"
              , A.y "0"
              , A.width "480"
              , A.height "360"
              ]
              [ ]
        , viewScore model.points
        , viewFigure model.herbert
        , viewFigure model.felix
        ]


viewScore : Float -> Html msg
viewScore points =
    Svg.g
        [ ]
        [ Svg.rect
              [ A.x "10"
              , A.y "10"
              , A.width "120"
              , A.height "25"
              , A.fill "lightgray"
              , A.fillOpacity "0.6"
              ]
              [ ]
        , Svg.text_
              [ A.x "20"
              , A.y "30"
              , A.fontSize "20"
              ]
              [ Svg.text
                    ( "Poeng: "
                          ++ toString (floor points)
                    )
              ]
        ]

viewFigure : Figure -> Html msg
viewFigure figure =
    let
        x = figure.cx - figure.width / 2
        y = figure.cy - figure.height / 2
    in
        Svg.image
            [ A.xlinkHref (getCostumeUrl figure)
            , A.x (toString x)
            , A.y (toString y)
            , A.width (toString figure.width)
            , A.height (toString figure.height)
            , A.transform
                ( "rotate("
                      ++ (toString figure.angle)
                      ++ " "
                      ++ (toString figure.cx)
                      ++ " "
                      ++ (toString figure.cy)
                      ++ ")"
                      ++ " "
                )
            ]
            [ ]


getCostumeUrl : Figure -> String
getCostumeUrl fig =
    case fig.state of
        DeadSince _ ->
            "ghost2-a.svg"
        Alive ->
            fig.costume.getLivingCostume (fig.costume.costumeNumber)
