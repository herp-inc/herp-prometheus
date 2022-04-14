{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PackageImports #-}

{-|
To get statistics from the GHC runtime system, add 'registerGHCMetrics' near
the beginning of @main@, and run the executable with @+RTS -T@ option (or @+RTS
-T --nonmoving-gc@ for nonmoving GC).

To export Prometheus metrics at @/metrics@, use @prometheusMiddleware ["metrics"]@ as a WAI middleware.
-}

module Herp.Prometheus
  ( registerGHCMetrics
  , prometheusMiddleware
  , module Prometheus
  , module Prometheus.Metric.GHC
  , module Network.Wai.Middleware.Prometheus
  ) where

import "base" Control.Monad.IO.Class

import "text" Data.Text (Text)

import "wai" Network.Wai (Middleware)

import "prometheus-client" Prometheus
import "prometheus-metrics-ghc" Prometheus.Metric.GHC
import "wai-middleware-prometheus" Network.Wai.Middleware.Prometheus

registerGHCMetrics :: MonadIO m => m GHCMetrics
registerGHCMetrics = register ghcMetrics

prometheusMiddleware :: [Text] -> Middleware
prometheusMiddleware paths = prometheus PrometheusSettings
  { prometheusEndPoint = paths
  , prometheusInstrumentApp = False -- If set to 'True', a WAI app would be instrumented with common HTTP metrics.
  , prometheusInstrumentPrometheus = False -- If set to 'True', a WAI app would be instrumented with common HTTP metrics at endpoints @paths@.
  }
