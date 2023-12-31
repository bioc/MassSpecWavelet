% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/peakDetectionCWT.R
\name{peakDetectionCWT}
\alias{peakDetectionCWT}
\title{The main function of peak detection by CWT based pattern matching}
\usage{
peakDetectionCWT(
  ms,
  scales = c(1, seq(2, 30, 2), seq(32, 64, 4)),
  SNR.Th = 3,
  nearbyPeak = TRUE,
  peakScaleRange = 5,
  amp.Th = 0.01,
  minNoiseLevel = amp.Th/SNR.Th,
  ridgeLength = 24,
  peakThr = NULL,
  tuneIn = FALSE,
  ...,
  exclude0scaleAmpThresh = FALSE,
  getRidgeParams = list(gapTh = 3, skip = 2)
)
}
\arguments{
\item{ms}{the mass spectrometry spectrum}

\item{scales}{Scales of CWT. See \code{\link[=cwt]{cwt()}} for details. Additionally, a \code{prepared_wavelets} object
is also accepted (see \code{\link[=prepareWavelets]{prepareWavelets()}}).}

\item{SNR.Th}{SNR (Signal to Noise Ratio) threshold}

\item{nearbyPeak}{Determine whether to include the nearby small peaks of
major peaks. \code{TRUE} by default}

\item{peakScaleRange}{the scale range of the peak. larger than 5 by default.}

\item{amp.Th}{the minimum required relative amplitude of the peak (ratio to
the maximum of CWT coefficients)}

\item{minNoiseLevel}{the minimum noise level used in computing the SNR}

\item{ridgeLength}{the minimum highest scale of the peak in 2-D CWT
coefficient matrix}

\item{peakThr}{Minimal absolute intensity (above the baseline) of peaks to
be picked. If this value is provided, then the smoothing function
\code{\link[signal:sgolayfilt]{signal::sgolayfilt()}} will be called to estimate the local
intensity.(added based on the suggestion and code of Steffen Neumann)}

\item{tuneIn}{determine whether to tune in the parameter estimation of the
detected peaks. If \code{TRUE}, peak detection is run again on a segment of the spectrum
with more detailed scales. This tuning happens with the default wavelet and settings
so it may not be that useful to you if you are using custom wavelets or thresholds.}

\item{\dots}{other parameters used by \code{\link[=identifyMajorPeaks]{identifyMajorPeaks()}}.
Additionally, \code{fl} (filter length, with a default value of 1001) and
\code{forder} (filter order, with a default value of 2) are set and passed
to \code{\link[signal:sgolayfilt]{signal::sgolayfilt()}} when \code{peakThr} is given.}

\item{exclude0scaleAmpThresh}{When computing the relative \code{amp.Th}, if
this is set to \code{TRUE}, the \code{amp.Th} will exclude the zero-th scale from the
\code{max(wCoefs)}. The zero-th scale corresponds to the original signal, that may
have a much larger baseline than the wavelet coefficients and can distort the
threshold calculation. The default is \code{FALSE} to preserve backwards compatibility.}

\item{getRidgeParams}{A list with parameters for \code{getRidge()}.}
}
\value{
\item{majorPeakInfo}{ return of \code{\link[=identifyMajorPeaks]{identifyMajorPeaks()}}}
\item{ridgeList}{return of \code{\link[=getRidge]{getRidge()}}} \item{localMax}{ return
of \code{\link[=getLocalMaximumCWT]{getLocalMaximumCWT()}} } \item{wCoefs}{ 2-D CWT coefficient
matrix, see \code{\link[=cwt]{cwt()}} for details.}
}
\description{
This function is a wrapper of \code{\link[=cwt]{cwt()}},
\code{\link[=getLocalMaximumCWT]{getLocalMaximumCWT()}}, \code{\link[=getRidge]{getRidge()}},
\code{\link[=identifyMajorPeaks]{identifyMajorPeaks()}}
}
\examples{

data(exampleMS)

# Detect peaks with prepared wavelets:
prep_wav <- prepareWavelets(length(exampleMS))
SNR.Th <- 3
peakInfo <- peakDetectionCWT(exampleMS, prep_wav, SNR.Th = SNR.Th, exclude0scaleAmpThresh=TRUE)
peakIndex <- peakInfo$majorPeakInfo$peakIndex
plotPeak(exampleMS, peakIndex, main = paste("Identified peaks with SNR >", SNR.Th))

SNR.Th <- 3
peakInfo <- peakDetectionCWT(exampleMS, SNR.Th = SNR.Th)
majorPeakInfo <- peakInfo$majorPeakInfo
peakIndex <- majorPeakInfo$peakIndex
plotPeak(exampleMS, peakIndex, main = paste("Identified peaks with SNR >", SNR.Th))

## In some cases, users may want to add peak filtering based on the absolute peak amplitude
peakInfo <- peakDetectionCWT(exampleMS, SNR.Th = SNR.Th, peakThr = 500)
majorPeakInfo <- peakInfo$majorPeakInfo
peakIndex <- majorPeakInfo$peakIndex
plotPeak(exampleMS, peakIndex, main = paste("Identified peaks with SNR >", SNR.Th))

}
\references{
Du, P., Kibbe, W.A. and Lin, S.M. (2006) Improved peak detection
in mass spectrum by incorporating continuous wavelet transform-based pattern
matching, Bioinformatics, 22, 2059-2065.
}
\seealso{
\code{\link[=cwt]{cwt()}}, \code{\link[=getLocalMaximumCWT]{getLocalMaximumCWT()}},
\code{\link[=getRidge]{getRidge()}}, \code{\link[=identifyMajorPeaks]{identifyMajorPeaks()}}
}
\author{
Pan Du, Simon Lin
}
\keyword{methods}
