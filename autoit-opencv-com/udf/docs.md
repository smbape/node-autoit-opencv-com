# AutoIt OpenCV UDF

## cv

### cv::borderInterpolate

```cpp
int cv::borderInterpolate( int p,
                           int len,
                           int borderType )

AutoIt:
    _OpenCV_ObjCreate("cv").borderInterpolate( $p, $len, $borderType ) -> retval
```

### cv::copyMakeBorder

```cpp
void cv::copyMakeBorder( _InputArray       src,
                         _OutputArray      dst,
                         int               top,
                         int               bottom,
                         int               left,
                         int               right,
                         int               borderType,
                         const cv::Scalar& value = Scalar() )

AutoIt:
    _OpenCV_ObjCreate("cv").copyMakeBorder( $src, $top, $bottom, $left, $right, $borderType[, $dst[, $value]] ) -> $dst
```

### cv::add

```cpp
void cv::add( _InputArray  src1,
              _InputArray  src2,
              _OutputArray dst,
              _InputArray  mask = noArray(),
              int          dtype = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv").add( $src1, $src2[, $dst[, $mask[, $dtype]]] ) -> $dst
```

### cv::subtract

```cpp
void cv::subtract( _InputArray  src1,
                   _InputArray  src2,
                   _OutputArray dst,
                   _InputArray  mask = noArray(),
                   int          dtype = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv").subtract( $src1, $src2[, $dst[, $mask[, $dtype]]] ) -> $dst
```

### cv::multiply

```cpp
void cv::multiply( _InputArray  src1,
                   _InputArray  src2,
                   _OutputArray dst,
                   double       scale = 1,
                   int          dtype = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv").multiply( $src1, $src2[, $dst[, $scale[, $dtype]]] ) -> $dst
```

### cv::divide

```cpp
void cv::divide( _InputArray  src1,
                 _InputArray  src2,
                 _OutputArray dst,
                 double       scale = 1,
                 int          dtype = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv").divide( $src1, $src2[, $dst[, $scale[, $dtype]]] ) -> $dst
```

```cpp
void cv::divide( double       scale,
                 _InputArray  src2,
                 _OutputArray dst,
                 int          dtype = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv").divide( $scale, $src2[, $dst[, $dtype]] ) -> $dst
```

### cv::scaleAdd

```cpp
void cv::scaleAdd( _InputArray  src1,
                   double       alpha,
                   _InputArray  src2,
                   _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").scaleAdd( $src1, $alpha, $src2[, $dst] ) -> $dst
```

### cv::addWeighted

```cpp
void cv::addWeighted( _InputArray  src1,
                      double       alpha,
                      _InputArray  src2,
                      double       beta,
                      double       gamma,
                      _OutputArray dst,
                      int          dtype = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv").addWeighted( $src1, $alpha, $src2, $beta, $gamma[, $dst[, $dtype]] ) -> $dst
```

### cv::convertScaleAbs

```cpp
void cv::convertScaleAbs( _InputArray  src,
                          _OutputArray dst,
                          double       alpha = 1,
                          double       beta = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").convertScaleAbs( $src[, $dst[, $alpha[, $beta]]] ) -> $dst
```

### cv::convertFp16

```cpp
void cv::convertFp16( _InputArray  src,
                      _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").convertFp16( $src[, $dst] ) -> $dst
```

### cv::LUT

```cpp
void cv::LUT( _InputArray  src,
              _InputArray  lut,
              _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").LUT( $src, $lut[, $dst] ) -> $dst
```

### cv::sumElems

```cpp
cv::Scalar cv::sumElems( _InputArray src )

AutoIt:
    _OpenCV_ObjCreate("cv").sumElems( $src ) -> retval
```

### cv::countNonZero

```cpp
int cv::countNonZero( _InputArray src )

AutoIt:
    _OpenCV_ObjCreate("cv").countNonZero( $src ) -> retval
```

### cv::findNonZero

```cpp
void cv::findNonZero( _InputArray  src,
                      _OutputArray idx )

AutoIt:
    _OpenCV_ObjCreate("cv").findNonZero( $src[, $idx] ) -> $idx
```

### cv::mean

```cpp
cv::Scalar cv::mean( _InputArray src,
                     _InputArray mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").mean( $src[, $mask] ) -> retval
```

### cv::meanStdDev

```cpp
void cv::meanStdDev( _InputArray  src,
                     _OutputArray mean,
                     _OutputArray stddev,
                     _InputArray  mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").meanStdDev( $src[, $mean[, $stddev[, $mask]]] ) -> $mean, $stddev
```

### cv::norm

```cpp
double cv::norm( _InputArray src1,
                 int         normType = NORM_L2,
                 _InputArray mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").norm( $src1[, $normType[, $mask]] ) -> retval
```

```cpp
double cv::norm( _InputArray src1,
                 _InputArray src2,
                 int         normType = NORM_L2,
                 _InputArray mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").norm( $src1, $src2[, $normType[, $mask]] ) -> retval
```

### cv::PSNR

```cpp
double cv::PSNR( _InputArray src1,
                 _InputArray src2,
                 double      R = 255. )

AutoIt:
    _OpenCV_ObjCreate("cv").PSNR( $src1, $src2[, $R] ) -> retval
```

### cv::batchDistance

```cpp
void cv::batchDistance( _InputArray  src1,
                        _InputArray  src2,
                        _OutputArray dist,
                        int          dtype,
                        _OutputArray nidx,
                        int          normType = NORM_L2,
                        int          K = 0,
                        _InputArray  mask = noArray(),
                        int          update = 0,
                        bool         crosscheck = false )

AutoIt:
    _OpenCV_ObjCreate("cv").batchDistance( $src1, $src2, $dtype[, $dist[, $nidx[, $normType[, $K[, $mask[, $update[, $crosscheck]]]]]]] ) -> $dist, $nidx
```

### cv::normalize

```cpp
void cv::normalize( _InputArray       src,
                    _InputOutputArray dst,
                    double            alpha = 1,
                    double            beta = 0,
                    int               norm_type = NORM_L2,
                    int               dtype = -1,
                    _InputArray       mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").normalize( $src, $dst[, $alpha[, $beta[, $norm_type[, $dtype[, $mask]]]]] ) -> $dst
```

### cv::minMaxLoc

```cpp
void cv::minMaxLoc( _InputArray src,
                    double*     minVal,
                    double*     maxVal = 0,
                    cv::Point*  minLoc = 0,
                    cv::Point*  maxLoc = 0,
                    _InputArray mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").minMaxLoc( $src[, $mask[, $minVal[, $maxVal[, $minLoc[, $maxLoc]]]]] ) -> $minVal, $maxVal, $minLoc, $maxLoc
```

### cv::reduceArgMin

```cpp
void cv::reduceArgMin( _InputArray  src,
                       _OutputArray dst,
                       int          axis,
                       bool         lastIndex = false )

AutoIt:
    _OpenCV_ObjCreate("cv").reduceArgMin( $src, $axis[, $dst[, $lastIndex]] ) -> $dst
```

### cv::reduceArgMax

```cpp
void cv::reduceArgMax( _InputArray  src,
                       _OutputArray dst,
                       int          axis,
                       bool         lastIndex = false )

AutoIt:
    _OpenCV_ObjCreate("cv").reduceArgMax( $src, $axis[, $dst[, $lastIndex]] ) -> $dst
```

### cv::reduce

```cpp
void cv::reduce( _InputArray  src,
                 _OutputArray dst,
                 int          dim,
                 int          rtype,
                 int          dtype = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv").reduce( $src, $dim, $rtype[, $dst[, $dtype]] ) -> $dst
```

### cv::merge

```cpp
void cv::merge( _InputArray  mv,
                _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").merge( $mv[, $dst] ) -> $dst
```

### cv::split

```cpp
void cv::split( _InputArray  m,
                _OutputArray mv )

AutoIt:
    _OpenCV_ObjCreate("cv").split( $m[, $mv] ) -> $mv
```

### cv::mixChannels

```cpp
void cv::mixChannels( _InputArray             src,
                      _InputOutputArray       dst,
                      const std::vector<int>& fromTo )

AutoIt:
    _OpenCV_ObjCreate("cv").mixChannels( $src, $dst, $fromTo ) -> $dst
```

### cv::extractChannel

```cpp
void cv::extractChannel( _InputArray  src,
                         _OutputArray dst,
                         int          coi )

AutoIt:
    _OpenCV_ObjCreate("cv").extractChannel( $src, $coi[, $dst] ) -> $dst
```

### cv::insertChannel

```cpp
void cv::insertChannel( _InputArray       src,
                        _InputOutputArray dst,
                        int               coi )

AutoIt:
    _OpenCV_ObjCreate("cv").insertChannel( $src, $dst, $coi ) -> $dst
```

### cv::flip

```cpp
void cv::flip( _InputArray  src,
               _OutputArray dst,
               int          flipCode )

AutoIt:
    _OpenCV_ObjCreate("cv").flip( $src, $flipCode[, $dst] ) -> $dst
```

### cv::rotate

```cpp
void cv::rotate( _InputArray  src,
                 _OutputArray dst,
                 int          rotateCode )

AutoIt:
    _OpenCV_ObjCreate("cv").rotate( $src, $rotateCode[, $dst] ) -> $dst
```

### cv::repeat

```cpp
void cv::repeat( _InputArray  src,
                 int          ny,
                 int          nx,
                 _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").repeat( $src, $ny, $nx[, $dst] ) -> $dst
```

### cv::hconcat

```cpp
void cv::hconcat( _InputArray  src,
                  _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").hconcat( $src[, $dst] ) -> $dst
```

### cv::vconcat

```cpp
void cv::vconcat( _InputArray  src,
                  _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").vconcat( $src[, $dst] ) -> $dst
```

### cv::bitwise_and

```cpp
void cv::bitwise_and( _InputArray  src1,
                      _InputArray  src2,
                      _OutputArray dst,
                      _InputArray  mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").bitwise_and( $src1, $src2[, $dst[, $mask]] ) -> $dst
```

### cv::bitwise_or

```cpp
void cv::bitwise_or( _InputArray  src1,
                     _InputArray  src2,
                     _OutputArray dst,
                     _InputArray  mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").bitwise_or( $src1, $src2[, $dst[, $mask]] ) -> $dst
```

### cv::bitwise_xor

```cpp
void cv::bitwise_xor( _InputArray  src1,
                      _InputArray  src2,
                      _OutputArray dst,
                      _InputArray  mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").bitwise_xor( $src1, $src2[, $dst[, $mask]] ) -> $dst
```

### cv::bitwise_not

```cpp
void cv::bitwise_not( _InputArray  src,
                      _OutputArray dst,
                      _InputArray  mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").bitwise_not( $src[, $dst[, $mask]] ) -> $dst
```

### cv::absdiff

```cpp
void cv::absdiff( _InputArray  src1,
                  _InputArray  src2,
                  _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").absdiff( $src1, $src2[, $dst] ) -> $dst
```

### cv::copyTo

```cpp
void cv::copyTo( _InputArray  src,
                 _OutputArray dst,
                 _InputArray  mask )

AutoIt:
    _OpenCV_ObjCreate("cv").copyTo( $src, $mask[, $dst] ) -> $dst
```

### cv::inRange

```cpp
void cv::inRange( _InputArray  src,
                  _InputArray  lowerb,
                  _InputArray  upperb,
                  _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").inRange( $src, $lowerb, $upperb[, $dst] ) -> $dst
```

### cv::compare

```cpp
void cv::compare( _InputArray  src1,
                  _InputArray  src2,
                  _OutputArray dst,
                  int          cmpop )

AutoIt:
    _OpenCV_ObjCreate("cv").compare( $src1, $src2, $cmpop[, $dst] ) -> $dst
```

### cv::min

```cpp
void cv::min( _InputArray  src1,
              _InputArray  src2,
              _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").min( $src1, $src2[, $dst] ) -> $dst
```

### cv::max

```cpp
void cv::max( _InputArray  src1,
              _InputArray  src2,
              _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").max( $src1, $src2[, $dst] ) -> $dst
```

### cv::sqrt

```cpp
void cv::sqrt( _InputArray  src,
               _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").sqrt( $src[, $dst] ) -> $dst
```

### cv::pow

```cpp
void cv::pow( _InputArray  src,
              double       power,
              _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").pow( $src, $power[, $dst] ) -> $dst
```

### cv::exp

```cpp
void cv::exp( _InputArray  src,
              _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").exp( $src[, $dst] ) -> $dst
```

### cv::log

```cpp
void cv::log( _InputArray  src,
              _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").log( $src[, $dst] ) -> $dst
```

### cv::polarToCart

```cpp
void cv::polarToCart( _InputArray  magnitude,
                      _InputArray  angle,
                      _OutputArray x,
                      _OutputArray y,
                      bool         angleInDegrees = false )

AutoIt:
    _OpenCV_ObjCreate("cv").polarToCart( $magnitude, $angle[, $x[, $y[, $angleInDegrees]]] ) -> $x, $y
```

### cv::cartToPolar

```cpp
void cv::cartToPolar( _InputArray  x,
                      _InputArray  y,
                      _OutputArray magnitude,
                      _OutputArray angle,
                      bool         angleInDegrees = false )

AutoIt:
    _OpenCV_ObjCreate("cv").cartToPolar( $x, $y[, $magnitude[, $angle[, $angleInDegrees]]] ) -> $magnitude, $angle
```

### cv::phase

```cpp
void cv::phase( _InputArray  x,
                _InputArray  y,
                _OutputArray angle,
                bool         angleInDegrees = false )

AutoIt:
    _OpenCV_ObjCreate("cv").phase( $x, $y[, $angle[, $angleInDegrees]] ) -> $angle
```

### cv::magnitude

```cpp
void cv::magnitude( _InputArray  x,
                    _InputArray  y,
                    _OutputArray magnitude )

AutoIt:
    _OpenCV_ObjCreate("cv").magnitude( $x, $y[, $magnitude] ) -> $magnitude
```

### cv::checkRange

```cpp
bool cv::checkRange( _InputArray a,
                     bool        quiet = true,
                     cv::Point*  pos = 0,
                     double      minVal = -DBL_MAX,
                     double      maxVal = DBL_MAX )

AutoIt:
    _OpenCV_ObjCreate("cv").checkRange( $a[, $quiet[, $minVal[, $maxVal[, $pos]]]] ) -> retval, $pos
```

### cv::patchNaNs

```cpp
void cv::patchNaNs( _InputOutputArray a,
                    double            val = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").patchNaNs( $a[, $val] ) -> $a
```

### cv::gemm

```cpp
void cv::gemm( _InputArray  src1,
               _InputArray  src2,
               double       alpha,
               _InputArray  src3,
               double       beta,
               _OutputArray dst,
               int          flags = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").gemm( $src1, $src2, $alpha, $src3, $beta[, $dst[, $flags]] ) -> $dst
```

### cv::mulTransposed

```cpp
void cv::mulTransposed( _InputArray  src,
                        _OutputArray dst,
                        bool         aTa,
                        _InputArray  delta = noArray(),
                        double       scale = 1,
                        int          dtype = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv").mulTransposed( $src, $aTa[, $dst[, $delta[, $scale[, $dtype]]]] ) -> $dst
```

### cv::transpose

```cpp
void cv::transpose( _InputArray  src,
                    _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").transpose( $src[, $dst] ) -> $dst
```

### cv::transform

```cpp
void cv::transform( _InputArray  src,
                    _OutputArray dst,
                    _InputArray  m )

AutoIt:
    _OpenCV_ObjCreate("cv").transform( $src, $m[, $dst] ) -> $dst
```

### cv::perspectiveTransform

```cpp
void cv::perspectiveTransform( _InputArray  src,
                               _OutputArray dst,
                               _InputArray  m )

AutoIt:
    _OpenCV_ObjCreate("cv").perspectiveTransform( $src, $m[, $dst] ) -> $dst
```

### cv::completeSymm

```cpp
void cv::completeSymm( _InputOutputArray m,
                       bool              lowerToUpper = false )

AutoIt:
    _OpenCV_ObjCreate("cv").completeSymm( $m[, $lowerToUpper] ) -> $m
```

### cv::setIdentity

```cpp
void cv::setIdentity( _InputOutputArray mtx,
                      const cv::Scalar& s = Scalar(1) )

AutoIt:
    _OpenCV_ObjCreate("cv").setIdentity( $mtx[, $s] ) -> $mtx
```

### cv::determinant

```cpp
double cv::determinant( _InputArray mtx )

AutoIt:
    _OpenCV_ObjCreate("cv").determinant( $mtx ) -> retval
```

### cv::trace

```cpp
cv::Scalar cv::trace( _InputArray mtx )

AutoIt:
    _OpenCV_ObjCreate("cv").trace( $mtx ) -> retval
```

### cv::invert

```cpp
double cv::invert( _InputArray  src,
                   _OutputArray dst,
                   int          flags = DECOMP_LU )

AutoIt:
    _OpenCV_ObjCreate("cv").invert( $src[, $dst[, $flags]] ) -> retval, $dst
```

### cv::solve

```cpp
bool cv::solve( _InputArray  src1,
                _InputArray  src2,
                _OutputArray dst,
                int          flags = DECOMP_LU )

AutoIt:
    _OpenCV_ObjCreate("cv").solve( $src1, $src2[, $dst[, $flags]] ) -> retval, $dst
```

### cv::sort

```cpp
void cv::sort( _InputArray  src,
               _OutputArray dst,
               int          flags )

AutoIt:
    _OpenCV_ObjCreate("cv").sort( $src, $flags[, $dst] ) -> $dst
```

### cv::sortIdx

```cpp
void cv::sortIdx( _InputArray  src,
                  _OutputArray dst,
                  int          flags )

AutoIt:
    _OpenCV_ObjCreate("cv").sortIdx( $src, $flags[, $dst] ) -> $dst
```

### cv::solveCubic

```cpp
int cv::solveCubic( _InputArray  coeffs,
                    _OutputArray roots )

AutoIt:
    _OpenCV_ObjCreate("cv").solveCubic( $coeffs[, $roots] ) -> retval, $roots
```

### cv::solvePoly

```cpp
double cv::solvePoly( _InputArray  coeffs,
                      _OutputArray roots,
                      int          maxIters = 300 )

AutoIt:
    _OpenCV_ObjCreate("cv").solvePoly( $coeffs[, $roots[, $maxIters]] ) -> retval, $roots
```

### cv::eigen

```cpp
bool cv::eigen( _InputArray  src,
                _OutputArray eigenvalues,
                _OutputArray eigenvectors = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").eigen( $src[, $eigenvalues[, $eigenvectors]] ) -> retval, $eigenvalues, $eigenvectors
```

### cv::eigenNonSymmetric

```cpp
void cv::eigenNonSymmetric( _InputArray  src,
                            _OutputArray eigenvalues,
                            _OutputArray eigenvectors )

AutoIt:
    _OpenCV_ObjCreate("cv").eigenNonSymmetric( $src[, $eigenvalues[, $eigenvectors]] ) -> $eigenvalues, $eigenvectors
```

### cv::calcCovarMatrix

```cpp
void cv::calcCovarMatrix( _InputArray       samples,
                          _OutputArray      covar,
                          _InputOutputArray mean,
                          int               flags,
                          int               ctype = CV_64F )

AutoIt:
    _OpenCV_ObjCreate("cv").calcCovarMatrix( $samples, $mean, $flags[, $covar[, $ctype]] ) -> $covar, $mean
```

### cv::PCACompute

```cpp
void cv::PCACompute( _InputArray       data,
                     _InputOutputArray mean,
                     _OutputArray      eigenvectors,
                     int               maxComponents = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").PCACompute( $data, $mean[, $eigenvectors[, $maxComponents]] ) -> $mean, $eigenvectors
```

```cpp
void cv::PCACompute( _InputArray       data,
                     _InputOutputArray mean,
                     _OutputArray      eigenvectors,
                     double            retainedVariance )

AutoIt:
    _OpenCV_ObjCreate("cv").PCACompute( $data, $mean, $retainedVariance[, $eigenvectors] ) -> $mean, $eigenvectors
```

### cv::PCACompute2

```cpp
void cv::PCACompute2( _InputArray       data,
                      _InputOutputArray mean,
                      _OutputArray      eigenvectors,
                      _OutputArray      eigenvalues,
                      int               maxComponents = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").PCACompute2( $data, $mean[, $eigenvectors[, $eigenvalues[, $maxComponents]]] ) -> $mean, $eigenvectors, $eigenvalues
```

```cpp
void cv::PCACompute2( _InputArray       data,
                      _InputOutputArray mean,
                      _OutputArray      eigenvectors,
                      _OutputArray      eigenvalues,
                      double            retainedVariance )

AutoIt:
    _OpenCV_ObjCreate("cv").PCACompute2( $data, $mean, $retainedVariance[, $eigenvectors[, $eigenvalues]] ) -> $mean, $eigenvectors, $eigenvalues
```

### cv::PCAProject

```cpp
void cv::PCAProject( _InputArray  data,
                     _InputArray  mean,
                     _InputArray  eigenvectors,
                     _OutputArray result )

AutoIt:
    _OpenCV_ObjCreate("cv").PCAProject( $data, $mean, $eigenvectors[, $result] ) -> $result
```

### cv::PCABackProject

```cpp
void cv::PCABackProject( _InputArray  data,
                         _InputArray  mean,
                         _InputArray  eigenvectors,
                         _OutputArray result )

AutoIt:
    _OpenCV_ObjCreate("cv").PCABackProject( $data, $mean, $eigenvectors[, $result] ) -> $result
```

### cv::SVDecomp

```cpp
void cv::SVDecomp( _InputArray  src,
                   _OutputArray w,
                   _OutputArray u,
                   _OutputArray vt,
                   int          flags = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").SVDecomp( $src[, $w[, $u[, $vt[, $flags]]]] ) -> $w, $u, $vt
```

### cv::SVBackSubst

```cpp
void cv::SVBackSubst( _InputArray  w,
                      _InputArray  u,
                      _InputArray  vt,
                      _InputArray  rhs,
                      _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").SVBackSubst( $w, $u, $vt, $rhs[, $dst] ) -> $dst
```

### cv::Mahalanobis

```cpp
double cv::Mahalanobis( _InputArray v1,
                        _InputArray v2,
                        _InputArray icovar )

AutoIt:
    _OpenCV_ObjCreate("cv").Mahalanobis( $v1, $v2, $icovar ) -> retval
```

### cv::dft

```cpp
void cv::dft( _InputArray  src,
              _OutputArray dst,
              int          flags = 0,
              int          nonzeroRows = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").dft( $src[, $dst[, $flags[, $nonzeroRows]]] ) -> $dst
```

### cv::idft

```cpp
void cv::idft( _InputArray  src,
               _OutputArray dst,
               int          flags = 0,
               int          nonzeroRows = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").idft( $src[, $dst[, $flags[, $nonzeroRows]]] ) -> $dst
```

### cv::dct

```cpp
void cv::dct( _InputArray  src,
              _OutputArray dst,
              int          flags = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").dct( $src[, $dst[, $flags]] ) -> $dst
```

### cv::idct

```cpp
void cv::idct( _InputArray  src,
               _OutputArray dst,
               int          flags = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").idct( $src[, $dst[, $flags]] ) -> $dst
```

### cv::mulSpectrums

```cpp
void cv::mulSpectrums( _InputArray  a,
                       _InputArray  b,
                       _OutputArray c,
                       int          flags,
                       bool         conjB = false )

AutoIt:
    _OpenCV_ObjCreate("cv").mulSpectrums( $a, $b, $flags[, $c[, $conjB]] ) -> $c
```

### cv::getOptimalDFTSize

```cpp
int cv::getOptimalDFTSize( int vecsize )

AutoIt:
    _OpenCV_ObjCreate("cv").getOptimalDFTSize( $vecsize ) -> retval
```

### cv::setRNGSeed

```cpp
void cv::setRNGSeed( int seed )

AutoIt:
    _OpenCV_ObjCreate("cv").setRNGSeed( $seed ) -> None
```

### cv::randu

```cpp
void cv::randu( _InputOutputArray dst,
                _InputArray       low,
                _InputArray       high )

AutoIt:
    _OpenCV_ObjCreate("cv").randu( $dst, $low, $high ) -> $dst
```

### cv::randn

```cpp
void cv::randn( _InputOutputArray dst,
                _InputArray       mean,
                _InputArray       stddev )

AutoIt:
    _OpenCV_ObjCreate("cv").randn( $dst, $mean, $stddev ) -> $dst
```

### cv::randShuffle

```cpp
void cv::randShuffle( _InputOutputArray dst,
                      double            iterFactor = 1.,
                      cv::RNG*          rng = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").randShuffle( $dst[, $iterFactor[, $rng]] ) -> $dst
```

### cv::kmeans

```cpp
double cv::kmeans( _InputArray       data,
                   int               K,
                   _InputOutputArray bestLabels,
                   cv::TermCriteria  criteria,
                   int               attempts,
                   int               flags,
                   _OutputArray      centers = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").kmeans( $data, $K, $bestLabels, $criteria, $attempts, $flags[, $centers] ) -> retval, $bestLabels, $centers
```

### cv::cubeRoot

```cpp
float cv::cubeRoot( float val )

AutoIt:
    _OpenCV_ObjCreate("cv").cubeRoot( $val ) -> retval
```

### cv::fastAtan2

```cpp
float cv::fastAtan2( float y,
                     float x )

AutoIt:
    _OpenCV_ObjCreate("cv").fastAtan2( $y, $x ) -> retval
```

### cv::setLogLevel

```cpp
int cv::setLogLevel( int level )

AutoIt:
    _OpenCV_ObjCreate("cv").setLogLevel( $level ) -> retval
```

### cv::getLogLevel

```cpp
int cv::getLogLevel()

AutoIt:
    _OpenCV_ObjCreate("cv").getLogLevel() -> retval
```

### cv::solveLP

```cpp
int cv::solveLP( _InputArray  Func,
                 _InputArray  Constr,
                 _OutputArray z )

AutoIt:
    _OpenCV_ObjCreate("cv").solveLP( $Func, $Constr[, $z] ) -> retval, $z
```

### cv::haveOpenVX

```cpp
bool cv::haveOpenVX()

AutoIt:
    _OpenCV_ObjCreate("cv").haveOpenVX() -> retval
```

### cv::useOpenVX

```cpp
bool cv::useOpenVX()

AutoIt:
    _OpenCV_ObjCreate("cv").useOpenVX() -> retval
```

### cv::setUseOpenVX

```cpp
void cv::setUseOpenVX( bool flag )

AutoIt:
    _OpenCV_ObjCreate("cv").setUseOpenVX( $flag ) -> None
```

### cv::setNumThreads

```cpp
void cv::setNumThreads( int nthreads )

AutoIt:
    _OpenCV_ObjCreate("cv").setNumThreads( $nthreads ) -> None
```

### cv::getNumThreads

```cpp
int cv::getNumThreads()

AutoIt:
    _OpenCV_ObjCreate("cv").getNumThreads() -> retval
```

### cv::getThreadNum

```cpp
int cv::getThreadNum()

AutoIt:
    _OpenCV_ObjCreate("cv").getThreadNum() -> retval
```

### cv::getBuildInformation

```cpp
std::string cv::getBuildInformation()

AutoIt:
    _OpenCV_ObjCreate("cv").getBuildInformation() -> retval
```

### cv::getVersionString

```cpp
std::string cv::getVersionString()

AutoIt:
    _OpenCV_ObjCreate("cv").getVersionString() -> retval
```

### cv::getVersionMajor

```cpp
int cv::getVersionMajor()

AutoIt:
    _OpenCV_ObjCreate("cv").getVersionMajor() -> retval
```

### cv::getVersionMinor

```cpp
int cv::getVersionMinor()

AutoIt:
    _OpenCV_ObjCreate("cv").getVersionMinor() -> retval
```

### cv::getVersionRevision

```cpp
int cv::getVersionRevision()

AutoIt:
    _OpenCV_ObjCreate("cv").getVersionRevision() -> retval
```

### cv::getTickCount

```cpp
int64 cv::getTickCount()

AutoIt:
    _OpenCV_ObjCreate("cv").getTickCount() -> retval
```

### cv::getTickFrequency

```cpp
double cv::getTickFrequency()

AutoIt:
    _OpenCV_ObjCreate("cv").getTickFrequency() -> retval
```

### cv::getCPUTickCount

```cpp
int64 cv::getCPUTickCount()

AutoIt:
    _OpenCV_ObjCreate("cv").getCPUTickCount() -> retval
```

### cv::checkHardwareSupport

```cpp
bool cv::checkHardwareSupport( int feature )

AutoIt:
    _OpenCV_ObjCreate("cv").checkHardwareSupport( $feature ) -> retval
```

### cv::getHardwareFeatureName

```cpp
std::string cv::getHardwareFeatureName( int feature )

AutoIt:
    _OpenCV_ObjCreate("cv").getHardwareFeatureName( $feature ) -> retval
```

### cv::getCPUFeaturesLine

```cpp
std::string cv::getCPUFeaturesLine()

AutoIt:
    _OpenCV_ObjCreate("cv").getCPUFeaturesLine() -> retval
```

### cv::getNumberOfCPUs

```cpp
int cv::getNumberOfCPUs()

AutoIt:
    _OpenCV_ObjCreate("cv").getNumberOfCPUs() -> retval
```

### cv::setUseOptimized

```cpp
void cv::setUseOptimized( bool onoff )

AutoIt:
    _OpenCV_ObjCreate("cv").setUseOptimized( $onoff ) -> None
```

### cv::useOptimized

```cpp
bool cv::useOptimized()

AutoIt:
    _OpenCV_ObjCreate("cv").useOptimized() -> retval
```

### cv::createLineSegmentDetector

```cpp
cv::Ptr<cv::LineSegmentDetector> cv::createLineSegmentDetector( int    refine = LSD_REFINE_STD,
                                                                double scale = 0.8,
                                                                double sigma_scale = 0.6,
                                                                double quant = 2.0,
                                                                double ang_th = 22.5,
                                                                double log_eps = 0,
                                                                double density_th = 0.7,
                                                                int    n_bins = 1024 )

AutoIt:
    _OpenCV_ObjCreate("cv").createLineSegmentDetector( [$refine[, $scale[, $sigma_scale[, $quant[, $ang_th[, $log_eps[, $density_th[, $n_bins]]]]]]]] ) -> retval
```

### cv::getGaussianKernel

```cpp
cv::Mat cv::getGaussianKernel( int    ksize,
                               double sigma,
                               int    ktype = CV_64F )

AutoIt:
    _OpenCV_ObjCreate("cv").getGaussianKernel( $ksize, $sigma[, $ktype] ) -> retval
```

### cv::getDerivKernels

```cpp
void cv::getDerivKernels( _OutputArray kx,
                          _OutputArray ky,
                          int          dx,
                          int          dy,
                          int          ksize,
                          bool         normalize = false,
                          int          ktype = CV_32F )

AutoIt:
    _OpenCV_ObjCreate("cv").getDerivKernels( $dx, $dy, $ksize[, $kx[, $ky[, $normalize[, $ktype]]]] ) -> $kx, $ky
```

### cv::getGaborKernel

```cpp
cv::Mat cv::getGaborKernel( cv::Size ksize,
                            double   sigma,
                            double   theta,
                            double   lambd,
                            double   gamma,
                            double   psi = CV_PI*0.5,
                            int      ktype = CV_64F )

AutoIt:
    _OpenCV_ObjCreate("cv").getGaborKernel( $ksize, $sigma, $theta, $lambd, $gamma[, $psi[, $ktype]] ) -> retval
```

### cv::getStructuringElement

```cpp
cv::Mat cv::getStructuringElement( int       shape,
                                   cv::Size  ksize,
                                   cv::Point anchor = Point(-1,-1) )

AutoIt:
    _OpenCV_ObjCreate("cv").getStructuringElement( $shape, $ksize[, $anchor] ) -> retval
```

### cv::medianBlur

```cpp
void cv::medianBlur( _InputArray  src,
                     _OutputArray dst,
                     int          ksize )

AutoIt:
    _OpenCV_ObjCreate("cv").medianBlur( $src, $ksize[, $dst] ) -> $dst
```

### cv::GaussianBlur

```cpp
void cv::GaussianBlur( _InputArray  src,
                       _OutputArray dst,
                       cv::Size     ksize,
                       double       sigmaX,
                       double       sigmaY = 0,
                       int          borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").GaussianBlur( $src, $ksize, $sigmaX[, $dst[, $sigmaY[, $borderType]]] ) -> $dst
```

### cv::bilateralFilter

```cpp
void cv::bilateralFilter( _InputArray  src,
                          _OutputArray dst,
                          int          d,
                          double       sigmaColor,
                          double       sigmaSpace,
                          int          borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").bilateralFilter( $src, $d, $sigmaColor, $sigmaSpace[, $dst[, $borderType]] ) -> $dst
```

### cv::boxFilter

```cpp
void cv::boxFilter( _InputArray  src,
                    _OutputArray dst,
                    int          ddepth,
                    cv::Size     ksize,
                    cv::Point    anchor = Point(-1,-1),
                    bool         normalize = true,
                    int          borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").boxFilter( $src, $ddepth, $ksize[, $dst[, $anchor[, $normalize[, $borderType]]]] ) -> $dst
```

### cv::sqrBoxFilter

```cpp
void cv::sqrBoxFilter( _InputArray  src,
                       _OutputArray dst,
                       int          ddepth,
                       cv::Size     ksize,
                       cv::Point    anchor = Point(-1, -1),
                       bool         normalize = true,
                       int          borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").sqrBoxFilter( $src, $ddepth, $ksize[, $dst[, $anchor[, $normalize[, $borderType]]]] ) -> $dst
```

### cv::blur

```cpp
void cv::blur( _InputArray  src,
               _OutputArray dst,
               cv::Size     ksize,
               cv::Point    anchor = Point(-1,-1),
               int          borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").blur( $src, $ksize[, $dst[, $anchor[, $borderType]]] ) -> $dst
```

### cv::filter2D

```cpp
void cv::filter2D( _InputArray  src,
                   _OutputArray dst,
                   int          ddepth,
                   _InputArray  kernel,
                   cv::Point    anchor = Point(-1,-1),
                   double       delta = 0,
                   int          borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").filter2D( $src, $ddepth, $kernel[, $dst[, $anchor[, $delta[, $borderType]]]] ) -> $dst
```

### cv::sepFilter2D

```cpp
void cv::sepFilter2D( _InputArray  src,
                      _OutputArray dst,
                      int          ddepth,
                      _InputArray  kernelX,
                      _InputArray  kernelY,
                      cv::Point    anchor = Point(-1,-1),
                      double       delta = 0,
                      int          borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").sepFilter2D( $src, $ddepth, $kernelX, $kernelY[, $dst[, $anchor[, $delta[, $borderType]]]] ) -> $dst
```

### cv::Sobel

```cpp
void cv::Sobel( _InputArray  src,
                _OutputArray dst,
                int          ddepth,
                int          dx,
                int          dy,
                int          ksize = 3,
                double       scale = 1,
                double       delta = 0,
                int          borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").Sobel( $src, $ddepth, $dx, $dy[, $dst[, $ksize[, $scale[, $delta[, $borderType]]]]] ) -> $dst
```

### cv::spatialGradient

```cpp
void cv::spatialGradient( _InputArray  src,
                          _OutputArray dx,
                          _OutputArray dy,
                          int          ksize = 3,
                          int          borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").spatialGradient( $src[, $dx[, $dy[, $ksize[, $borderType]]]] ) -> $dx, $dy
```

### cv::Scharr

```cpp
void cv::Scharr( _InputArray  src,
                 _OutputArray dst,
                 int          ddepth,
                 int          dx,
                 int          dy,
                 double       scale = 1,
                 double       delta = 0,
                 int          borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").Scharr( $src, $ddepth, $dx, $dy[, $dst[, $scale[, $delta[, $borderType]]]] ) -> $dst
```

### cv::Laplacian

```cpp
void cv::Laplacian( _InputArray  src,
                    _OutputArray dst,
                    int          ddepth,
                    int          ksize = 1,
                    double       scale = 1,
                    double       delta = 0,
                    int          borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").Laplacian( $src, $ddepth[, $dst[, $ksize[, $scale[, $delta[, $borderType]]]]] ) -> $dst
```

### cv::Canny

```cpp
void cv::Canny( _InputArray  image,
                _OutputArray edges,
                double       threshold1,
                double       threshold2,
                int          apertureSize = 3,
                bool         L2gradient = false )

AutoIt:
    _OpenCV_ObjCreate("cv").Canny( $image, $threshold1, $threshold2[, $edges[, $apertureSize[, $L2gradient]]] ) -> $edges
```

```cpp
void cv::Canny( _InputArray  dx,
                _InputArray  dy,
                _OutputArray edges,
                double       threshold1,
                double       threshold2,
                bool         L2gradient = false )

AutoIt:
    _OpenCV_ObjCreate("cv").Canny( $dx, $dy, $threshold1, $threshold2[, $edges[, $L2gradient]] ) -> $edges
```

### cv::cornerMinEigenVal

```cpp
void cv::cornerMinEigenVal( _InputArray  src,
                            _OutputArray dst,
                            int          blockSize,
                            int          ksize = 3,
                            int          borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").cornerMinEigenVal( $src, $blockSize[, $dst[, $ksize[, $borderType]]] ) -> $dst
```

### cv::cornerHarris

```cpp
void cv::cornerHarris( _InputArray  src,
                       _OutputArray dst,
                       int          blockSize,
                       int          ksize,
                       double       k,
                       int          borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").cornerHarris( $src, $blockSize, $ksize, $k[, $dst[, $borderType]] ) -> $dst
```

### cv::cornerEigenValsAndVecs

```cpp
void cv::cornerEigenValsAndVecs( _InputArray  src,
                                 _OutputArray dst,
                                 int          blockSize,
                                 int          ksize,
                                 int          borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").cornerEigenValsAndVecs( $src, $blockSize, $ksize[, $dst[, $borderType]] ) -> $dst
```

### cv::preCornerDetect

```cpp
void cv::preCornerDetect( _InputArray  src,
                          _OutputArray dst,
                          int          ksize,
                          int          borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").preCornerDetect( $src, $ksize[, $dst[, $borderType]] ) -> $dst
```

### cv::cornerSubPix

```cpp
void cv::cornerSubPix( _InputArray       image,
                       _InputOutputArray corners,
                       cv::Size          winSize,
                       cv::Size          zeroZone,
                       cv::TermCriteria  criteria )

AutoIt:
    _OpenCV_ObjCreate("cv").cornerSubPix( $image, $corners, $winSize, $zeroZone, $criteria ) -> $corners
```

### cv::goodFeaturesToTrack

```cpp
void cv::goodFeaturesToTrack( _InputArray  image,
                              _OutputArray corners,
                              int          maxCorners,
                              double       qualityLevel,
                              double       minDistance,
                              _InputArray  mask = noArray(),
                              int          blockSize = 3,
                              bool         useHarrisDetector = false,
                              double       k = 0.04 )

AutoIt:
    _OpenCV_ObjCreate("cv").goodFeaturesToTrack( $image, $maxCorners, $qualityLevel, $minDistance[, $corners[, $mask[, $blockSize[, $useHarrisDetector[, $k]]]]] ) -> $corners
```

```cpp
void cv::goodFeaturesToTrack( _InputArray  image,
                              _OutputArray corners,
                              int          maxCorners,
                              double       qualityLevel,
                              double       minDistance,
                              _InputArray  mask,
                              int          blockSize,
                              int          gradientSize,
                              bool         useHarrisDetector = false,
                              double       k = 0.04 )

AutoIt:
    _OpenCV_ObjCreate("cv").goodFeaturesToTrack( $image, $maxCorners, $qualityLevel, $minDistance, $mask, $blockSize, $gradientSize[, $corners[, $useHarrisDetector[, $k]]] ) -> $corners
```

### cv::goodFeaturesToTrackWithQuality

```cpp
void cv::goodFeaturesToTrackWithQuality( _InputArray  image,
                                         _OutputArray corners,
                                         int          maxCorners,
                                         double       qualityLevel,
                                         double       minDistance,
                                         _InputArray  mask,
                                         _OutputArray cornersQuality,
                                         int          blockSize = 3,
                                         int          gradientSize = 3,
                                         bool         useHarrisDetector = false,
                                         double       k = 0.04 )

AutoIt:
    _OpenCV_ObjCreate("cv").goodFeaturesToTrackWithQuality( $image, $maxCorners, $qualityLevel, $minDistance, $mask[, $corners[, $cornersQuality[, $blockSize[, $gradientSize[, $useHarrisDetector[, $k]]]]]] ) -> $corners, $cornersQuality
```

### cv::HoughLines

```cpp
void cv::HoughLines( _InputArray  image,
                     _OutputArray lines,
                     double       rho,
                     double       theta,
                     int          threshold,
                     double       srn = 0,
                     double       stn = 0,
                     double       min_theta = 0,
                     double       max_theta = CV_PI )

AutoIt:
    _OpenCV_ObjCreate("cv").HoughLines( $image, $rho, $theta, $threshold[, $lines[, $srn[, $stn[, $min_theta[, $max_theta]]]]] ) -> $lines
```

### cv::HoughLinesP

```cpp
void cv::HoughLinesP( _InputArray  image,
                      _OutputArray lines,
                      double       rho,
                      double       theta,
                      int          threshold,
                      double       minLineLength = 0,
                      double       maxLineGap = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").HoughLinesP( $image, $rho, $theta, $threshold[, $lines[, $minLineLength[, $maxLineGap]]] ) -> $lines
```

### cv::HoughLinesPointSet

```cpp
void cv::HoughLinesPointSet( _InputArray  point,
                             _OutputArray lines,
                             int          lines_max,
                             int          threshold,
                             double       min_rho,
                             double       max_rho,
                             double       rho_step,
                             double       min_theta,
                             double       max_theta,
                             double       theta_step )

AutoIt:
    _OpenCV_ObjCreate("cv").HoughLinesPointSet( $point, $lines_max, $threshold, $min_rho, $max_rho, $rho_step, $min_theta, $max_theta, $theta_step[, $lines] ) -> $lines
```

### cv::HoughCircles

```cpp
void cv::HoughCircles( _InputArray  image,
                       _OutputArray circles,
                       int          method,
                       double       dp,
                       double       minDist,
                       double       param1 = 100,
                       double       param2 = 100,
                       int          minRadius = 0,
                       int          maxRadius = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").HoughCircles( $image, $method, $dp, $minDist[, $circles[, $param1[, $param2[, $minRadius[, $maxRadius]]]]] ) -> $circles
```

### cv::erode

```cpp
void cv::erode( _InputArray       src,
                _OutputArray      dst,
                _InputArray       kernel,
                cv::Point         anchor = Point(-1,-1),
                int               iterations = 1,
                int               borderType = BORDER_CONSTANT,
                const cv::Scalar& borderValue = morphologyDefaultBorderValue() )

AutoIt:
    _OpenCV_ObjCreate("cv").erode( $src, $kernel[, $dst[, $anchor[, $iterations[, $borderType[, $borderValue]]]]] ) -> $dst
```

### cv::dilate

```cpp
void cv::dilate( _InputArray       src,
                 _OutputArray      dst,
                 _InputArray       kernel,
                 cv::Point         anchor = Point(-1,-1),
                 int               iterations = 1,
                 int               borderType = BORDER_CONSTANT,
                 const cv::Scalar& borderValue = morphologyDefaultBorderValue() )

AutoIt:
    _OpenCV_ObjCreate("cv").dilate( $src, $kernel[, $dst[, $anchor[, $iterations[, $borderType[, $borderValue]]]]] ) -> $dst
```

### cv::morphologyEx

```cpp
void cv::morphologyEx( _InputArray       src,
                       _OutputArray      dst,
                       int               op,
                       _InputArray       kernel,
                       cv::Point         anchor = Point(-1,-1),
                       int               iterations = 1,
                       int               borderType = BORDER_CONSTANT,
                       const cv::Scalar& borderValue = morphologyDefaultBorderValue() )

AutoIt:
    _OpenCV_ObjCreate("cv").morphologyEx( $src, $op, $kernel[, $dst[, $anchor[, $iterations[, $borderType[, $borderValue]]]]] ) -> $dst
```

### cv::resize

```cpp
void cv::resize( _InputArray  src,
                 _OutputArray dst,
                 cv::Size     dsize,
                 double       fx = 0,
                 double       fy = 0,
                 int          interpolation = INTER_LINEAR )

AutoIt:
    _OpenCV_ObjCreate("cv").resize( $src, $dsize[, $dst[, $fx[, $fy[, $interpolation]]]] ) -> $dst
```

### cv::warpAffine

```cpp
void cv::warpAffine( _InputArray       src,
                     _OutputArray      dst,
                     _InputArray       M,
                     cv::Size          dsize,
                     int               flags = INTER_LINEAR,
                     int               borderMode = BORDER_CONSTANT,
                     const cv::Scalar& borderValue = Scalar() )

AutoIt:
    _OpenCV_ObjCreate("cv").warpAffine( $src, $M, $dsize[, $dst[, $flags[, $borderMode[, $borderValue]]]] ) -> $dst
```

### cv::warpPerspective

```cpp
void cv::warpPerspective( _InputArray       src,
                          _OutputArray      dst,
                          _InputArray       M,
                          cv::Size          dsize,
                          int               flags = INTER_LINEAR,
                          int               borderMode = BORDER_CONSTANT,
                          const cv::Scalar& borderValue = Scalar() )

AutoIt:
    _OpenCV_ObjCreate("cv").warpPerspective( $src, $M, $dsize[, $dst[, $flags[, $borderMode[, $borderValue]]]] ) -> $dst
```

### cv::remap

```cpp
void cv::remap( _InputArray       src,
                _OutputArray      dst,
                _InputArray       map1,
                _InputArray       map2,
                int               interpolation,
                int               borderMode = BORDER_CONSTANT,
                const cv::Scalar& borderValue = Scalar() )

AutoIt:
    _OpenCV_ObjCreate("cv").remap( $src, $map1, $map2, $interpolation[, $dst[, $borderMode[, $borderValue]]] ) -> $dst
```

### cv::convertMaps

```cpp
void cv::convertMaps( _InputArray  map1,
                      _InputArray  map2,
                      _OutputArray dstmap1,
                      _OutputArray dstmap2,
                      int          dstmap1type,
                      bool         nninterpolation = false )

AutoIt:
    _OpenCV_ObjCreate("cv").convertMaps( $map1, $map2, $dstmap1type[, $dstmap1[, $dstmap2[, $nninterpolation]]] ) -> $dstmap1, $dstmap2
```

### cv::getRotationMatrix2D

```cpp
cv::Mat cv::getRotationMatrix2D( cv::Point2f center,
                                 double      angle,
                                 double      scale )

AutoIt:
    _OpenCV_ObjCreate("cv").getRotationMatrix2D( $center, $angle, $scale ) -> retval
```

### cv::invertAffineTransform

```cpp
void cv::invertAffineTransform( _InputArray  M,
                                _OutputArray iM )

AutoIt:
    _OpenCV_ObjCreate("cv").invertAffineTransform( $M[, $iM] ) -> $iM
```

### cv::getPerspectiveTransform

```cpp
cv::Mat cv::getPerspectiveTransform( _InputArray src,
                                     _InputArray dst,
                                     int         solveMethod = DECOMP_LU )

AutoIt:
    _OpenCV_ObjCreate("cv").getPerspectiveTransform( $src, $dst[, $solveMethod] ) -> retval
```

### cv::getAffineTransform

```cpp
cv::Mat cv::getAffineTransform( _InputArray src,
                                _InputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").getAffineTransform( $src, $dst ) -> retval
```

### cv::getRectSubPix

```cpp
void cv::getRectSubPix( _InputArray  image,
                        cv::Size     patchSize,
                        cv::Point2f  center,
                        _OutputArray patch,
                        int          patchType = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv").getRectSubPix( $image, $patchSize, $center[, $patch[, $patchType]] ) -> $patch
```

### cv::logPolar

```cpp
void cv::logPolar( _InputArray  src,
                   _OutputArray dst,
                   cv::Point2f  center,
                   double       M,
                   int          flags )

AutoIt:
    _OpenCV_ObjCreate("cv").logPolar( $src, $center, $M, $flags[, $dst] ) -> $dst
```

### cv::linearPolar

```cpp
void cv::linearPolar( _InputArray  src,
                      _OutputArray dst,
                      cv::Point2f  center,
                      double       maxRadius,
                      int          flags )

AutoIt:
    _OpenCV_ObjCreate("cv").linearPolar( $src, $center, $maxRadius, $flags[, $dst] ) -> $dst
```

### cv::warpPolar

```cpp
void cv::warpPolar( _InputArray  src,
                    _OutputArray dst,
                    cv::Size     dsize,
                    cv::Point2f  center,
                    double       maxRadius,
                    int          flags )

AutoIt:
    _OpenCV_ObjCreate("cv").warpPolar( $src, $dsize, $center, $maxRadius, $flags[, $dst] ) -> $dst
```

### cv::integral3

```cpp
void cv::integral3( _InputArray  src,
                    _OutputArray sum,
                    _OutputArray sqsum,
                    _OutputArray tilted,
                    int          sdepth = -1,
                    int          sqdepth = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv").integral3( $src[, $sum[, $sqsum[, $tilted[, $sdepth[, $sqdepth]]]]] ) -> $sum, $sqsum, $tilted
```

### cv::integral

```cpp
void cv::integral( _InputArray  src,
                   _OutputArray sum,
                   int          sdepth = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv").integral( $src[, $sum[, $sdepth]] ) -> $sum
```

### cv::integral2

```cpp
void cv::integral2( _InputArray  src,
                    _OutputArray sum,
                    _OutputArray sqsum,
                    int          sdepth = -1,
                    int          sqdepth = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv").integral2( $src[, $sum[, $sqsum[, $sdepth[, $sqdepth]]]] ) -> $sum, $sqsum
```

### cv::accumulate

```cpp
void cv::accumulate( _InputArray       src,
                     _InputOutputArray dst,
                     _InputArray       mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").accumulate( $src, $dst[, $mask] ) -> $dst
```

### cv::accumulateSquare

```cpp
void cv::accumulateSquare( _InputArray       src,
                           _InputOutputArray dst,
                           _InputArray       mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").accumulateSquare( $src, $dst[, $mask] ) -> $dst
```

### cv::accumulateProduct

```cpp
void cv::accumulateProduct( _InputArray       src1,
                            _InputArray       src2,
                            _InputOutputArray dst,
                            _InputArray       mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").accumulateProduct( $src1, $src2, $dst[, $mask] ) -> $dst
```

### cv::accumulateWeighted

```cpp
void cv::accumulateWeighted( _InputArray       src,
                             _InputOutputArray dst,
                             double            alpha,
                             _InputArray       mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").accumulateWeighted( $src, $dst, $alpha[, $mask] ) -> $dst
```

### cv::phaseCorrelate

```cpp
cv::Point2d cv::phaseCorrelate( _InputArray src1,
                                _InputArray src2,
                                _InputArray window = noArray(),
                                double*     response = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").phaseCorrelate( $src1, $src2[, $window[, $response]] ) -> retval, $response
```

### cv::createHanningWindow

```cpp
void cv::createHanningWindow( _OutputArray dst,
                              cv::Size     winSize,
                              int          type )

AutoIt:
    _OpenCV_ObjCreate("cv").createHanningWindow( $winSize, $type[, $dst] ) -> $dst
```

### cv::divSpectrums

```cpp
void cv::divSpectrums( _InputArray  a,
                       _InputArray  b,
                       _OutputArray c,
                       int          flags,
                       bool         conjB = false )

AutoIt:
    _OpenCV_ObjCreate("cv").divSpectrums( $a, $b, $flags[, $c[, $conjB]] ) -> $c
```

### cv::threshold

```cpp
double cv::threshold( _InputArray  src,
                      _OutputArray dst,
                      double       thresh,
                      double       maxval,
                      int          type )

AutoIt:
    _OpenCV_ObjCreate("cv").threshold( $src, $thresh, $maxval, $type[, $dst] ) -> retval, $dst
```

### cv::adaptiveThreshold

```cpp
void cv::adaptiveThreshold( _InputArray  src,
                            _OutputArray dst,
                            double       maxValue,
                            int          adaptiveMethod,
                            int          thresholdType,
                            int          blockSize,
                            double       C )

AutoIt:
    _OpenCV_ObjCreate("cv").adaptiveThreshold( $src, $maxValue, $adaptiveMethod, $thresholdType, $blockSize, $C[, $dst] ) -> $dst
```

### cv::pyrDown

```cpp
void cv::pyrDown( _InputArray     src,
                  _OutputArray    dst,
                  const cv::Size& dstsize = Size(),
                  int             borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").pyrDown( $src[, $dst[, $dstsize[, $borderType]]] ) -> $dst
```

### cv::pyrUp

```cpp
void cv::pyrUp( _InputArray     src,
                _OutputArray    dst,
                const cv::Size& dstsize = Size(),
                int             borderType = BORDER_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").pyrUp( $src[, $dst[, $dstsize[, $borderType]]] ) -> $dst
```

### cv::calcHist

```cpp
void cv::calcHist( _InputArray               images,
                   const std::vector<int>&   channels,
                   _InputArray               mask,
                   _OutputArray              hist,
                   const std::vector<int>&   histSize,
                   const std::vector<float>& ranges,
                   bool                      accumulate = false )

AutoIt:
    _OpenCV_ObjCreate("cv").calcHist( $images, $channels, $mask, $histSize, $ranges[, $hist[, $accumulate]] ) -> $hist
```

### cv::calcBackProject

```cpp
void cv::calcBackProject( _InputArray               images,
                          const std::vector<int>&   channels,
                          _InputArray               hist,
                          _OutputArray              dst,
                          const std::vector<float>& ranges,
                          double                    scale )

AutoIt:
    _OpenCV_ObjCreate("cv").calcBackProject( $images, $channels, $hist, $ranges, $scale[, $dst] ) -> $dst
```

### cv::compareHist

```cpp
double cv::compareHist( _InputArray H1,
                        _InputArray H2,
                        int         method )

AutoIt:
    _OpenCV_ObjCreate("cv").compareHist( $H1, $H2, $method ) -> retval
```

### cv::equalizeHist

```cpp
void cv::equalizeHist( _InputArray  src,
                       _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").equalizeHist( $src[, $dst] ) -> $dst
```

### cv::createCLAHE

```cpp
cv::Ptr<cv::CLAHE> cv::createCLAHE( double   clipLimit = 40.0,
                                    cv::Size tileGridSize = Size(8, 8) )

AutoIt:
    _OpenCV_ObjCreate("cv").createCLAHE( [$clipLimit[, $tileGridSize]] ) -> retval
```

### cv::EMD

```cpp
float cv::EMD( _InputArray    signature1,
               _InputArray    signature2,
               int            distType,
               _InputArray    cost = noArray(),
               cv::Ptr<float> lowerBound = Ptr<float>(),
               _OutputArray   flow = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").EMD( $signature1, $signature2, $distType[, $cost[, $lowerBound[, $flow]]] ) -> retval, $lowerBound, $flow
```

### cv::watershed

```cpp
void cv::watershed( _InputArray       image,
                    _InputOutputArray markers )

AutoIt:
    _OpenCV_ObjCreate("cv").watershed( $image, $markers ) -> $markers
```

### cv::pyrMeanShiftFiltering

```cpp
void cv::pyrMeanShiftFiltering( _InputArray      src,
                                _OutputArray     dst,
                                double           sp,
                                double           sr,
                                int              maxLevel = 1,
                                cv::TermCriteria termcrit = TermCriteria(TermCriteria::MAX_ITER+TermCriteria::EPS,5,1) )

AutoIt:
    _OpenCV_ObjCreate("cv").pyrMeanShiftFiltering( $src, $sp, $sr[, $dst[, $maxLevel[, $termcrit]]] ) -> $dst
```

### cv::grabCut

```cpp
void cv::grabCut( _InputArray       img,
                  _InputOutputArray mask,
                  cv::Rect          rect,
                  _InputOutputArray bgdModel,
                  _InputOutputArray fgdModel,
                  int               iterCount,
                  int               mode = GC_EVAL )

AutoIt:
    _OpenCV_ObjCreate("cv").grabCut( $img, $mask, $rect, $bgdModel, $fgdModel, $iterCount[, $mode] ) -> $mask, $bgdModel, $fgdModel
```

### cv::distanceTransformWithLabels

```cpp
void cv::distanceTransformWithLabels( _InputArray  src,
                                      _OutputArray dst,
                                      _OutputArray labels,
                                      int          distanceType,
                                      int          maskSize,
                                      int          labelType = DIST_LABEL_CCOMP )

AutoIt:
    _OpenCV_ObjCreate("cv").distanceTransformWithLabels( $src, $distanceType, $maskSize[, $dst[, $labels[, $labelType]]] ) -> $dst, $labels
```

### cv::distanceTransform

```cpp
void cv::distanceTransform( _InputArray  src,
                            _OutputArray dst,
                            int          distanceType,
                            int          maskSize,
                            int          dstType = CV_32F )

AutoIt:
    _OpenCV_ObjCreate("cv").distanceTransform( $src, $distanceType, $maskSize[, $dst[, $dstType]] ) -> $dst
```

### cv::floodFill

```cpp
int cv::floodFill( _InputOutputArray image,
                   _InputOutputArray mask,
                   cv::Point         seedPoint,
                   cv::Scalar        newVal,
                   cv::Rect*         rect = 0,
                   cv::Scalar        loDiff = Scalar(),
                   cv::Scalar        upDiff = Scalar(),
                   int               flags = 4 )

AutoIt:
    _OpenCV_ObjCreate("cv").floodFill( $image, $mask, $seedPoint, $newVal[, $loDiff[, $upDiff[, $flags[, $rect]]]] ) -> retval, $image, $mask, $rect
```

### cv::blendLinear

```cpp
void cv::blendLinear( _InputArray  src1,
                      _InputArray  src2,
                      _InputArray  weights1,
                      _InputArray  weights2,
                      _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").blendLinear( $src1, $src2, $weights1, $weights2[, $dst] ) -> $dst
```

### cv::cvtColor

```cpp
void cv::cvtColor( _InputArray  src,
                   _OutputArray dst,
                   int          code,
                   int          dstCn = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").cvtColor( $src, $code[, $dst[, $dstCn]] ) -> $dst
```

### cv::cvtColorTwoPlane

```cpp
void cv::cvtColorTwoPlane( _InputArray  src1,
                           _InputArray  src2,
                           _OutputArray dst,
                           int          code )

AutoIt:
    _OpenCV_ObjCreate("cv").cvtColorTwoPlane( $src1, $src2, $code[, $dst] ) -> $dst
```

### cv::demosaicing

```cpp
void cv::demosaicing( _InputArray  src,
                      _OutputArray dst,
                      int          code,
                      int          dstCn = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").demosaicing( $src, $code[, $dst[, $dstCn]] ) -> $dst
```

### cv::moments

```cpp
cv::Moments cv::moments( _InputArray array,
                         bool        binaryImage = false )

AutoIt:
    _OpenCV_ObjCreate("cv").moments( $array[, $binaryImage] ) -> retval
```

### cv::HuMoments

```cpp
void cv::HuMoments( const cv::Moments& m,
                    _OutputArray       hu )

AutoIt:
    _OpenCV_ObjCreate("cv").HuMoments( $m[, $hu] ) -> $hu
```

### cv::matchTemplate

```cpp
void cv::matchTemplate( _InputArray  image,
                        _InputArray  templ,
                        _OutputArray result,
                        int          method,
                        _InputArray  mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").matchTemplate( $image, $templ, $method[, $result[, $mask]] ) -> $result
```

### cv::connectedComponentsWithAlgorithm

```cpp
int cv::connectedComponentsWithAlgorithm( _InputArray  image,
                                          _OutputArray labels,
                                          int          connectivity,
                                          int          ltype,
                                          int          ccltype )

AutoIt:
    _OpenCV_ObjCreate("cv").connectedComponentsWithAlgorithm( $image, $connectivity, $ltype, $ccltype[, $labels] ) -> retval, $labels
```

### cv::connectedComponents

```cpp
int cv::connectedComponents( _InputArray  image,
                             _OutputArray labels,
                             int          connectivity = 8,
                             int          ltype = CV_32S )

AutoIt:
    _OpenCV_ObjCreate("cv").connectedComponents( $image[, $labels[, $connectivity[, $ltype]]] ) -> retval, $labels
```

### cv::connectedComponentsWithStatsWithAlgorithm

```cpp
int cv::connectedComponentsWithStatsWithAlgorithm( _InputArray  image,
                                                   _OutputArray labels,
                                                   _OutputArray stats,
                                                   _OutputArray centroids,
                                                   int          connectivity,
                                                   int          ltype,
                                                   int          ccltype )

AutoIt:
    _OpenCV_ObjCreate("cv").connectedComponentsWithStatsWithAlgorithm( $image, $connectivity, $ltype, $ccltype[, $labels[, $stats[, $centroids]]] ) -> retval, $labels, $stats, $centroids
```

### cv::connectedComponentsWithStats

```cpp
int cv::connectedComponentsWithStats( _InputArray  image,
                                      _OutputArray labels,
                                      _OutputArray stats,
                                      _OutputArray centroids,
                                      int          connectivity = 8,
                                      int          ltype = CV_32S )

AutoIt:
    _OpenCV_ObjCreate("cv").connectedComponentsWithStats( $image[, $labels[, $stats[, $centroids[, $connectivity[, $ltype]]]]] ) -> retval, $labels, $stats, $centroids
```

### cv::findContours

```cpp
void cv::findContours( _InputArray  image,
                       _OutputArray contours,
                       _OutputArray hierarchy,
                       int          mode,
                       int          method,
                       cv::Point    offset = Point() )

AutoIt:
    _OpenCV_ObjCreate("cv").findContours( $image, $mode, $method[, $contours[, $hierarchy[, $offset]]] ) -> $contours, $hierarchy
```

### cv::approxPolyDP

```cpp
void cv::approxPolyDP( _InputArray  curve,
                       _OutputArray approxCurve,
                       double       epsilon,
                       bool         closed )

AutoIt:
    _OpenCV_ObjCreate("cv").approxPolyDP( $curve, $epsilon, $closed[, $approxCurve] ) -> $approxCurve
```

### cv::arcLength

```cpp
double cv::arcLength( _InputArray curve,
                      bool        closed )

AutoIt:
    _OpenCV_ObjCreate("cv").arcLength( $curve, $closed ) -> retval
```

### cv::boundingRect

```cpp
cv::Rect cv::boundingRect( _InputArray array )

AutoIt:
    _OpenCV_ObjCreate("cv").boundingRect( $array ) -> retval
```

### cv::contourArea

```cpp
double cv::contourArea( _InputArray contour,
                        bool        oriented = false )

AutoIt:
    _OpenCV_ObjCreate("cv").contourArea( $contour[, $oriented] ) -> retval
```

### cv::minAreaRect

```cpp
cv::RotatedRect cv::minAreaRect( _InputArray points )

AutoIt:
    _OpenCV_ObjCreate("cv").minAreaRect( $points ) -> retval
```

### cv::boxPoints

```cpp
void cv::boxPoints( cv::RotatedRect box,
                    _OutputArray    points )

AutoIt:
    _OpenCV_ObjCreate("cv").boxPoints( $box[, $points] ) -> $points
```

### cv::minEnclosingCircle

```cpp
void cv::minEnclosingCircle( _InputArray  points,
                             cv::Point2f& center,
                             float&       radius )

AutoIt:
    _OpenCV_ObjCreate("cv").minEnclosingCircle( $points[, $center[, $radius]] ) -> $center, $radius
```

### cv::minEnclosingTriangle

```cpp
double cv::minEnclosingTriangle( _InputArray  points,
                                 _OutputArray triangle )

AutoIt:
    _OpenCV_ObjCreate("cv").minEnclosingTriangle( $points[, $triangle] ) -> retval, $triangle
```

### cv::matchShapes

```cpp
double cv::matchShapes( _InputArray contour1,
                        _InputArray contour2,
                        int         method,
                        double      parameter )

AutoIt:
    _OpenCV_ObjCreate("cv").matchShapes( $contour1, $contour2, $method, $parameter ) -> retval
```

### cv::convexHull

```cpp
void cv::convexHull( _InputArray  points,
                     _OutputArray hull,
                     bool         clockwise = false,
                     bool         returnPoints = true )

AutoIt:
    _OpenCV_ObjCreate("cv").convexHull( $points[, $hull[, $clockwise[, $returnPoints]]] ) -> $hull
```

### cv::convexityDefects

```cpp
void cv::convexityDefects( _InputArray  contour,
                           _InputArray  convexhull,
                           _OutputArray convexityDefects )

AutoIt:
    _OpenCV_ObjCreate("cv").convexityDefects( $contour, $convexhull[, $convexityDefects] ) -> $convexityDefects
```

### cv::isContourConvex

```cpp
bool cv::isContourConvex( _InputArray contour )

AutoIt:
    _OpenCV_ObjCreate("cv").isContourConvex( $contour ) -> retval
```

### cv::intersectConvexConvex

```cpp
float cv::intersectConvexConvex( _InputArray  p1,
                                 _InputArray  p2,
                                 _OutputArray p12,
                                 bool         handleNested = true )

AutoIt:
    _OpenCV_ObjCreate("cv").intersectConvexConvex( $p1, $p2[, $p12[, $handleNested]] ) -> retval, $p12
```

### cv::fitEllipse

```cpp
cv::RotatedRect cv::fitEllipse( _InputArray points )

AutoIt:
    _OpenCV_ObjCreate("cv").fitEllipse( $points ) -> retval
```

### cv::fitEllipseAMS

```cpp
cv::RotatedRect cv::fitEllipseAMS( _InputArray points )

AutoIt:
    _OpenCV_ObjCreate("cv").fitEllipseAMS( $points ) -> retval
```

### cv::fitEllipseDirect

```cpp
cv::RotatedRect cv::fitEllipseDirect( _InputArray points )

AutoIt:
    _OpenCV_ObjCreate("cv").fitEllipseDirect( $points ) -> retval
```

### cv::fitLine

```cpp
void cv::fitLine( _InputArray  points,
                  _OutputArray line,
                  int          distType,
                  double       param,
                  double       reps,
                  double       aeps )

AutoIt:
    _OpenCV_ObjCreate("cv").fitLine( $points, $distType, $param, $reps, $aeps[, $line] ) -> $line
```

### cv::pointPolygonTest

```cpp
double cv::pointPolygonTest( _InputArray contour,
                             cv::Point2f pt,
                             bool        measureDist )

AutoIt:
    _OpenCV_ObjCreate("cv").pointPolygonTest( $contour, $pt, $measureDist ) -> retval
```

### cv::rotatedRectangleIntersection

```cpp
int cv::rotatedRectangleIntersection( const cv::RotatedRect& rect1,
                                      const cv::RotatedRect& rect2,
                                      _OutputArray           intersectingRegion )

AutoIt:
    _OpenCV_ObjCreate("cv").rotatedRectangleIntersection( $rect1, $rect2[, $intersectingRegion] ) -> retval, $intersectingRegion
```

### cv::createGeneralizedHoughBallard

```cpp
cv::Ptr<cv::GeneralizedHoughBallard> cv::createGeneralizedHoughBallard()

AutoIt:
    _OpenCV_ObjCreate("cv").createGeneralizedHoughBallard() -> retval
```

### cv::createGeneralizedHoughGuil

```cpp
cv::Ptr<cv::GeneralizedHoughGuil> cv::createGeneralizedHoughGuil()

AutoIt:
    _OpenCV_ObjCreate("cv").createGeneralizedHoughGuil() -> retval
```

### cv::applyColorMap

```cpp
void cv::applyColorMap( _InputArray  src,
                        _OutputArray dst,
                        int          colormap )

AutoIt:
    _OpenCV_ObjCreate("cv").applyColorMap( $src, $colormap[, $dst] ) -> $dst
```

```cpp
void cv::applyColorMap( _InputArray  src,
                        _OutputArray dst,
                        _InputArray  userColor )

AutoIt:
    _OpenCV_ObjCreate("cv").applyColorMap( $src, $userColor[, $dst] ) -> $dst
```

### cv::line

```cpp
void cv::line( _InputOutputArray img,
               cv::Point         pt1,
               cv::Point         pt2,
               const cv::Scalar& color,
               int               thickness = 1,
               int               lineType = LINE_8,
               int               shift = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").line( $img, $pt1, $pt2, $color[, $thickness[, $lineType[, $shift]]] ) -> $img
```

### cv::arrowedLine

```cpp
void cv::arrowedLine( _InputOutputArray img,
                      cv::Point         pt1,
                      cv::Point         pt2,
                      const cv::Scalar& color,
                      int               thickness = 1,
                      int               line_type = 8,
                      int               shift = 0,
                      double            tipLength = 0.1 )

AutoIt:
    _OpenCV_ObjCreate("cv").arrowedLine( $img, $pt1, $pt2, $color[, $thickness[, $line_type[, $shift[, $tipLength]]]] ) -> $img
```

### cv::rectangle

```cpp
void cv::rectangle( _InputOutputArray img,
                    cv::Point         pt1,
                    cv::Point         pt2,
                    const cv::Scalar& color,
                    int               thickness = 1,
                    int               lineType = LINE_8,
                    int               shift = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").rectangle( $img, $pt1, $pt2, $color[, $thickness[, $lineType[, $shift]]] ) -> $img
```

```cpp
void cv::rectangle( _InputOutputArray img,
                    cv::Rect          rec,
                    const cv::Scalar& color,
                    int               thickness = 1,
                    int               lineType = LINE_8,
                    int               shift = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").rectangle( $img, $rec, $color[, $thickness[, $lineType[, $shift]]] ) -> $img
```

### cv::circle

```cpp
void cv::circle( _InputOutputArray img,
                 cv::Point         center,
                 int               radius,
                 const cv::Scalar& color,
                 int               thickness = 1,
                 int               lineType = LINE_8,
                 int               shift = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").circle( $img, $center, $radius, $color[, $thickness[, $lineType[, $shift]]] ) -> $img
```

### cv::ellipse

```cpp
void cv::ellipse( _InputOutputArray img,
                  cv::Point         center,
                  cv::Size          axes,
                  double            angle,
                  double            startAngle,
                  double            endAngle,
                  const cv::Scalar& color,
                  int               thickness = 1,
                  int               lineType = LINE_8,
                  int               shift = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").ellipse( $img, $center, $axes, $angle, $startAngle, $endAngle, $color[, $thickness[, $lineType[, $shift]]] ) -> $img
```

```cpp
void cv::ellipse( _InputOutputArray      img,
                  const cv::RotatedRect& box,
                  const cv::Scalar&      color,
                  int                    thickness = 1,
                  int                    lineType = LINE_8 )

AutoIt:
    _OpenCV_ObjCreate("cv").ellipse( $img, $box, $color[, $thickness[, $lineType]] ) -> $img
```

### cv::drawMarker

```cpp
void cv::drawMarker( _InputOutputArray img,
                     cv::Point         position,
                     const cv::Scalar& color,
                     int               markerType = MARKER_CROSS,
                     int               markerSize = 20,
                     int               thickness = 1,
                     int               line_type = 8 )

AutoIt:
    _OpenCV_ObjCreate("cv").drawMarker( $img, $position, $color[, $markerType[, $markerSize[, $thickness[, $line_type]]]] ) -> $img
```

### cv::fillConvexPoly

```cpp
void cv::fillConvexPoly( _InputOutputArray img,
                         _InputArray       points,
                         const cv::Scalar& color,
                         int               lineType = LINE_8,
                         int               shift = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").fillConvexPoly( $img, $points, $color[, $lineType[, $shift]] ) -> $img
```

### cv::fillPoly

```cpp
void cv::fillPoly( _InputOutputArray img,
                   _InputArray       pts,
                   const cv::Scalar& color,
                   int               lineType = LINE_8,
                   int               shift = 0,
                   cv::Point         offset = Point() )

AutoIt:
    _OpenCV_ObjCreate("cv").fillPoly( $img, $pts, $color[, $lineType[, $shift[, $offset]]] ) -> $img
```

### cv::polylines

```cpp
void cv::polylines( _InputOutputArray img,
                    _InputArray       pts,
                    bool              isClosed,
                    const cv::Scalar& color,
                    int               thickness = 1,
                    int               lineType = LINE_8,
                    int               shift = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").polylines( $img, $pts, $isClosed, $color[, $thickness[, $lineType[, $shift]]] ) -> $img
```

### cv::drawContours

```cpp
void cv::drawContours( _InputOutputArray image,
                       _InputArray       contours,
                       int               contourIdx,
                       const cv::Scalar& color,
                       int               thickness = 1,
                       int               lineType = LINE_8,
                       _InputArray       hierarchy = noArray(),
                       int               maxLevel = INT_MAX,
                       cv::Point         offset = Point() )

AutoIt:
    _OpenCV_ObjCreate("cv").drawContours( $image, $contours, $contourIdx, $color[, $thickness[, $lineType[, $hierarchy[, $maxLevel[, $offset]]]]] ) -> $image
```

### cv::clipLine

```cpp
bool cv::clipLine( cv::Rect   imgRect,
                   cv::Point& pt1,
                   cv::Point& pt2 )

AutoIt:
    _OpenCV_ObjCreate("cv").clipLine( $imgRect, $pt1, $pt2 ) -> retval, $pt1, $pt2
```

### cv::ellipse2Poly

```cpp
void cv::ellipse2Poly( cv::Point               center,
                       cv::Size                axes,
                       int                     angle,
                       int                     arcStart,
                       int                     arcEnd,
                       int                     delta,
                       std::vector<cv::Point>& pts )

AutoIt:
    _OpenCV_ObjCreate("cv").ellipse2Poly( $center, $axes, $angle, $arcStart, $arcEnd, $delta[, $pts] ) -> $pts
```

### cv::putText

```cpp
void cv::putText( _InputOutputArray  img,
                  const std::string& text,
                  cv::Point          org,
                  int                fontFace,
                  double             fontScale,
                  cv::Scalar         color,
                  int                thickness = 1,
                  int                lineType = LINE_8,
                  bool               bottomLeftOrigin = false )

AutoIt:
    _OpenCV_ObjCreate("cv").putText( $img, $text, $org, $fontFace, $fontScale, $color[, $thickness[, $lineType[, $bottomLeftOrigin]]] ) -> $img
```

### cv::getTextSize

```cpp
cv::Size cv::getTextSize( const std::string& text,
                          int                fontFace,
                          double             fontScale,
                          int                thickness,
                          int*               baseLine )

AutoIt:
    _OpenCV_ObjCreate("cv").getTextSize( $text, $fontFace, $fontScale, $thickness[, $baseLine] ) -> retval, $baseLine
```

### cv::getFontScaleFromHeight

```cpp
double cv::getFontScaleFromHeight( const int fontFace,
                                   const int pixelHeight,
                                   const int thickness = 1 )

AutoIt:
    _OpenCV_ObjCreate("cv").getFontScaleFromHeight( $fontFace, $pixelHeight[, $thickness] ) -> retval
```

### cv::HoughLinesWithAccumulator

```cpp
void cv::HoughLinesWithAccumulator( _InputArray  image,
                                    _OutputArray lines,
                                    double       rho,
                                    double       theta,
                                    int          threshold,
                                    double       srn = 0,
                                    double       stn = 0,
                                    double       min_theta = 0,
                                    double       max_theta = CV_PI )

AutoIt:
    _OpenCV_ObjCreate("cv").HoughLinesWithAccumulator( $image, $rho, $theta, $threshold[, $lines[, $srn[, $stn[, $min_theta[, $max_theta]]]]] ) -> $lines
```

### cv::inpaint

```cpp
void cv::inpaint( _InputArray  src,
                  _InputArray  inpaintMask,
                  _OutputArray dst,
                  double       inpaintRadius,
                  int          flags )

AutoIt:
    _OpenCV_ObjCreate("cv").inpaint( $src, $inpaintMask, $inpaintRadius, $flags[, $dst] ) -> $dst
```

### cv::fastNlMeansDenoising

```cpp
void cv::fastNlMeansDenoising( _InputArray  src,
                               _OutputArray dst,
                               float        h = 3,
                               int          templateWindowSize = 7,
                               int          searchWindowSize = 21 )

AutoIt:
    _OpenCV_ObjCreate("cv").fastNlMeansDenoising( $src[, $dst[, $h[, $templateWindowSize[, $searchWindowSize]]]] ) -> $dst
```

```cpp
void cv::fastNlMeansDenoising( _InputArray               src,
                               _OutputArray              dst,
                               const std::vector<float>& h,
                               int                       templateWindowSize = 7,
                               int                       searchWindowSize = 21,
                               int                       normType = NORM_L2 )

AutoIt:
    _OpenCV_ObjCreate("cv").fastNlMeansDenoising( $src, $h[, $dst[, $templateWindowSize[, $searchWindowSize[, $normType]]]] ) -> $dst
```

### cv::fastNlMeansDenoisingColored

```cpp
void cv::fastNlMeansDenoisingColored( _InputArray  src,
                                      _OutputArray dst,
                                      float        h = 3,
                                      float        hColor = 3,
                                      int          templateWindowSize = 7,
                                      int          searchWindowSize = 21 )

AutoIt:
    _OpenCV_ObjCreate("cv").fastNlMeansDenoisingColored( $src[, $dst[, $h[, $hColor[, $templateWindowSize[, $searchWindowSize]]]]] ) -> $dst
```

### cv::fastNlMeansDenoisingMulti

```cpp
void cv::fastNlMeansDenoisingMulti( _InputArray  srcImgs,
                                    _OutputArray dst,
                                    int          imgToDenoiseIndex,
                                    int          temporalWindowSize,
                                    float        h = 3,
                                    int          templateWindowSize = 7,
                                    int          searchWindowSize = 21 )

AutoIt:
    _OpenCV_ObjCreate("cv").fastNlMeansDenoisingMulti( $srcImgs, $imgToDenoiseIndex, $temporalWindowSize[, $dst[, $h[, $templateWindowSize[, $searchWindowSize]]]] ) -> $dst
```

```cpp
void cv::fastNlMeansDenoisingMulti( _InputArray               srcImgs,
                                    _OutputArray              dst,
                                    int                       imgToDenoiseIndex,
                                    int                       temporalWindowSize,
                                    const std::vector<float>& h,
                                    int                       templateWindowSize = 7,
                                    int                       searchWindowSize = 21,
                                    int                       normType = NORM_L2 )

AutoIt:
    _OpenCV_ObjCreate("cv").fastNlMeansDenoisingMulti( $srcImgs, $imgToDenoiseIndex, $temporalWindowSize, $h[, $dst[, $templateWindowSize[, $searchWindowSize[, $normType]]]] ) -> $dst
```

### cv::fastNlMeansDenoisingColoredMulti

```cpp
void cv::fastNlMeansDenoisingColoredMulti( _InputArray  srcImgs,
                                           _OutputArray dst,
                                           int          imgToDenoiseIndex,
                                           int          temporalWindowSize,
                                           float        h = 3,
                                           float        hColor = 3,
                                           int          templateWindowSize = 7,
                                           int          searchWindowSize = 21 )

AutoIt:
    _OpenCV_ObjCreate("cv").fastNlMeansDenoisingColoredMulti( $srcImgs, $imgToDenoiseIndex, $temporalWindowSize[, $dst[, $h[, $hColor[, $templateWindowSize[, $searchWindowSize]]]]] ) -> $dst
```

### cv::denoise_TVL1

```cpp
void cv::denoise_TVL1( const std::vector<cv::Mat>& observations,
                       cv::Mat&                    result,
                       double                      lambda = 1.0,
                       int                         niters = 30 )

AutoIt:
    _OpenCV_ObjCreate("cv").denoise_TVL1( $observations, $result[, $lambda[, $niters]] ) -> None
```

### cv::createTonemap

```cpp
cv::Ptr<cv::Tonemap> cv::createTonemap( float gamma = 1.0f )

AutoIt:
    _OpenCV_ObjCreate("cv").createTonemap( [$gamma] ) -> retval
```

### cv::createTonemapDrago

```cpp
cv::Ptr<cv::TonemapDrago> cv::createTonemapDrago( float gamma = 1.0f,
                                                  float saturation = 1.0f,
                                                  float bias = 0.85f )

AutoIt:
    _OpenCV_ObjCreate("cv").createTonemapDrago( [$gamma[, $saturation[, $bias]]] ) -> retval
```

### cv::createTonemapReinhard

```cpp
cv::Ptr<cv::TonemapReinhard> cv::createTonemapReinhard( float gamma = 1.0f,
                                                        float intensity = 0.0f,
                                                        float light_adapt = 1.0f,
                                                        float color_adapt = 0.0f )

AutoIt:
    _OpenCV_ObjCreate("cv").createTonemapReinhard( [$gamma[, $intensity[, $light_adapt[, $color_adapt]]]] ) -> retval
```

### cv::createTonemapMantiuk

```cpp
cv::Ptr<cv::TonemapMantiuk> cv::createTonemapMantiuk( float gamma = 1.0f,
                                                      float scale = 0.7f,
                                                      float saturation = 1.0f )

AutoIt:
    _OpenCV_ObjCreate("cv").createTonemapMantiuk( [$gamma[, $scale[, $saturation]]] ) -> retval
```

### cv::createAlignMTB

```cpp
cv::Ptr<cv::AlignMTB> cv::createAlignMTB( int  max_bits = 6,
                                          int  exclude_range = 4,
                                          bool cut = true )

AutoIt:
    _OpenCV_ObjCreate("cv").createAlignMTB( [$max_bits[, $exclude_range[, $cut]]] ) -> retval
```

### cv::createCalibrateDebevec

```cpp
cv::Ptr<cv::CalibrateDebevec> cv::createCalibrateDebevec( int   samples = 70,
                                                          float lambda = 10.0f,
                                                          bool  random = false )

AutoIt:
    _OpenCV_ObjCreate("cv").createCalibrateDebevec( [$samples[, $lambda[, $random]]] ) -> retval
```

### cv::createCalibrateRobertson

```cpp
cv::Ptr<cv::CalibrateRobertson> cv::createCalibrateRobertson( int   max_iter = 30,
                                                              float threshold = 0.01f )

AutoIt:
    _OpenCV_ObjCreate("cv").createCalibrateRobertson( [$max_iter[, $threshold]] ) -> retval
```

### cv::createMergeDebevec

```cpp
cv::Ptr<cv::MergeDebevec> cv::createMergeDebevec()

AutoIt:
    _OpenCV_ObjCreate("cv").createMergeDebevec() -> retval
```

### cv::createMergeMertens

```cpp
cv::Ptr<cv::MergeMertens> cv::createMergeMertens( float contrast_weight = 1.0f,
                                                  float saturation_weight = 1.0f,
                                                  float exposure_weight = 0.0f )

AutoIt:
    _OpenCV_ObjCreate("cv").createMergeMertens( [$contrast_weight[, $saturation_weight[, $exposure_weight]]] ) -> retval
```

### cv::createMergeRobertson

```cpp
cv::Ptr<cv::MergeRobertson> cv::createMergeRobertson()

AutoIt:
    _OpenCV_ObjCreate("cv").createMergeRobertson() -> retval
```

### cv::decolor

```cpp
void cv::decolor( _InputArray  src,
                  _OutputArray grayscale,
                  _OutputArray color_boost )

AutoIt:
    _OpenCV_ObjCreate("cv").decolor( $src[, $grayscale[, $color_boost]] ) -> $grayscale, $color_boost
```

### cv::seamlessClone

```cpp
void cv::seamlessClone( _InputArray  src,
                        _InputArray  dst,
                        _InputArray  mask,
                        cv::Point    p,
                        _OutputArray blend,
                        int          flags )

AutoIt:
    _OpenCV_ObjCreate("cv").seamlessClone( $src, $dst, $mask, $p, $flags[, $blend] ) -> $blend
```

### cv::colorChange

```cpp
void cv::colorChange( _InputArray  src,
                      _InputArray  mask,
                      _OutputArray dst,
                      float        red_mul = 1.0f,
                      float        green_mul = 1.0f,
                      float        blue_mul = 1.0f )

AutoIt:
    _OpenCV_ObjCreate("cv").colorChange( $src, $mask[, $dst[, $red_mul[, $green_mul[, $blue_mul]]]] ) -> $dst
```

### cv::illuminationChange

```cpp
void cv::illuminationChange( _InputArray  src,
                             _InputArray  mask,
                             _OutputArray dst,
                             float        alpha = 0.2f,
                             float        beta = 0.4f )

AutoIt:
    _OpenCV_ObjCreate("cv").illuminationChange( $src, $mask[, $dst[, $alpha[, $beta]]] ) -> $dst
```

### cv::textureFlattening

```cpp
void cv::textureFlattening( _InputArray  src,
                            _InputArray  mask,
                            _OutputArray dst,
                            float        low_threshold = 30,
                            float        high_threshold = 45,
                            int          kernel_size = 3 )

AutoIt:
    _OpenCV_ObjCreate("cv").textureFlattening( $src, $mask[, $dst[, $low_threshold[, $high_threshold[, $kernel_size]]]] ) -> $dst
```

### cv::edgePreservingFilter

```cpp
void cv::edgePreservingFilter( _InputArray  src,
                               _OutputArray dst,
                               int          flags = 1,
                               float        sigma_s = 60,
                               float        sigma_r = 0.4f )

AutoIt:
    _OpenCV_ObjCreate("cv").edgePreservingFilter( $src[, $dst[, $flags[, $sigma_s[, $sigma_r]]]] ) -> $dst
```

### cv::detailEnhance

```cpp
void cv::detailEnhance( _InputArray  src,
                        _OutputArray dst,
                        float        sigma_s = 10,
                        float        sigma_r = 0.15f )

AutoIt:
    _OpenCV_ObjCreate("cv").detailEnhance( $src[, $dst[, $sigma_s[, $sigma_r]]] ) -> $dst
```

### cv::pencilSketch

```cpp
void cv::pencilSketch( _InputArray  src,
                       _OutputArray dst1,
                       _OutputArray dst2,
                       float        sigma_s = 60,
                       float        sigma_r = 0.07f,
                       float        shade_factor = 0.02f )

AutoIt:
    _OpenCV_ObjCreate("cv").pencilSketch( $src[, $dst1[, $dst2[, $sigma_s[, $sigma_r[, $shade_factor]]]]] ) -> $dst1, $dst2
```

### cv::stylization

```cpp
void cv::stylization( _InputArray  src,
                      _OutputArray dst,
                      float        sigma_s = 60,
                      float        sigma_r = 0.45f )

AutoIt:
    _OpenCV_ObjCreate("cv").stylization( $src[, $dst[, $sigma_s[, $sigma_r]]] ) -> $dst
```

### cv::drawKeypoints

```cpp
void cv::drawKeypoints( _InputArray                      image,
                        const std::vector<cv::KeyPoint>& keypoints,
                        _InputOutputArray                outImage,
                        const cv::Scalar&                color = Scalar::all(-1),
                        int                              flags = DrawMatchesFlags::DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").drawKeypoints( $image, $keypoints, $outImage[, $color[, $flags]] ) -> $outImage
```

### cv::drawMatches

```cpp
void cv::drawMatches( _InputArray                      img1,
                      const std::vector<cv::KeyPoint>& keypoints1,
                      _InputArray                      img2,
                      const std::vector<cv::KeyPoint>& keypoints2,
                      const std::vector<cv::DMatch>&   matches1to2,
                      _InputOutputArray                outImg,
                      const cv::Scalar&                matchColor = Scalar::all(-1),
                      const cv::Scalar&                singlePointColor = Scalar::all(-1),
                      const std::vector<char>&         matchesMask = std::vector<char>(),
                      int                              flags = DrawMatchesFlags::DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").drawMatches( $img1, $keypoints1, $img2, $keypoints2, $matches1to2, $outImg[, $matchColor[, $singlePointColor[, $matchesMask[, $flags]]]] ) -> $outImg
```

```cpp
void cv::drawMatches( _InputArray                      img1,
                      const std::vector<cv::KeyPoint>& keypoints1,
                      _InputArray                      img2,
                      const std::vector<cv::KeyPoint>& keypoints2,
                      const std::vector<cv::DMatch>&   matches1to2,
                      _InputOutputArray                outImg,
                      const int                        matchesThickness,
                      const cv::Scalar&                matchColor = Scalar::all(-1),
                      const cv::Scalar&                singlePointColor = Scalar::all(-1),
                      const std::vector<char>&         matchesMask = std::vector<char>(),
                      int                              flags = DrawMatchesFlags::DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").drawMatches( $img1, $keypoints1, $img2, $keypoints2, $matches1to2, $outImg, $matchesThickness[, $matchColor[, $singlePointColor[, $matchesMask[, $flags]]]] ) -> $outImg
```

### cv::drawMatchesKnn

```cpp
void cv::drawMatchesKnn( _InputArray                                 img1,
                         const std::vector<cv::KeyPoint>&            keypoints1,
                         _InputArray                                 img2,
                         const std::vector<cv::KeyPoint>&            keypoints2,
                         const std::vector<std::vector<cv::DMatch>>& matches1to2,
                         _InputOutputArray                           outImg,
                         const cv::Scalar&                           matchColor = Scalar::all(-1),
                         const cv::Scalar&                           singlePointColor = Scalar::all(-1),
                         const std::vector<std::vector<char>>&       matchesMask = std::vector<std::vector<char> >(),
                         int                                         flags = DrawMatchesFlags::DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv").drawMatchesKnn( $img1, $keypoints1, $img2, $keypoints2, $matches1to2, $outImg[, $matchColor[, $singlePointColor[, $matchesMask[, $flags]]]] ) -> $outImg
```

### cv::imread

```cpp
cv::Mat cv::imread( const std::string& filename,
                    int                flags = IMREAD_COLOR )

AutoIt:
    _OpenCV_ObjCreate("cv").imread( $filename[, $flags] ) -> retval
```

### cv::imreadmulti

```cpp
bool cv::imreadmulti( const std::string&    filename,
                      std::vector<cv::Mat>& mats,
                      int                   flags = IMREAD_ANYCOLOR )

AutoIt:
    _OpenCV_ObjCreate("cv").imreadmulti( $filename[, $flags[, $mats]] ) -> retval, $mats
```

```cpp
bool cv::imreadmulti( const std::string&    filename,
                      std::vector<cv::Mat>& mats,
                      int                   start,
                      int                   count,
                      int                   flags = IMREAD_ANYCOLOR )

AutoIt:
    _OpenCV_ObjCreate("cv").imreadmulti( $filename, $start, $count[, $flags[, $mats]] ) -> retval, $mats
```

### cv::imcount

```cpp
size_t cv::imcount( const std::string& filename,
                    int                flags = IMREAD_ANYCOLOR )

AutoIt:
    _OpenCV_ObjCreate("cv").imcount( $filename[, $flags] ) -> retval
```

### cv::imwrite

```cpp
bool cv::imwrite( const std::string&      filename,
                  _InputArray             img,
                  const std::vector<int>& params = std::vector<int>() )

AutoIt:
    _OpenCV_ObjCreate("cv").imwrite( $filename, $img[, $params] ) -> retval
```

### cv::imwritemulti

```cpp
bool cv::imwritemulti( const std::string&      filename,
                       _InputArray             img,
                       const std::vector<int>& params = std::vector<int>() )

AutoIt:
    _OpenCV_ObjCreate("cv").imwritemulti( $filename, $img[, $params] ) -> retval
```

### cv::imdecode

```cpp
cv::Mat cv::imdecode( _InputArray buf,
                      int         flags )

AutoIt:
    _OpenCV_ObjCreate("cv").imdecode( $buf, $flags ) -> retval
```

### cv::imencode

```cpp
bool cv::imencode( const std::string&      ext,
                   _InputArray             img,
                   std::vector<uchar>&     buf,
                   const std::vector<int>& params = std::vector<int>() )

AutoIt:
    _OpenCV_ObjCreate("cv").imencode( $ext, $img[, $params[, $buf]] ) -> retval, $buf
```

### cv::haveImageReader

```cpp
bool cv::haveImageReader( const std::string& filename )

AutoIt:
    _OpenCV_ObjCreate("cv").haveImageReader( $filename ) -> retval
```

### cv::haveImageWriter

```cpp
bool cv::haveImageWriter( const std::string& filename )

AutoIt:
    _OpenCV_ObjCreate("cv").haveImageWriter( $filename ) -> retval
```

### cv::Rodrigues

```cpp
void cv::Rodrigues( _InputArray  src,
                    _OutputArray dst,
                    _OutputArray jacobian = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").Rodrigues( $src[, $dst[, $jacobian]] ) -> $dst, $jacobian
```

### cv::findHomography

```cpp
cv::Mat cv::findHomography( _InputArray  srcPoints,
                            _InputArray  dstPoints,
                            int          method = 0,
                            double       ransacReprojThreshold = 3,
                            _OutputArray mask = noArray(),
                            const int    maxIters = 2000,
                            const double confidence = 0.995 )

AutoIt:
    _OpenCV_ObjCreate("cv").findHomography( $srcPoints, $dstPoints[, $method[, $ransacReprojThreshold[, $mask[, $maxIters[, $confidence]]]]] ) -> retval, $mask
```

```cpp
cv::Mat cv::findHomography( _InputArray           srcPoints,
                            _InputArray           dstPoints,
                            _OutputArray          mask,
                            const cv::UsacParams& params )

AutoIt:
    _OpenCV_ObjCreate("cv").findHomography( $srcPoints, $dstPoints, $params[, $mask] ) -> retval, $mask
```

### cv::RQDecomp3x3

```cpp
cv::Vec3d cv::RQDecomp3x3( _InputArray  src,
                           _OutputArray mtxR,
                           _OutputArray mtxQ,
                           _OutputArray Qx = noArray(),
                           _OutputArray Qy = noArray(),
                           _OutputArray Qz = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").RQDecomp3x3( $src[, $mtxR[, $mtxQ[, $Qx[, $Qy[, $Qz]]]]] ) -> retval, $mtxR, $mtxQ, $Qx, $Qy, $Qz
```

### cv::decomposeProjectionMatrix

```cpp
void cv::decomposeProjectionMatrix( _InputArray  projMatrix,
                                    _OutputArray cameraMatrix,
                                    _OutputArray rotMatrix,
                                    _OutputArray transVect,
                                    _OutputArray rotMatrixX = noArray(),
                                    _OutputArray rotMatrixY = noArray(),
                                    _OutputArray rotMatrixZ = noArray(),
                                    _OutputArray eulerAngles = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").decomposeProjectionMatrix( $projMatrix[, $cameraMatrix[, $rotMatrix[, $transVect[, $rotMatrixX[, $rotMatrixY[, $rotMatrixZ[, $eulerAngles]]]]]]] ) -> $cameraMatrix, $rotMatrix, $transVect, $rotMatrixX, $rotMatrixY, $rotMatrixZ, $eulerAngles
```

### cv::matMulDeriv

```cpp
void cv::matMulDeriv( _InputArray  A,
                      _InputArray  B,
                      _OutputArray dABdA,
                      _OutputArray dABdB )

AutoIt:
    _OpenCV_ObjCreate("cv").matMulDeriv( $A, $B[, $dABdA[, $dABdB]] ) -> $dABdA, $dABdB
```

### cv::composeRT

```cpp
void cv::composeRT( _InputArray  rvec1,
                    _InputArray  tvec1,
                    _InputArray  rvec2,
                    _InputArray  tvec2,
                    _OutputArray rvec3,
                    _OutputArray tvec3,
                    _OutputArray dr3dr1 = noArray(),
                    _OutputArray dr3dt1 = noArray(),
                    _OutputArray dr3dr2 = noArray(),
                    _OutputArray dr3dt2 = noArray(),
                    _OutputArray dt3dr1 = noArray(),
                    _OutputArray dt3dt1 = noArray(),
                    _OutputArray dt3dr2 = noArray(),
                    _OutputArray dt3dt2 = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").composeRT( $rvec1, $tvec1, $rvec2, $tvec2[, $rvec3[, $tvec3[, $dr3dr1[, $dr3dt1[, $dr3dr2[, $dr3dt2[, $dt3dr1[, $dt3dt1[, $dt3dr2[, $dt3dt2]]]]]]]]]] ) -> $rvec3, $tvec3, $dr3dr1, $dr3dt1, $dr3dr2, $dr3dt2, $dt3dr1, $dt3dt1, $dt3dr2, $dt3dt2
```

### cv::projectPoints

```cpp
void cv::projectPoints( _InputArray  objectPoints,
                        _InputArray  rvec,
                        _InputArray  tvec,
                        _InputArray  cameraMatrix,
                        _InputArray  distCoeffs,
                        _OutputArray imagePoints,
                        _OutputArray jacobian = noArray(),
                        double       aspectRatio = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").projectPoints( $objectPoints, $rvec, $tvec, $cameraMatrix, $distCoeffs[, $imagePoints[, $jacobian[, $aspectRatio]]] ) -> $imagePoints, $jacobian
```

### cv::solvePnP

```cpp
bool cv::solvePnP( _InputArray  objectPoints,
                   _InputArray  imagePoints,
                   _InputArray  cameraMatrix,
                   _InputArray  distCoeffs,
                   _OutputArray rvec,
                   _OutputArray tvec,
                   bool         useExtrinsicGuess = false,
                   int          flags = SOLVEPNP_ITERATIVE )

AutoIt:
    _OpenCV_ObjCreate("cv").solvePnP( $objectPoints, $imagePoints, $cameraMatrix, $distCoeffs[, $rvec[, $tvec[, $useExtrinsicGuess[, $flags]]]] ) -> retval, $rvec, $tvec
```

### cv::solvePnPRansac

```cpp
bool cv::solvePnPRansac( _InputArray  objectPoints,
                         _InputArray  imagePoints,
                         _InputArray  cameraMatrix,
                         _InputArray  distCoeffs,
                         _OutputArray rvec,
                         _OutputArray tvec,
                         bool         useExtrinsicGuess = false,
                         int          iterationsCount = 100,
                         float        reprojectionError = 8.0,
                         double       confidence = 0.99,
                         _OutputArray inliers = noArray(),
                         int          flags = SOLVEPNP_ITERATIVE )

AutoIt:
    _OpenCV_ObjCreate("cv").solvePnPRansac( $objectPoints, $imagePoints, $cameraMatrix, $distCoeffs[, $rvec[, $tvec[, $useExtrinsicGuess[, $iterationsCount[, $reprojectionError[, $confidence[, $inliers[, $flags]]]]]]]] ) -> retval, $rvec, $tvec, $inliers
```

```cpp
bool cv::solvePnPRansac( _InputArray           objectPoints,
                         _InputArray           imagePoints,
                         _InputOutputArray     cameraMatrix,
                         _InputArray           distCoeffs,
                         _OutputArray          rvec,
                         _OutputArray          tvec,
                         _OutputArray          inliers,
                         const cv::UsacParams& params = UsacParams() )

AutoIt:
    _OpenCV_ObjCreate("cv").solvePnPRansac( $objectPoints, $imagePoints, $cameraMatrix, $distCoeffs[, $rvec[, $tvec[, $inliers[, $params]]]] ) -> retval, $cameraMatrix, $rvec, $tvec, $inliers
```

### cv::solveP3P

```cpp
int cv::solveP3P( _InputArray  objectPoints,
                  _InputArray  imagePoints,
                  _InputArray  cameraMatrix,
                  _InputArray  distCoeffs,
                  _OutputArray rvecs,
                  _OutputArray tvecs,
                  int          flags )

AutoIt:
    _OpenCV_ObjCreate("cv").solveP3P( $objectPoints, $imagePoints, $cameraMatrix, $distCoeffs, $flags[, $rvecs[, $tvecs]] ) -> retval, $rvecs, $tvecs
```

### cv::solvePnPRefineLM

```cpp
void cv::solvePnPRefineLM( _InputArray       objectPoints,
                           _InputArray       imagePoints,
                           _InputArray       cameraMatrix,
                           _InputArray       distCoeffs,
                           _InputOutputArray rvec,
                           _InputOutputArray tvec,
                           cv::TermCriteria  criteria = TermCriteria(TermCriteria::EPS + TermCriteria::COUNT, 20, FLT_EPSILON) )

AutoIt:
    _OpenCV_ObjCreate("cv").solvePnPRefineLM( $objectPoints, $imagePoints, $cameraMatrix, $distCoeffs, $rvec, $tvec[, $criteria] ) -> $rvec, $tvec
```

### cv::solvePnPRefineVVS

```cpp
void cv::solvePnPRefineVVS( _InputArray       objectPoints,
                            _InputArray       imagePoints,
                            _InputArray       cameraMatrix,
                            _InputArray       distCoeffs,
                            _InputOutputArray rvec,
                            _InputOutputArray tvec,
                            cv::TermCriteria  criteria = TermCriteria(TermCriteria::EPS + TermCriteria::COUNT, 20, FLT_EPSILON),
                            double            VVSlambda = 1 )

AutoIt:
    _OpenCV_ObjCreate("cv").solvePnPRefineVVS( $objectPoints, $imagePoints, $cameraMatrix, $distCoeffs, $rvec, $tvec[, $criteria[, $VVSlambda]] ) -> $rvec, $tvec
```

### cv::solvePnPGeneric

```cpp
int cv::solvePnPGeneric( _InputArray  objectPoints,
                         _InputArray  imagePoints,
                         _InputArray  cameraMatrix,
                         _InputArray  distCoeffs,
                         _OutputArray rvecs,
                         _OutputArray tvecs,
                         bool         useExtrinsicGuess = false,
                         int          flags = SOLVEPNP_ITERATIVE,
                         _InputArray  rvec = noArray(),
                         _InputArray  tvec = noArray(),
                         _OutputArray reprojectionError = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").solvePnPGeneric( $objectPoints, $imagePoints, $cameraMatrix, $distCoeffs[, $rvecs[, $tvecs[, $useExtrinsicGuess[, $flags[, $rvec[, $tvec[, $reprojectionError]]]]]]] ) -> retval, $rvecs, $tvecs, $reprojectionError
```

### cv::initCameraMatrix2D

```cpp
cv::Mat cv::initCameraMatrix2D( _InputArray objectPoints,
                                _InputArray imagePoints,
                                cv::Size    imageSize,
                                double      aspectRatio = 1.0 )

AutoIt:
    _OpenCV_ObjCreate("cv").initCameraMatrix2D( $objectPoints, $imagePoints, $imageSize[, $aspectRatio] ) -> retval
```

### cv::findChessboardCorners

```cpp
bool cv::findChessboardCorners( _InputArray  image,
                                cv::Size     patternSize,
                                _OutputArray corners,
                                int          flags = CALIB_CB_ADAPTIVE_THRESH + CALIB_CB_NORMALIZE_IMAGE )

AutoIt:
    _OpenCV_ObjCreate("cv").findChessboardCorners( $image, $patternSize[, $corners[, $flags]] ) -> retval, $corners
```

### cv::checkChessboard

```cpp
bool cv::checkChessboard( _InputArray img,
                          cv::Size    size )

AutoIt:
    _OpenCV_ObjCreate("cv").checkChessboard( $img, $size ) -> retval
```

### cv::findChessboardCornersSBWithMeta

```cpp
bool cv::findChessboardCornersSBWithMeta( _InputArray  image,
                                          cv::Size     patternSize,
                                          _OutputArray corners,
                                          int          flags,
                                          _OutputArray meta )

AutoIt:
    _OpenCV_ObjCreate("cv").findChessboardCornersSBWithMeta( $image, $patternSize, $flags[, $corners[, $meta]] ) -> retval, $corners, $meta
```

### cv::findChessboardCornersSB

```cpp
bool cv::findChessboardCornersSB( _InputArray  image,
                                  cv::Size     patternSize,
                                  _OutputArray corners,
                                  int          flags = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").findChessboardCornersSB( $image, $patternSize[, $corners[, $flags]] ) -> retval, $corners
```

### cv::estimateChessboardSharpness

```cpp
cv::Scalar cv::estimateChessboardSharpness( _InputArray  image,
                                            cv::Size     patternSize,
                                            _InputArray  corners,
                                            float        rise_distance = 0.8F,
                                            bool         vertical = false,
                                            _OutputArray sharpness = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").estimateChessboardSharpness( $image, $patternSize, $corners[, $rise_distance[, $vertical[, $sharpness]]] ) -> retval, $sharpness
```

### cv::find4QuadCornerSubpix

```cpp
bool cv::find4QuadCornerSubpix( _InputArray       img,
                                _InputOutputArray corners,
                                cv::Size          region_size )

AutoIt:
    _OpenCV_ObjCreate("cv").find4QuadCornerSubpix( $img, $corners, $region_size ) -> retval, $corners
```

### cv::drawChessboardCorners

```cpp
void cv::drawChessboardCorners( _InputOutputArray image,
                                cv::Size          patternSize,
                                _InputArray       corners,
                                bool              patternWasFound )

AutoIt:
    _OpenCV_ObjCreate("cv").drawChessboardCorners( $image, $patternSize, $corners, $patternWasFound ) -> $image
```

### cv::drawFrameAxes

```cpp
void cv::drawFrameAxes( _InputOutputArray image,
                        _InputArray       cameraMatrix,
                        _InputArray       distCoeffs,
                        _InputArray       rvec,
                        _InputArray       tvec,
                        float             length,
                        int               thickness = 3 )

AutoIt:
    _OpenCV_ObjCreate("cv").drawFrameAxes( $image, $cameraMatrix, $distCoeffs, $rvec, $tvec, $length[, $thickness] ) -> $image
```

### cv::findCirclesGrid

```cpp
bool cv::findCirclesGrid( _InputArray                            image,
                          cv::Size                               patternSize,
                          _OutputArray                           centers,
                          int                                    flags,
                          const cv::Ptr<cv::Feature2D>&          blobDetector,
                          const cv::CirclesGridFinderParameters& parameters )

AutoIt:
    _OpenCV_ObjCreate("cv").findCirclesGrid( $image, $patternSize, $flags, $blobDetector, $parameters[, $centers] ) -> retval, $centers
```

```cpp
bool cv::findCirclesGrid( _InputArray                   image,
                          cv::Size                      patternSize,
                          _OutputArray                  centers,
                          int                           flags = CALIB_CB_SYMMETRIC_GRID,
                          const cv::Ptr<cv::Feature2D>& blobDetector = SimpleBlobDetector::create() )

AutoIt:
    _OpenCV_ObjCreate("cv").findCirclesGrid( $image, $patternSize[, $centers[, $flags[, $blobDetector]]] ) -> retval, $centers
```

### cv::calibrateCameraExtended

```cpp
double cv::calibrateCameraExtended( _InputArray       objectPoints,
                                    _InputArray       imagePoints,
                                    cv::Size          imageSize,
                                    _InputOutputArray cameraMatrix,
                                    _InputOutputArray distCoeffs,
                                    _OutputArray      rvecs,
                                    _OutputArray      tvecs,
                                    _OutputArray      stdDeviationsIntrinsics,
                                    _OutputArray      stdDeviationsExtrinsics,
                                    _OutputArray      perViewErrors,
                                    int               flags = 0,
                                    cv::TermCriteria  criteria = TermCriteria( TermCriteria::COUNT + TermCriteria::EPS, 30, DBL_EPSILON) )

AutoIt:
    _OpenCV_ObjCreate("cv").calibrateCameraExtended( $objectPoints, $imagePoints, $imageSize, $cameraMatrix, $distCoeffs[, $rvecs[, $tvecs[, $stdDeviationsIntrinsics[, $stdDeviationsExtrinsics[, $perViewErrors[, $flags[, $criteria]]]]]]] ) -> retval, $cameraMatrix, $distCoeffs, $rvecs, $tvecs, $stdDeviationsIntrinsics, $stdDeviationsExtrinsics, $perViewErrors
```

### cv::calibrateCamera

```cpp
double cv::calibrateCamera( _InputArray       objectPoints,
                            _InputArray       imagePoints,
                            cv::Size          imageSize,
                            _InputOutputArray cameraMatrix,
                            _InputOutputArray distCoeffs,
                            _OutputArray      rvecs,
                            _OutputArray      tvecs,
                            int               flags = 0,
                            cv::TermCriteria  criteria = TermCriteria( TermCriteria::COUNT + TermCriteria::EPS, 30, DBL_EPSILON) )

AutoIt:
    _OpenCV_ObjCreate("cv").calibrateCamera( $objectPoints, $imagePoints, $imageSize, $cameraMatrix, $distCoeffs[, $rvecs[, $tvecs[, $flags[, $criteria]]]] ) -> retval, $cameraMatrix, $distCoeffs, $rvecs, $tvecs
```

### cv::calibrateCameraROExtended

```cpp
double cv::calibrateCameraROExtended( _InputArray       objectPoints,
                                      _InputArray       imagePoints,
                                      cv::Size          imageSize,
                                      int               iFixedPoint,
                                      _InputOutputArray cameraMatrix,
                                      _InputOutputArray distCoeffs,
                                      _OutputArray      rvecs,
                                      _OutputArray      tvecs,
                                      _OutputArray      newObjPoints,
                                      _OutputArray      stdDeviationsIntrinsics,
                                      _OutputArray      stdDeviationsExtrinsics,
                                      _OutputArray      stdDeviationsObjPoints,
                                      _OutputArray      perViewErrors,
                                      int               flags = 0,
                                      cv::TermCriteria  criteria = TermCriteria( TermCriteria::COUNT + TermCriteria::EPS, 30, DBL_EPSILON) )

AutoIt:
    _OpenCV_ObjCreate("cv").calibrateCameraROExtended( $objectPoints, $imagePoints, $imageSize, $iFixedPoint, $cameraMatrix, $distCoeffs[, $rvecs[, $tvecs[, $newObjPoints[, $stdDeviationsIntrinsics[, $stdDeviationsExtrinsics[, $stdDeviationsObjPoints[, $perViewErrors[, $flags[, $criteria]]]]]]]]] ) -> retval, $cameraMatrix, $distCoeffs, $rvecs, $tvecs, $newObjPoints, $stdDeviationsIntrinsics, $stdDeviationsExtrinsics, $stdDeviationsObjPoints, $perViewErrors
```

### cv::calibrateCameraRO

```cpp
double cv::calibrateCameraRO( _InputArray       objectPoints,
                              _InputArray       imagePoints,
                              cv::Size          imageSize,
                              int               iFixedPoint,
                              _InputOutputArray cameraMatrix,
                              _InputOutputArray distCoeffs,
                              _OutputArray      rvecs,
                              _OutputArray      tvecs,
                              _OutputArray      newObjPoints,
                              int               flags = 0,
                              cv::TermCriteria  criteria = TermCriteria( TermCriteria::COUNT + TermCriteria::EPS, 30, DBL_EPSILON) )

AutoIt:
    _OpenCV_ObjCreate("cv").calibrateCameraRO( $objectPoints, $imagePoints, $imageSize, $iFixedPoint, $cameraMatrix, $distCoeffs[, $rvecs[, $tvecs[, $newObjPoints[, $flags[, $criteria]]]]] ) -> retval, $cameraMatrix, $distCoeffs, $rvecs, $tvecs, $newObjPoints
```

### cv::calibrationMatrixValues

```cpp
void cv::calibrationMatrixValues( _InputArray  cameraMatrix,
                                  cv::Size     imageSize,
                                  double       apertureWidth,
                                  double       apertureHeight,
                                  double&      fovx,
                                  double&      fovy,
                                  double&      focalLength,
                                  cv::Point2d& principalPoint,
                                  double&      aspectRatio )

AutoIt:
    _OpenCV_ObjCreate("cv").calibrationMatrixValues( $cameraMatrix, $imageSize, $apertureWidth, $apertureHeight[, $fovx[, $fovy[, $focalLength[, $principalPoint[, $aspectRatio]]]]] ) -> $fovx, $fovy, $focalLength, $principalPoint, $aspectRatio
```

### cv::stereoCalibrateExtended

```cpp
double cv::stereoCalibrateExtended( _InputArray       objectPoints,
                                    _InputArray       imagePoints1,
                                    _InputArray       imagePoints2,
                                    _InputOutputArray cameraMatrix1,
                                    _InputOutputArray distCoeffs1,
                                    _InputOutputArray cameraMatrix2,
                                    _InputOutputArray distCoeffs2,
                                    cv::Size          imageSize,
                                    _InputOutputArray R,
                                    _InputOutputArray T,
                                    _OutputArray      E,
                                    _OutputArray      F,
                                    _OutputArray      perViewErrors,
                                    int               flags = CALIB_FIX_INTRINSIC,
                                    cv::TermCriteria  criteria = TermCriteria(TermCriteria::COUNT+TermCriteria::EPS, 30, 1e-6) )

AutoIt:
    _OpenCV_ObjCreate("cv").stereoCalibrateExtended( $objectPoints, $imagePoints1, $imagePoints2, $cameraMatrix1, $distCoeffs1, $cameraMatrix2, $distCoeffs2, $imageSize, $R, $T[, $E[, $F[, $perViewErrors[, $flags[, $criteria]]]]] ) -> retval, $cameraMatrix1, $distCoeffs1, $cameraMatrix2, $distCoeffs2, $R, $T, $E, $F, $perViewErrors
```

### cv::stereoCalibrate

```cpp
double cv::stereoCalibrate( _InputArray       objectPoints,
                            _InputArray       imagePoints1,
                            _InputArray       imagePoints2,
                            _InputOutputArray cameraMatrix1,
                            _InputOutputArray distCoeffs1,
                            _InputOutputArray cameraMatrix2,
                            _InputOutputArray distCoeffs2,
                            cv::Size          imageSize,
                            _OutputArray      R,
                            _OutputArray      T,
                            _OutputArray      E,
                            _OutputArray      F,
                            int               flags = CALIB_FIX_INTRINSIC,
                            cv::TermCriteria  criteria = TermCriteria(TermCriteria::COUNT+TermCriteria::EPS, 30, 1e-6) )

AutoIt:
    _OpenCV_ObjCreate("cv").stereoCalibrate( $objectPoints, $imagePoints1, $imagePoints2, $cameraMatrix1, $distCoeffs1, $cameraMatrix2, $distCoeffs2, $imageSize[, $R[, $T[, $E[, $F[, $flags[, $criteria]]]]]] ) -> retval, $cameraMatrix1, $distCoeffs1, $cameraMatrix2, $distCoeffs2, $R, $T, $E, $F
```

### cv::stereoRectify

```cpp
void cv::stereoRectify( _InputArray  cameraMatrix1,
                        _InputArray  distCoeffs1,
                        _InputArray  cameraMatrix2,
                        _InputArray  distCoeffs2,
                        cv::Size     imageSize,
                        _InputArray  R,
                        _InputArray  T,
                        _OutputArray R1,
                        _OutputArray R2,
                        _OutputArray P1,
                        _OutputArray P2,
                        _OutputArray Q,
                        int          flags = CALIB_ZERO_DISPARITY,
                        double       alpha = -1,
                        cv::Size     newImageSize = Size(),
                        cv::Rect*    validPixROI1 = 0,
                        cv::Rect*    validPixROI2 = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").stereoRectify( $cameraMatrix1, $distCoeffs1, $cameraMatrix2, $distCoeffs2, $imageSize, $R, $T[, $R1[, $R2[, $P1[, $P2[, $Q[, $flags[, $alpha[, $newImageSize[, $validPixROI1[, $validPixROI2]]]]]]]]]] ) -> $R1, $R2, $P1, $P2, $Q, $validPixROI1, $validPixROI2
```

### cv::stereoRectifyUncalibrated

```cpp
bool cv::stereoRectifyUncalibrated( _InputArray  points1,
                                    _InputArray  points2,
                                    _InputArray  F,
                                    cv::Size     imgSize,
                                    _OutputArray H1,
                                    _OutputArray H2,
                                    double       threshold = 5 )

AutoIt:
    _OpenCV_ObjCreate("cv").stereoRectifyUncalibrated( $points1, $points2, $F, $imgSize[, $H1[, $H2[, $threshold]]] ) -> retval, $H1, $H2
```

### cv::rectify3Collinear

```cpp
float cv::rectify3Collinear( _InputArray  cameraMatrix1,
                             _InputArray  distCoeffs1,
                             _InputArray  cameraMatrix2,
                             _InputArray  distCoeffs2,
                             _InputArray  cameraMatrix3,
                             _InputArray  distCoeffs3,
                             _InputArray  imgpt1,
                             _InputArray  imgpt3,
                             cv::Size     imageSize,
                             _InputArray  R12,
                             _InputArray  T12,
                             _InputArray  R13,
                             _InputArray  T13,
                             _OutputArray R1,
                             _OutputArray R2,
                             _OutputArray R3,
                             _OutputArray P1,
                             _OutputArray P2,
                             _OutputArray P3,
                             _OutputArray Q,
                             double       alpha,
                             cv::Size     newImgSize,
                             cv::Rect*    roi1,
                             cv::Rect*    roi2,
                             int          flags )

AutoIt:
    _OpenCV_ObjCreate("cv").rectify3Collinear( $cameraMatrix1, $distCoeffs1, $cameraMatrix2, $distCoeffs2, $cameraMatrix3, $distCoeffs3, $imgpt1, $imgpt3, $imageSize, $R12, $T12, $R13, $T13, $alpha, $newImgSize, $flags[, $R1[, $R2[, $R3[, $P1[, $P2[, $P3[, $Q[, $roi1[, $roi2]]]]]]]]] ) -> retval, $R1, $R2, $R3, $P1, $P2, $P3, $Q, $roi1, $roi2
```

### cv::getOptimalNewCameraMatrix

```cpp
cv::Mat cv::getOptimalNewCameraMatrix( _InputArray cameraMatrix,
                                       _InputArray distCoeffs,
                                       cv::Size    imageSize,
                                       double      alpha,
                                       cv::Size    newImgSize = Size(),
                                       cv::Rect*   validPixROI = 0,
                                       bool        centerPrincipalPoint = false )

AutoIt:
    _OpenCV_ObjCreate("cv").getOptimalNewCameraMatrix( $cameraMatrix, $distCoeffs, $imageSize, $alpha[, $newImgSize[, $centerPrincipalPoint[, $validPixROI]]] ) -> retval, $validPixROI
```

### cv::calibrateHandEye

```cpp
void cv::calibrateHandEye( _InputArray  R_gripper2base,
                           _InputArray  t_gripper2base,
                           _InputArray  R_target2cam,
                           _InputArray  t_target2cam,
                           _OutputArray R_cam2gripper,
                           _OutputArray t_cam2gripper,
                           int          method = CALIB_HAND_EYE_TSAI )

AutoIt:
    _OpenCV_ObjCreate("cv").calibrateHandEye( $R_gripper2base, $t_gripper2base, $R_target2cam, $t_target2cam[, $R_cam2gripper[, $t_cam2gripper[, $method]]] ) -> $R_cam2gripper, $t_cam2gripper
```

### cv::calibrateRobotWorldHandEye

```cpp
void cv::calibrateRobotWorldHandEye( _InputArray  R_world2cam,
                                     _InputArray  t_world2cam,
                                     _InputArray  R_base2gripper,
                                     _InputArray  t_base2gripper,
                                     _OutputArray R_base2world,
                                     _OutputArray t_base2world,
                                     _OutputArray R_gripper2cam,
                                     _OutputArray t_gripper2cam,
                                     int          method = CALIB_ROBOT_WORLD_HAND_EYE_SHAH )

AutoIt:
    _OpenCV_ObjCreate("cv").calibrateRobotWorldHandEye( $R_world2cam, $t_world2cam, $R_base2gripper, $t_base2gripper[, $R_base2world[, $t_base2world[, $R_gripper2cam[, $t_gripper2cam[, $method]]]]] ) -> $R_base2world, $t_base2world, $R_gripper2cam, $t_gripper2cam
```

### cv::convertPointsToHomogeneous

```cpp
void cv::convertPointsToHomogeneous( _InputArray  src,
                                     _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").convertPointsToHomogeneous( $src[, $dst] ) -> $dst
```

### cv::convertPointsFromHomogeneous

```cpp
void cv::convertPointsFromHomogeneous( _InputArray  src,
                                       _OutputArray dst )

AutoIt:
    _OpenCV_ObjCreate("cv").convertPointsFromHomogeneous( $src[, $dst] ) -> $dst
```

### cv::findFundamentalMat

```cpp
cv::Mat cv::findFundamentalMat( _InputArray  points1,
                                _InputArray  points2,
                                int          method,
                                double       ransacReprojThreshold,
                                double       confidence,
                                int          maxIters,
                                _OutputArray mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").findFundamentalMat( $points1, $points2, $method, $ransacReprojThreshold, $confidence, $maxIters[, $mask] ) -> retval, $mask
```

```cpp
cv::Mat cv::findFundamentalMat( _InputArray  points1,
                                _InputArray  points2,
                                int          method = FM_RANSAC,
                                double       ransacReprojThreshold = 3.,
                                double       confidence = 0.99,
                                _OutputArray mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").findFundamentalMat( $points1, $points2[, $method[, $ransacReprojThreshold[, $confidence[, $mask]]]] ) -> retval, $mask
```

```cpp
cv::Mat cv::findFundamentalMat( _InputArray           points1,
                                _InputArray           points2,
                                _OutputArray          mask,
                                const cv::UsacParams& params )

AutoIt:
    _OpenCV_ObjCreate("cv").findFundamentalMat( $points1, $points2, $params[, $mask] ) -> retval, $mask
```

### cv::findEssentialMat

```cpp
cv::Mat cv::findEssentialMat( _InputArray  points1,
                              _InputArray  points2,
                              _InputArray  cameraMatrix,
                              int          method = RANSAC,
                              double       prob = 0.999,
                              double       threshold = 1.0,
                              int          maxIters = 1000,
                              _OutputArray mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").findEssentialMat( $points1, $points2, $cameraMatrix[, $method[, $prob[, $threshold[, $maxIters[, $mask]]]]] ) -> retval, $mask
```

```cpp
cv::Mat cv::findEssentialMat( _InputArray  points1,
                              _InputArray  points2,
                              double       focal = 1.0,
                              cv::Point2d  pp = Point2d(0, 0),
                              int          method = RANSAC,
                              double       prob = 0.999,
                              double       threshold = 1.0,
                              int          maxIters = 1000,
                              _OutputArray mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").findEssentialMat( $points1, $points2[, $focal[, $pp[, $method[, $prob[, $threshold[, $maxIters[, $mask]]]]]]] ) -> retval, $mask
```

```cpp
cv::Mat cv::findEssentialMat( _InputArray  points1,
                              _InputArray  points2,
                              _InputArray  cameraMatrix1,
                              _InputArray  distCoeffs1,
                              _InputArray  cameraMatrix2,
                              _InputArray  distCoeffs2,
                              int          method = RANSAC,
                              double       prob = 0.999,
                              double       threshold = 1.0,
                              _OutputArray mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").findEssentialMat( $points1, $points2, $cameraMatrix1, $distCoeffs1, $cameraMatrix2, $distCoeffs2[, $method[, $prob[, $threshold[, $mask]]]] ) -> retval, $mask
```

```cpp
cv::Mat cv::findEssentialMat( _InputArray           points1,
                              _InputArray           points2,
                              _InputArray           cameraMatrix1,
                              _InputArray           cameraMatrix2,
                              _InputArray           dist_coeff1,
                              _InputArray           dist_coeff2,
                              _OutputArray          mask,
                              const cv::UsacParams& params )

AutoIt:
    _OpenCV_ObjCreate("cv").findEssentialMat( $points1, $points2, $cameraMatrix1, $cameraMatrix2, $dist_coeff1, $dist_coeff2, $params[, $mask] ) -> retval, $mask
```

### cv::decomposeEssentialMat

```cpp
void cv::decomposeEssentialMat( _InputArray  E,
                                _OutputArray R1,
                                _OutputArray R2,
                                _OutputArray t )

AutoIt:
    _OpenCV_ObjCreate("cv").decomposeEssentialMat( $E[, $R1[, $R2[, $t]]] ) -> $R1, $R2, $t
```

### cv::recoverPose

```cpp
int cv::recoverPose( _InputArray       points1,
                     _InputArray       points2,
                     _InputArray       cameraMatrix1,
                     _InputArray       distCoeffs1,
                     _InputArray       cameraMatrix2,
                     _InputArray       distCoeffs2,
                     _OutputArray      E,
                     _OutputArray      R,
                     _OutputArray      t,
                     int               method = cv::RANSAC,
                     double            prob = 0.999,
                     double            threshold = 1.0,
                     _InputOutputArray mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").recoverPose( $points1, $points2, $cameraMatrix1, $distCoeffs1, $cameraMatrix2, $distCoeffs2[, $E[, $R[, $t[, $method[, $prob[, $threshold[, $mask]]]]]]] ) -> retval, $E, $R, $t, $mask
```

```cpp
int cv::recoverPose( _InputArray       E,
                     _InputArray       points1,
                     _InputArray       points2,
                     _InputArray       cameraMatrix,
                     _OutputArray      R,
                     _OutputArray      t,
                     _InputOutputArray mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").recoverPose( $E, $points1, $points2, $cameraMatrix[, $R[, $t[, $mask]]] ) -> retval, $R, $t, $mask
```

```cpp
int cv::recoverPose( _InputArray       E,
                     _InputArray       points1,
                     _InputArray       points2,
                     _OutputArray      R,
                     _OutputArray      t,
                     double            focal = 1.0,
                     cv::Point2d       pp = Point2d(0, 0),
                     _InputOutputArray mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").recoverPose( $E, $points1, $points2[, $R[, $t[, $focal[, $pp[, $mask]]]]] ) -> retval, $R, $t, $mask
```

```cpp
int cv::recoverPose( _InputArray       E,
                     _InputArray       points1,
                     _InputArray       points2,
                     _InputArray       cameraMatrix,
                     _OutputArray      R,
                     _OutputArray      t,
                     double            distanceThresh,
                     _InputOutputArray mask = noArray(),
                     _OutputArray      triangulatedPoints = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").recoverPose( $E, $points1, $points2, $cameraMatrix, $distanceThresh[, $R[, $t[, $mask[, $triangulatedPoints]]]] ) -> retval, $R, $t, $mask, $triangulatedPoints
```

### cv::computeCorrespondEpilines

```cpp
void cv::computeCorrespondEpilines( _InputArray  points,
                                    int          whichImage,
                                    _InputArray  F,
                                    _OutputArray lines )

AutoIt:
    _OpenCV_ObjCreate("cv").computeCorrespondEpilines( $points, $whichImage, $F[, $lines] ) -> $lines
```

### cv::triangulatePoints

```cpp
void cv::triangulatePoints( _InputArray  projMatr1,
                            _InputArray  projMatr2,
                            _InputArray  projPoints1,
                            _InputArray  projPoints2,
                            _OutputArray points4D )

AutoIt:
    _OpenCV_ObjCreate("cv").triangulatePoints( $projMatr1, $projMatr2, $projPoints1, $projPoints2[, $points4D] ) -> $points4D
```

### cv::correctMatches

```cpp
void cv::correctMatches( _InputArray  F,
                         _InputArray  points1,
                         _InputArray  points2,
                         _OutputArray newPoints1,
                         _OutputArray newPoints2 )

AutoIt:
    _OpenCV_ObjCreate("cv").correctMatches( $F, $points1, $points2[, $newPoints1[, $newPoints2]] ) -> $newPoints1, $newPoints2
```

### cv::filterSpeckles

```cpp
void cv::filterSpeckles( _InputOutputArray img,
                         double            newVal,
                         int               maxSpeckleSize,
                         double            maxDiff,
                         _InputOutputArray buf = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").filterSpeckles( $img, $newVal, $maxSpeckleSize, $maxDiff[, $buf] ) -> $img, $buf
```

### cv::getValidDisparityROI

```cpp
cv::Rect cv::getValidDisparityROI( cv::Rect roi1,
                                   cv::Rect roi2,
                                   int      minDisparity,
                                   int      numberOfDisparities,
                                   int      blockSize )

AutoIt:
    _OpenCV_ObjCreate("cv").getValidDisparityROI( $roi1, $roi2, $minDisparity, $numberOfDisparities, $blockSize ) -> retval
```

### cv::validateDisparity

```cpp
void cv::validateDisparity( _InputOutputArray disparity,
                            _InputArray       cost,
                            int               minDisparity,
                            int               numberOfDisparities,
                            int               disp12MaxDisp = 1 )

AutoIt:
    _OpenCV_ObjCreate("cv").validateDisparity( $disparity, $cost, $minDisparity, $numberOfDisparities[, $disp12MaxDisp] ) -> $disparity
```

### cv::reprojectImageTo3D

```cpp
void cv::reprojectImageTo3D( _InputArray  disparity,
                             _OutputArray _3dImage,
                             _InputArray  Q,
                             bool         handleMissingValues = false,
                             int          ddepth = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv").reprojectImageTo3D( $disparity, $Q[, $_3dImage[, $handleMissingValues[, $ddepth]]] ) -> $_3dImage
```

### cv::sampsonDistance

```cpp
double cv::sampsonDistance( _InputArray pt1,
                            _InputArray pt2,
                            _InputArray F )

AutoIt:
    _OpenCV_ObjCreate("cv").sampsonDistance( $pt1, $pt2, $F ) -> retval
```

### cv::estimateAffine3D

```cpp
int cv::estimateAffine3D( _InputArray  src,
                          _InputArray  dst,
                          _OutputArray out,
                          _OutputArray inliers,
                          double       ransacThreshold = 3,
                          double       confidence = 0.99 )

AutoIt:
    _OpenCV_ObjCreate("cv").estimateAffine3D( $src, $dst[, $out[, $inliers[, $ransacThreshold[, $confidence]]]] ) -> retval, $out, $inliers
```

```cpp
cv::Mat cv::estimateAffine3D( _InputArray src,
                              _InputArray dst,
                              double*     scale = nullptr,
                              bool        force_rotation = true )

AutoIt:
    _OpenCV_ObjCreate("cv").estimateAffine3D( $src, $dst[, $force_rotation[, $scale]] ) -> retval, $scale
```

### cv::estimateTranslation3D

```cpp
int cv::estimateTranslation3D( _InputArray  src,
                               _InputArray  dst,
                               _OutputArray out,
                               _OutputArray inliers,
                               double       ransacThreshold = 3,
                               double       confidence = 0.99 )

AutoIt:
    _OpenCV_ObjCreate("cv").estimateTranslation3D( $src, $dst[, $out[, $inliers[, $ransacThreshold[, $confidence]]]] ) -> retval, $out, $inliers
```

### cv::estimateAffine2D

```cpp
cv::Mat cv::estimateAffine2D( _InputArray  from,
                              _InputArray  to,
                              _OutputArray inliers = noArray(),
                              int          method = RANSAC,
                              double       ransacReprojThreshold = 3,
                              size_t       maxIters = 2000,
                              double       confidence = 0.99,
                              size_t       refineIters = 10 )

AutoIt:
    _OpenCV_ObjCreate("cv").estimateAffine2D( $from, $to[, $inliers[, $method[, $ransacReprojThreshold[, $maxIters[, $confidence[, $refineIters]]]]]] ) -> retval, $inliers
```

```cpp
cv::Mat cv::estimateAffine2D( _InputArray           pts1,
                              _InputArray           pts2,
                              _OutputArray          inliers,
                              const cv::UsacParams& params )

AutoIt:
    _OpenCV_ObjCreate("cv").estimateAffine2D( $pts1, $pts2, $params[, $inliers] ) -> retval, $inliers
```

### cv::estimateAffinePartial2D

```cpp
cv::Mat cv::estimateAffinePartial2D( _InputArray  from,
                                     _InputArray  to,
                                     _OutputArray inliers = noArray(),
                                     int          method = RANSAC,
                                     double       ransacReprojThreshold = 3,
                                     size_t       maxIters = 2000,
                                     double       confidence = 0.99,
                                     size_t       refineIters = 10 )

AutoIt:
    _OpenCV_ObjCreate("cv").estimateAffinePartial2D( $from, $to[, $inliers[, $method[, $ransacReprojThreshold[, $maxIters[, $confidence[, $refineIters]]]]]] ) -> retval, $inliers
```

### cv::decomposeHomographyMat

```cpp
int cv::decomposeHomographyMat( _InputArray  H,
                                _InputArray  K,
                                _OutputArray rotations,
                                _OutputArray translations,
                                _OutputArray normals )

AutoIt:
    _OpenCV_ObjCreate("cv").decomposeHomographyMat( $H, $K[, $rotations[, $translations[, $normals]]] ) -> retval, $rotations, $translations, $normals
```

### cv::filterHomographyDecompByVisibleRefpoints

```cpp
void cv::filterHomographyDecompByVisibleRefpoints( _InputArray  rotations,
                                                   _InputArray  normals,
                                                   _InputArray  beforePoints,
                                                   _InputArray  afterPoints,
                                                   _OutputArray possibleSolutions,
                                                   _InputArray  pointsMask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").filterHomographyDecompByVisibleRefpoints( $rotations, $normals, $beforePoints, $afterPoints[, $possibleSolutions[, $pointsMask]] ) -> $possibleSolutions
```

### cv::undistort

```cpp
void cv::undistort( _InputArray  src,
                    _OutputArray dst,
                    _InputArray  cameraMatrix,
                    _InputArray  distCoeffs,
                    _InputArray  newCameraMatrix = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").undistort( $src, $cameraMatrix, $distCoeffs[, $dst[, $newCameraMatrix]] ) -> $dst
```

### cv::initUndistortRectifyMap

```cpp
void cv::initUndistortRectifyMap( _InputArray  cameraMatrix,
                                  _InputArray  distCoeffs,
                                  _InputArray  R,
                                  _InputArray  newCameraMatrix,
                                  cv::Size     size,
                                  int          m1type,
                                  _OutputArray map1,
                                  _OutputArray map2 )

AutoIt:
    _OpenCV_ObjCreate("cv").initUndistortRectifyMap( $cameraMatrix, $distCoeffs, $R, $newCameraMatrix, $size, $m1type[, $map1[, $map2]] ) -> $map1, $map2
```

### cv::initInverseRectificationMap

```cpp
void cv::initInverseRectificationMap( _InputArray     cameraMatrix,
                                      _InputArray     distCoeffs,
                                      _InputArray     R,
                                      _InputArray     newCameraMatrix,
                                      const cv::Size& size,
                                      int             m1type,
                                      _OutputArray    map1,
                                      _OutputArray    map2 )

AutoIt:
    _OpenCV_ObjCreate("cv").initInverseRectificationMap( $cameraMatrix, $distCoeffs, $R, $newCameraMatrix, $size, $m1type[, $map1[, $map2]] ) -> $map1, $map2
```

### cv::getDefaultNewCameraMatrix

```cpp
cv::Mat cv::getDefaultNewCameraMatrix( _InputArray cameraMatrix,
                                       cv::Size    imgsize = Size(),
                                       bool        centerPrincipalPoint = false )

AutoIt:
    _OpenCV_ObjCreate("cv").getDefaultNewCameraMatrix( $cameraMatrix[, $imgsize[, $centerPrincipalPoint]] ) -> retval
```

### cv::undistortPoints

```cpp
void cv::undistortPoints( _InputArray  src,
                          _OutputArray dst,
                          _InputArray  cameraMatrix,
                          _InputArray  distCoeffs,
                          _InputArray  R = noArray(),
                          _InputArray  P = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").undistortPoints( $src, $cameraMatrix, $distCoeffs[, $dst[, $R[, $P]]] ) -> $dst
```

### cv::undistortPointsIter

```cpp
void cv::undistortPointsIter( _InputArray      src,
                              _OutputArray     dst,
                              _InputArray      cameraMatrix,
                              _InputArray      distCoeffs,
                              _InputArray      R,
                              _InputArray      P,
                              cv::TermCriteria criteria )

AutoIt:
    _OpenCV_ObjCreate("cv").undistortPointsIter( $src, $cameraMatrix, $distCoeffs, $R, $P, $criteria[, $dst] ) -> $dst
```

### cv::namedWindow

```cpp
void cv::namedWindow( const std::string& winname,
                      int                flags = WINDOW_AUTOSIZE )

AutoIt:
    _OpenCV_ObjCreate("cv").namedWindow( $winname[, $flags] ) -> None
```

### cv::destroyWindow

```cpp
void cv::destroyWindow( const std::string& winname )

AutoIt:
    _OpenCV_ObjCreate("cv").destroyWindow( $winname ) -> None
```

### cv::destroyAllWindows

```cpp
void cv::destroyAllWindows()

AutoIt:
    _OpenCV_ObjCreate("cv").destroyAllWindows() -> None
```

### cv::startWindowThread

```cpp
int cv::startWindowThread()

AutoIt:
    _OpenCV_ObjCreate("cv").startWindowThread() -> retval
```

### cv::waitKeyEx

```cpp
int cv::waitKeyEx( int delay = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").waitKeyEx( [$delay] ) -> retval
```

### cv::waitKey

```cpp
int cv::waitKey( int delay = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").waitKey( [$delay] ) -> retval
```

### cv::pollKey

```cpp
int cv::pollKey()

AutoIt:
    _OpenCV_ObjCreate("cv").pollKey() -> retval
```

### cv::imshow

```cpp
void cv::imshow( const std::string& winname,
                 _InputArray        mat )

AutoIt:
    _OpenCV_ObjCreate("cv").imshow( $winname, $mat ) -> None
```

### cv::resizeWindow

```cpp
void cv::resizeWindow( const std::string& winname,
                       int                width,
                       int                height )

AutoIt:
    _OpenCV_ObjCreate("cv").resizeWindow( $winname, $width, $height ) -> None
```

```cpp
void cv::resizeWindow( const std::string& winname,
                       const cv::Size&    size )

AutoIt:
    _OpenCV_ObjCreate("cv").resizeWindow( $winname, $size ) -> None
```

### cv::moveWindow

```cpp
void cv::moveWindow( const std::string& winname,
                     int                x,
                     int                y )

AutoIt:
    _OpenCV_ObjCreate("cv").moveWindow( $winname, $x, $y ) -> None
```

### cv::setWindowProperty

```cpp
void cv::setWindowProperty( const std::string& winname,
                            int                prop_id,
                            double             prop_value )

AutoIt:
    _OpenCV_ObjCreate("cv").setWindowProperty( $winname, $prop_id, $prop_value ) -> None
```

### cv::setWindowTitle

```cpp
void cv::setWindowTitle( const std::string& winname,
                         const std::string& title )

AutoIt:
    _OpenCV_ObjCreate("cv").setWindowTitle( $winname, $title ) -> None
```

### cv::getWindowProperty

```cpp
double cv::getWindowProperty( const std::string& winname,
                              int                prop_id )

AutoIt:
    _OpenCV_ObjCreate("cv").getWindowProperty( $winname, $prop_id ) -> retval
```

### cv::getWindowImageRect

```cpp
cv::Rect cv::getWindowImageRect( const std::string& winname )

AutoIt:
    _OpenCV_ObjCreate("cv").getWindowImageRect( $winname ) -> retval
```

### cv::selectROI

```cpp
cv::Rect cv::selectROI( const std::string& windowName,
                        _InputArray        img,
                        bool               showCrosshair = true,
                        bool               fromCenter = false )

AutoIt:
    _OpenCV_ObjCreate("cv").selectROI( $windowName, $img[, $showCrosshair[, $fromCenter]] ) -> retval
```

```cpp
cv::Rect cv::selectROI( _InputArray img,
                        bool        showCrosshair = true,
                        bool        fromCenter = false )

AutoIt:
    _OpenCV_ObjCreate("cv").selectROI( $img[, $showCrosshair[, $fromCenter]] ) -> retval
```

### cv::selectROIs

```cpp
void cv::selectROIs( const std::string&     windowName,
                     _InputArray            img,
                     std::vector<cv::Rect>& boundingBoxes,
                     bool                   showCrosshair = true,
                     bool                   fromCenter = false )

AutoIt:
    _OpenCV_ObjCreate("cv").selectROIs( $windowName, $img[, $showCrosshair[, $fromCenter[, $boundingBoxes]]] ) -> $boundingBoxes
```

### cv::getTrackbarPos

```cpp
int cv::getTrackbarPos( const std::string& trackbarname,
                        const std::string& winname )

AutoIt:
    _OpenCV_ObjCreate("cv").getTrackbarPos( $trackbarname, $winname ) -> retval
```

### cv::setTrackbarPos

```cpp
void cv::setTrackbarPos( const std::string& trackbarname,
                         const std::string& winname,
                         int                pos )

AutoIt:
    _OpenCV_ObjCreate("cv").setTrackbarPos( $trackbarname, $winname, $pos ) -> None
```

### cv::setTrackbarMax

```cpp
void cv::setTrackbarMax( const std::string& trackbarname,
                         const std::string& winname,
                         int                maxval )

AutoIt:
    _OpenCV_ObjCreate("cv").setTrackbarMax( $trackbarname, $winname, $maxval ) -> None
```

### cv::setTrackbarMin

```cpp
void cv::setTrackbarMin( const std::string& trackbarname,
                         const std::string& winname,
                         int                minval )

AutoIt:
    _OpenCV_ObjCreate("cv").setTrackbarMin( $trackbarname, $winname, $minval ) -> None
```

### cv::addText

```cpp
void cv::addText( const cv::Mat&     img,
                  const std::string& text,
                  cv::Point          org,
                  const std::string& nameFont,
                  int                pointSize = -1,
                  cv::Scalar         color = Scalar::all(0),
                  int                weight = QT_FONT_NORMAL,
                  int                style = QT_STYLE_NORMAL,
                  int                spacing = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").addText( $img, $text, $org, $nameFont[, $pointSize[, $color[, $weight[, $style[, $spacing]]]]] ) -> None
```

### cv::displayOverlay

```cpp
void cv::displayOverlay( const std::string& winname,
                         const std::string& text,
                         int                delayms = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").displayOverlay( $winname, $text[, $delayms] ) -> None
```

### cv::displayStatusBar

```cpp
void cv::displayStatusBar( const std::string& winname,
                           const std::string& text,
                           int                delayms = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv").displayStatusBar( $winname, $text[, $delayms] ) -> None
```

### cv::groupRectangles

```cpp
void cv::groupRectangles( std::vector<cv::Rect>& rectList,
                          std::vector<int>&      weights,
                          int                    groupThreshold,
                          double                 eps = 0.2 )

AutoIt:
    _OpenCV_ObjCreate("cv").groupRectangles( $rectList, $groupThreshold[, $eps[, $weights]] ) -> $rectList, $weights
```

### cv::createBackgroundSubtractorMOG2

```cpp
cv::Ptr<cv::BackgroundSubtractorMOG2> cv::createBackgroundSubtractorMOG2( int    history = 500,
                                                                          double varThreshold = 16,
                                                                          bool   detectShadows = true )

AutoIt:
    _OpenCV_ObjCreate("cv").createBackgroundSubtractorMOG2( [$history[, $varThreshold[, $detectShadows]]] ) -> retval
```

### cv::createBackgroundSubtractorKNN

```cpp
cv::Ptr<cv::BackgroundSubtractorKNN> cv::createBackgroundSubtractorKNN( int    history = 500,
                                                                        double dist2Threshold = 400.0,
                                                                        bool   detectShadows = true )

AutoIt:
    _OpenCV_ObjCreate("cv").createBackgroundSubtractorKNN( [$history[, $dist2Threshold[, $detectShadows]]] ) -> retval
```

### cv::CamShift

```cpp
cv::RotatedRect cv::CamShift( _InputArray      probImage,
                              cv::Rect&        window,
                              cv::TermCriteria criteria )

AutoIt:
    _OpenCV_ObjCreate("cv").CamShift( $probImage, $window, $criteria ) -> retval, $window
```

### cv::meanShift

```cpp
int cv::meanShift( _InputArray      probImage,
                   cv::Rect&        window,
                   cv::TermCriteria criteria )

AutoIt:
    _OpenCV_ObjCreate("cv").meanShift( $probImage, $window, $criteria ) -> retval, $window
```

### cv::buildOpticalFlowPyramid

```cpp
int cv::buildOpticalFlowPyramid( _InputArray  img,
                                 _OutputArray pyramid,
                                 cv::Size     winSize,
                                 int          maxLevel,
                                 bool         withDerivatives = true,
                                 int          pyrBorder = BORDER_REFLECT_101,
                                 int          derivBorder = BORDER_CONSTANT,
                                 bool         tryReuseInputImage = true )

AutoIt:
    _OpenCV_ObjCreate("cv").buildOpticalFlowPyramid( $img, $winSize, $maxLevel[, $pyramid[, $withDerivatives[, $pyrBorder[, $derivBorder[, $tryReuseInputImage]]]]] ) -> retval, $pyramid
```

### cv::calcOpticalFlowPyrLK

```cpp
void cv::calcOpticalFlowPyrLK( _InputArray       prevImg,
                               _InputArray       nextImg,
                               _InputArray       prevPts,
                               _InputOutputArray nextPts,
                               _OutputArray      status,
                               _OutputArray      err,
                               cv::Size          winSize = Size(21,21),
                               int               maxLevel = 3,
                               cv::TermCriteria  criteria = TermCriteria(TermCriteria::COUNT+TermCriteria::EPS, 30, 0.01),
                               int               flags = 0,
                               double            minEigThreshold = 1e-4 )

AutoIt:
    _OpenCV_ObjCreate("cv").calcOpticalFlowPyrLK( $prevImg, $nextImg, $prevPts, $nextPts[, $status[, $err[, $winSize[, $maxLevel[, $criteria[, $flags[, $minEigThreshold]]]]]]] ) -> $nextPts, $status, $err
```

### cv::calcOpticalFlowFarneback

```cpp
void cv::calcOpticalFlowFarneback( _InputArray       prev,
                                   _InputArray       next,
                                   _InputOutputArray flow,
                                   double            pyr_scale,
                                   int               levels,
                                   int               winsize,
                                   int               iterations,
                                   int               poly_n,
                                   double            poly_sigma,
                                   int               flags )

AutoIt:
    _OpenCV_ObjCreate("cv").calcOpticalFlowFarneback( $prev, $next, $flow, $pyr_scale, $levels, $winsize, $iterations, $poly_n, $poly_sigma, $flags ) -> $flow
```

### cv::computeECC

```cpp
double cv::computeECC( _InputArray templateImage,
                       _InputArray inputImage,
                       _InputArray inputMask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").computeECC( $templateImage, $inputImage[, $inputMask] ) -> retval
```

### cv::findTransformECC

```cpp
double cv::findTransformECC( _InputArray       templateImage,
                             _InputArray       inputImage,
                             _InputOutputArray warpMatrix,
                             int               motionType,
                             cv::TermCriteria  criteria,
                             _InputArray       inputMask,
                             int               gaussFiltSize )

AutoIt:
    _OpenCV_ObjCreate("cv").findTransformECC( $templateImage, $inputImage, $warpMatrix, $motionType, $criteria, $inputMask, $gaussFiltSize ) -> retval, $warpMatrix
```

```cpp
double cv::findTransformECC( _InputArray       templateImage,
                             _InputArray       inputImage,
                             _InputOutputArray warpMatrix,
                             int               motionType = MOTION_AFFINE,
                             cv::TermCriteria  criteria = TermCriteria(TermCriteria::COUNT+TermCriteria::EPS, 50, 0.001),
                             _InputArray       inputMask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").findTransformECC( $templateImage, $inputImage, $warpMatrix[, $motionType[, $criteria[, $inputMask]]] ) -> retval, $warpMatrix
```

### cv::readOpticalFlow

```cpp
cv::Mat cv::readOpticalFlow( const std::string& path )

AutoIt:
    _OpenCV_ObjCreate("cv").readOpticalFlow( $path ) -> retval
```

### cv::writeOpticalFlow

```cpp
bool cv::writeOpticalFlow( const std::string& path,
                           _InputArray        flow )

AutoIt:
    _OpenCV_ObjCreate("cv").writeOpticalFlow( $path, $flow ) -> retval
```

### cv::empty_array_desc

```cpp
cv::GArrayDesc cv::empty_array_desc()

AutoIt:
    _OpenCV_ObjCreate("cv").empty_array_desc() -> retval
```

### cv::empty_gopaque_desc

```cpp
cv::GOpaqueDesc cv::empty_gopaque_desc()

AutoIt:
    _OpenCV_ObjCreate("cv").empty_gopaque_desc() -> retval
```

### cv::empty_scalar_desc

```cpp
cv::GScalarDesc cv::empty_scalar_desc()

AutoIt:
    _OpenCV_ObjCreate("cv").empty_scalar_desc() -> retval
```

### cv::matchTemplateParallel

```cpp
void cv::matchTemplateParallel( _InputArray  image,
                                _InputArray  templ,
                                _OutputArray result,
                                int          method,
                                _InputArray  mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv").matchTemplateParallel( $image, $templ, $method[, $result[, $mask]] ) -> $result
```

### cv::searchTemplate

```cpp
void cv::searchTemplate( _InputArray             image,
                         _InputArray             templ,
                         _OutputArray            result,
                         _InputArray             mask = noArray(),
                         const std::vector<int>& channels = std::vector<int>(),
                         const std::vector<int>& ranges = std::vector<int>(),
                         const bool              parallel = false )

AutoIt:
    _OpenCV_ObjCreate("cv").searchTemplate( $image, $templ[, $result[, $mask[, $channels[, $ranges[, $parallel]]]]] ) -> $result
```

### cv::createMatFromBitmap

```cpp
cv::Mat cv::createMatFromBitmap( void* ptr,
                                 bool  copy = true )

AutoIt:
    _OpenCV_ObjCreate("cv").createMatFromBitmap( $ptr[, $copy] ) -> retval
```

### cv::variant

```cpp
_variant_t cv::variant( void* ptr )

AutoIt:
    _OpenCV_ObjCreate("cv").variant( $ptr ) -> retval
```

### cv::readMat

```cpp
void cv::readMat( cv::FileNode node,
                  cv::Mat      mat,
                  cv::Mat      default_mat = Mat() )

AutoIt:
    _OpenCV_ObjCreate("cv").readMat( $node[, $default_mat[, $mat]] ) -> $mat
```

### cv::readInt

```cpp
void cv::readInt( cv::FileNode node,
                  int          value,
                  int          default_value )

AutoIt:
    _OpenCV_ObjCreate("cv").readInt( $node, $default_value[, $value] ) -> $value
```

### cv::readFloat

```cpp
void cv::readFloat( cv::FileNode node,
                    float        value,
                    float        default_value )

AutoIt:
    _OpenCV_ObjCreate("cv").readFloat( $node, $default_value[, $value] ) -> $value
```

### cv::readDouble

```cpp
void cv::readDouble( cv::FileNode node,
                     double       value,
                     double       default_value )

AutoIt:
    _OpenCV_ObjCreate("cv").readDouble( $node, $default_value[, $value] ) -> $value
```

### cv::readString

```cpp
void cv::readString( cv::FileNode node,
                     std::string  value,
                     std::string  default_value )

AutoIt:
    _OpenCV_ObjCreate("cv").readString( $node, $default_value[, $value] ) -> $value
```

### cv::readKeyPoint

```cpp
void cv::readKeyPoint( cv::FileNode node,
                       cv::KeyPoint value,
                       cv::KeyPoint default_value )

AutoIt:
    _OpenCV_ObjCreate("cv").readKeyPoint( $node, $default_value[, $value] ) -> $value
```

### cv::readDMatch

```cpp
void cv::readDMatch( cv::FileNode node,
                     cv::DMatch   value,
                     cv::DMatch   default_value )

AutoIt:
    _OpenCV_ObjCreate("cv").readDMatch( $node, $default_value[, $value] ) -> $value
```

## cv::parallel

### cv::parallel::setParallelForBackend

```cpp
bool cv::parallel::setParallelForBackend( const std::string& backendName,
                                          bool               propagateNumThreads = true )

AutoIt:
    _OpenCV_ObjCreate("cv.parallel").setParallelForBackend( $backendName[, $propagateNumThreads] ) -> retval
```

## cv::RNG

### cv::RNG::create

```cpp
static cv::RNG cv::RNG::create()

AutoIt:
    _OpenCV_ObjCreate("cv.RNG").create() -> <cv.RNG object>
```

```cpp
static cv::RNG cv::RNG::create( uint64 state )

AutoIt:
    _OpenCV_ObjCreate("cv.RNG").create( $state ) -> <cv.RNG object>
```

### cv::RNG::next

```cpp
uint cv::RNG::next()

AutoIt:
    $oRNG.next() -> retval
```

### cv::RNG::uniform_int

```cpp
int cv::RNG::uniform_int( int a,
                          int b )

AutoIt:
    $oRNG.uniform_int( $a, $b ) -> retval
```

### cv::RNG::uniform_float

```cpp
float cv::RNG::uniform_float( float a,
                              float b )

AutoIt:
    $oRNG.uniform_float( $a, $b ) -> retval
```

### cv::RNG::uniform_double

```cpp
double cv::RNG::uniform_double( double a,
                                double b )

AutoIt:
    $oRNG.uniform_double( $a, $b ) -> retval
```

## cv::Algorithm

### cv::Algorithm::clear

```cpp
void cv::Algorithm::clear()

AutoIt:
    $oAlgorithm.clear() -> None
```

### cv::Algorithm::write

```cpp
void cv::Algorithm::write( const cv::Ptr<cv::FileStorage>& fs,
                           const std::string&              name = String() )

AutoIt:
    $oAlgorithm.write( $fs[, $name] ) -> None
```

### cv::Algorithm::read

```cpp
void cv::Algorithm::read( const cv::FileNode& fn )

AutoIt:
    $oAlgorithm.read( $fn ) -> None
```

### cv::Algorithm::empty

```cpp
bool cv::Algorithm::empty()

AutoIt:
    $oAlgorithm.empty() -> retval
```

### cv::Algorithm::save

```cpp
void cv::Algorithm::save( const std::string& filename )

AutoIt:
    $oAlgorithm.save( $filename ) -> None
```

### cv::Algorithm::getDefaultName

```cpp
std::string cv::Algorithm::getDefaultName()

AutoIt:
    $oAlgorithm.getDefaultName() -> retval
```

## cv::AsyncArray

### cv::AsyncArray::create

```cpp
static cv::AsyncArray cv::AsyncArray::create()

AutoIt:
    _OpenCV_ObjCreate("cv.AsyncArray").create() -> <cv.AsyncArray object>
```

### cv::AsyncArray::release

```cpp
void cv::AsyncArray::release()

AutoIt:
    $oAsyncArray.release() -> None
```

### cv::AsyncArray::get

```cpp
void cv::AsyncArray::get( _OutputArray dst )

AutoIt:
    $oAsyncArray.get( [$dst] ) -> $dst
```

```cpp
bool cv::AsyncArray::get( _OutputArray dst,
                          double       timeoutNs )

AutoIt:
    $oAsyncArray.get( $timeoutNs[, $dst] ) -> retval, $dst
```

### cv::AsyncArray::wait_for

```cpp
bool cv::AsyncArray::wait_for( double timeoutNs )

AutoIt:
    $oAsyncArray.wait_for( $timeoutNs ) -> retval
```

### cv::AsyncArray::valid

```cpp
bool cv::AsyncArray::valid()

AutoIt:
    $oAsyncArray.valid() -> retval
```

## cv::ipp

### cv::ipp::useIPP

```cpp
bool cv::ipp::useIPP()

AutoIt:
    _OpenCV_ObjCreate("cv.ipp").useIPP() -> retval
```

### cv::ipp::setUseIPP

```cpp
void cv::ipp::setUseIPP( bool flag )

AutoIt:
    _OpenCV_ObjCreate("cv.ipp").setUseIPP( $flag ) -> None
```

### cv::ipp::getIppVersion

```cpp
std::string cv::ipp::getIppVersion()

AutoIt:
    _OpenCV_ObjCreate("cv.ipp").getIppVersion() -> retval
```

### cv::ipp::useIPP_NotExact

```cpp
bool cv::ipp::useIPP_NotExact()

AutoIt:
    _OpenCV_ObjCreate("cv.ipp").useIPP_NotExact() -> retval
```

### cv::ipp::setUseIPP_NotExact

```cpp
void cv::ipp::setUseIPP_NotExact( bool flag )

AutoIt:
    _OpenCV_ObjCreate("cv.ipp").setUseIPP_NotExact( $flag ) -> None
```

## cv::utils

### cv::utils::dumpInputArray

```cpp
std::string cv::utils::dumpInputArray( _InputArray argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpInputArray( $argument ) -> retval
```

### cv::utils::dumpInputArrayOfArrays

```cpp
std::string cv::utils::dumpInputArrayOfArrays( _InputArray argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpInputArrayOfArrays( $argument ) -> retval
```

### cv::utils::dumpInputOutputArray

```cpp
std::string cv::utils::dumpInputOutputArray( _InputOutputArray argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpInputOutputArray( $argument ) -> retval, $argument
```

### cv::utils::dumpInputOutputArrayOfArrays

```cpp
std::string cv::utils::dumpInputOutputArrayOfArrays( _InputOutputArray argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpInputOutputArrayOfArrays( $argument ) -> retval, $argument
```

### cv::utils::dumpBool

```cpp
std::string cv::utils::dumpBool( bool argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpBool( $argument ) -> retval
```

### cv::utils::dumpInt

```cpp
std::string cv::utils::dumpInt( int argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpInt( $argument ) -> retval
```

### cv::utils::dumpSizeT

```cpp
std::string cv::utils::dumpSizeT( size_t argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpSizeT( $argument ) -> retval
```

### cv::utils::dumpFloat

```cpp
std::string cv::utils::dumpFloat( float argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpFloat( $argument ) -> retval
```

### cv::utils::dumpDouble

```cpp
std::string cv::utils::dumpDouble( double argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpDouble( $argument ) -> retval
```

### cv::utils::dumpCString

```cpp
std::string cv::utils::dumpCString( const char* argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpCString( $argument ) -> retval
```

### cv::utils::dumpString

```cpp
std::string cv::utils::dumpString( const std::string& argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpString( $argument ) -> retval
```

### cv::utils::testOverloadResolution

```cpp
std::string cv::utils::testOverloadResolution( int              value,
                                               const cv::Point& point = Point(42, 24) )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").testOverloadResolution( $value[, $point] ) -> retval
```

```cpp
std::string cv::utils::testOverloadResolution( const cv::Rect& rect )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").testOverloadResolution( $rect ) -> retval
```

### cv::utils::dumpRect

```cpp
std::string cv::utils::dumpRect( const cv::Rect& argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpRect( $argument ) -> retval
```

### cv::utils::dumpTermCriteria

```cpp
std::string cv::utils::dumpTermCriteria( const cv::TermCriteria& argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpTermCriteria( $argument ) -> retval
```

### cv::utils::dumpRotatedRect

```cpp
std::string cv::utils::dumpRotatedRect( const cv::RotatedRect& argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpRotatedRect( $argument ) -> retval
```

### cv::utils::testRotatedRect

```cpp
cv::RotatedRect cv::utils::testRotatedRect( float x,
                                            float y,
                                            float w,
                                            float h,
                                            float angle )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").testRotatedRect( $x, $y, $w, $h, $angle ) -> retval
```

### cv::utils::testRotatedRectVector

```cpp
std::vector<cv::RotatedRect> cv::utils::testRotatedRectVector( float x,
                                                               float y,
                                                               float w,
                                                               float h,
                                                               float angle )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").testRotatedRectVector( $x, $y, $w, $h, $angle ) -> retval
```

### cv::utils::dumpRange

```cpp
std::string cv::utils::dumpRange( const cv::Range& argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpRange( $argument ) -> retval
```

### cv::utils::testOverwriteNativeMethod

```cpp
int cv::utils::testOverwriteNativeMethod( int argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").testOverwriteNativeMethod( $argument ) -> retval
```

### cv::utils::testReservedKeywordConversion

```cpp
std::string cv::utils::testReservedKeywordConversion( int positional_argument,
                                                      int lambda = 2,
                                                      int from = 3 )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").testReservedKeywordConversion( $positional_argument[, $lambda[, $from]] ) -> retval
```

### cv::utils::dumpVectorOfInt

```cpp
std::string cv::utils::dumpVectorOfInt( const std::vector<int>& vec )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpVectorOfInt( $vec ) -> retval
```

### cv::utils::dumpVectorOfDouble

```cpp
std::string cv::utils::dumpVectorOfDouble( const std::vector<double>& vec )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpVectorOfDouble( $vec ) -> retval
```

### cv::utils::dumpVectorOfRect

```cpp
std::string cv::utils::dumpVectorOfRect( const std::vector<cv::Rect>& vec )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").dumpVectorOfRect( $vec ) -> retval
```

### cv::utils::generateVectorOfRect

```cpp
void cv::utils::generateVectorOfRect( size_t                 len,
                                      std::vector<cv::Rect>& vec )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").generateVectorOfRect( $len[, $vec] ) -> $vec
```

### cv::utils::generateVectorOfInt

```cpp
void cv::utils::generateVectorOfInt( size_t            len,
                                     std::vector<int>& vec )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").generateVectorOfInt( $len[, $vec] ) -> $vec
```

### cv::utils::generateVectorOfMat

```cpp
void cv::utils::generateVectorOfMat( size_t                len,
                                     int                   rows,
                                     int                   cols,
                                     int                   dtype,
                                     std::vector<cv::Mat>& vec )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").generateVectorOfMat( $len, $rows, $cols, $dtype[, $vec] ) -> $vec
```

### cv::utils::testRaiseGeneralException

```cpp
void cv::utils::testRaiseGeneralException()

AutoIt:
    _OpenCV_ObjCreate("cv.utils").testRaiseGeneralException() -> None
```

### cv::utils::testAsyncArray

```cpp
cv::AsyncArray cv::utils::testAsyncArray( _InputArray argument )

AutoIt:
    _OpenCV_ObjCreate("cv.utils").testAsyncArray( $argument ) -> retval
```

### cv::utils::testAsyncException

```cpp
cv::AsyncArray cv::utils::testAsyncException()

AutoIt:
    _OpenCV_ObjCreate("cv.utils").testAsyncException() -> retval
```

## cv::utils::fs

### cv::utils::fs::getCacheDirectoryForDownloads

```cpp
std::string cv::utils::fs::getCacheDirectoryForDownloads()

AutoIt:
    _OpenCV_ObjCreate("cv.utils.fs").getCacheDirectoryForDownloads() -> retval
```

## cv::detail

### cv::detail::focalsFromHomography

```cpp
void cv::detail::focalsFromHomography( const cv::Mat& H,
                                       double&        f0,
                                       double&        f1,
                                       bool&          f0_ok,
                                       bool&          f1_ok )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").focalsFromHomography( $H, $f0, $f1, $f0_ok, $f1_ok ) -> None
```

### cv::detail::calibrateRotatingCamera

```cpp
bool cv::detail::calibrateRotatingCamera( const std::vector<cv::Mat>& Hs,
                                          cv::Mat&                    K )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").calibrateRotatingCamera( $Hs[, $K] ) -> retval, $K
```

### cv::detail::normalizeUsingWeightMap

```cpp
void cv::detail::normalizeUsingWeightMap( _InputArray       weight,
                                          _InputOutputArray src )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").normalizeUsingWeightMap( $weight, $src ) -> $src
```

### cv::detail::createWeightMap

```cpp
void cv::detail::createWeightMap( _InputArray       mask,
                                  float             sharpness,
                                  _InputOutputArray weight )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").createWeightMap( $mask, $sharpness, $weight ) -> $weight
```

### cv::detail::createLaplacePyr

```cpp
void cv::detail::createLaplacePyr( _InputArray            img,
                                   int                    num_levels,
                                   std::vector<cv::UMat>& pyr )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").createLaplacePyr( $img, $num_levels, $pyr ) -> $pyr
```

### cv::detail::createLaplacePyrGpu

```cpp
void cv::detail::createLaplacePyrGpu( _InputArray            img,
                                      int                    num_levels,
                                      std::vector<cv::UMat>& pyr )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").createLaplacePyrGpu( $img, $num_levels, $pyr ) -> $pyr
```

### cv::detail::restoreImageFromLaplacePyr

```cpp
void cv::detail::restoreImageFromLaplacePyr( std::vector<cv::UMat>& pyr )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").restoreImageFromLaplacePyr( $pyr ) -> $pyr
```

### cv::detail::restoreImageFromLaplacePyrGpu

```cpp
void cv::detail::restoreImageFromLaplacePyrGpu( std::vector<cv::UMat>& pyr )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").restoreImageFromLaplacePyrGpu( $pyr ) -> $pyr
```

### cv::detail::computeImageFeatures

```cpp
void cv::detail::computeImageFeatures( const cv::Ptr<cv::Feature2D>&           featuresFinder,
                                       _InputArray                             images,
                                       std::vector<cv::detail::ImageFeatures>& features,
                                       _InputArray                             masks = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").computeImageFeatures( $featuresFinder, $images[, $masks[, $features]] ) -> $features
```

### cv::detail::computeImageFeatures2

```cpp
void cv::detail::computeImageFeatures2( const cv::Ptr<cv::Feature2D>& featuresFinder,
                                        _InputArray                   image,
                                        cv::detail::ImageFeatures&    features,
                                        _InputArray                   mask = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").computeImageFeatures2( $featuresFinder, $image[, $mask[, $features]] ) -> $features
```

### cv::detail::waveCorrect

```cpp
void cv::detail::waveCorrect( std::vector<cv::Mat>& rmats,
                              int                   kind )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").waveCorrect( $rmats, $kind ) -> $rmats
```

### cv::detail::matchesGraphAsString

```cpp
std::string cv::detail::matchesGraphAsString( std::vector<std::string>&             pathes,
                                              std::vector<cv::detail::MatchesInfo>& pairwise_matches,
                                              float                                 conf_threshold )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").matchesGraphAsString( $pathes, $pairwise_matches, $conf_threshold ) -> retval
```

### cv::detail::leaveBiggestComponent

```cpp
std::vector<int> cv::detail::leaveBiggestComponent( std::vector<cv::detail::ImageFeatures>& features,
                                                    std::vector<cv::detail::MatchesInfo>&   pairwise_matches,
                                                    float                                   conf_threshold )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").leaveBiggestComponent( $features, $pairwise_matches, $conf_threshold ) -> retval
```

### cv::detail::overlapRoi

```cpp
bool cv::detail::overlapRoi( cv::Point tl1,
                             cv::Point tl2,
                             cv::Size  sz1,
                             cv::Size  sz2,
                             cv::Rect& roi )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").overlapRoi( $tl1, $tl2, $sz1, $sz2, $roi ) -> retval
```

### cv::detail::resultRoi

```cpp
cv::Rect cv::detail::resultRoi( const std::vector<cv::Point>& corners,
                                const std::vector<cv::UMat>&  images )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").resultRoi( $corners, $images ) -> retval
```

```cpp
cv::Rect cv::detail::resultRoi( const std::vector<cv::Point>& corners,
                                const std::vector<cv::Size>&  sizes )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").resultRoi( $corners, $sizes ) -> retval
```

### cv::detail::resultRoiIntersection

```cpp
cv::Rect cv::detail::resultRoiIntersection( const std::vector<cv::Point>& corners,
                                            const std::vector<cv::Size>&  sizes )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").resultRoiIntersection( $corners, $sizes ) -> retval
```

### cv::detail::resultTl

```cpp
cv::Point cv::detail::resultTl( const std::vector<cv::Point>& corners )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").resultTl( $corners ) -> retval
```

### cv::detail::selectRandomSubset

```cpp
void cv::detail::selectRandomSubset( int               count,
                                     int               size,
                                     std::vector<int>& subset )

AutoIt:
    _OpenCV_ObjCreate("cv.detail").selectRandomSubset( $count, $size, $subset ) -> None
```

### cv::detail::stitchingLogLevel

```cpp
int cv::detail::stitchingLogLevel()

AutoIt:
    _OpenCV_ObjCreate("cv.detail").stitchingLogLevel() -> retval
```

## cv::cuda

### cv::cuda::createContinuous

```cpp
void cv::cuda::createContinuous( int          rows,
                                 int          cols,
                                 int          type,
                                 _OutputArray arr )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda").createContinuous( $rows, $cols, $type[, $arr] ) -> $arr
```

### cv::cuda::ensureSizeIsEnough

```cpp
void cv::cuda::ensureSizeIsEnough( int          rows,
                                   int          cols,
                                   int          type,
                                   _OutputArray arr )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda").ensureSizeIsEnough( $rows, $cols, $type[, $arr] ) -> $arr
```

### cv::cuda::setBufferPoolUsage

```cpp
void cv::cuda::setBufferPoolUsage( bool on )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda").setBufferPoolUsage( $on ) -> None
```

### cv::cuda::setBufferPoolConfig

```cpp
void cv::cuda::setBufferPoolConfig( int    deviceId,
                                    size_t stackSize,
                                    int    stackCount )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda").setBufferPoolConfig( $deviceId, $stackSize, $stackCount ) -> None
```

### cv::cuda::registerPageLocked

```cpp
void cv::cuda::registerPageLocked( cv::Mat& m )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda").registerPageLocked( $m ) -> None
```

### cv::cuda::unregisterPageLocked

```cpp
void cv::cuda::unregisterPageLocked( cv::Mat& m )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda").unregisterPageLocked( $m ) -> None
```

### cv::cuda::getCudaEnabledDeviceCount

```cpp
int cv::cuda::getCudaEnabledDeviceCount()

AutoIt:
    _OpenCV_ObjCreate("cv.cuda").getCudaEnabledDeviceCount() -> retval
```

### cv::cuda::setDevice

```cpp
void cv::cuda::setDevice( int device )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda").setDevice( $device ) -> None
```

### cv::cuda::getDevice

```cpp
int cv::cuda::getDevice()

AutoIt:
    _OpenCV_ObjCreate("cv.cuda").getDevice() -> retval
```

### cv::cuda::resetDevice

```cpp
void cv::cuda::resetDevice()

AutoIt:
    _OpenCV_ObjCreate("cv.cuda").resetDevice() -> None
```

### cv::cuda::printCudaDeviceInfo

```cpp
void cv::cuda::printCudaDeviceInfo( int device )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda").printCudaDeviceInfo( $device ) -> None
```

### cv::cuda::printShortCudaDeviceInfo

```cpp
void cv::cuda::printShortCudaDeviceInfo( int device )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda").printShortCudaDeviceInfo( $device ) -> None
```

## cv::cuda::GpuMat

### cv::cuda::GpuMat::defaultAllocator

```cpp
static cv::cuda::GpuMat::Allocator* cv::cuda::GpuMat::defaultAllocator()

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.GpuMat").defaultAllocator() -> retval
```

### cv::cuda::GpuMat::setDefaultAllocator

```cpp
static void cv::cuda::GpuMat::setDefaultAllocator( cv::cuda::GpuMat::Allocator* allocator )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.GpuMat").setDefaultAllocator( $allocator ) -> None
```

### cv::cuda::GpuMat::create

```cpp
static cv::cuda::GpuMat cv::cuda::GpuMat::create( cv::cuda::GpuMat::Allocator* allocator = GpuMat::defaultAllocator() )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.GpuMat").create( [$allocator] ) -> <cv.cuda.GpuMat object>
```

```cpp
static cv::cuda::GpuMat cv::cuda::GpuMat::create( int                          rows,
                                                  int                          cols,
                                                  int                          type,
                                                  cv::cuda::GpuMat::Allocator* allocator = GpuMat::defaultAllocator() )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.GpuMat").create( $rows, $cols, $type[, $allocator] ) -> <cv.cuda.GpuMat object>
```

```cpp
static cv::cuda::GpuMat cv::cuda::GpuMat::create( cv::Size                     size,
                                                  int                          type,
                                                  cv::cuda::GpuMat::Allocator* allocator = GpuMat::defaultAllocator() )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.GpuMat").create( $size, $type[, $allocator] ) -> <cv.cuda.GpuMat object>
```

```cpp
static cv::cuda::GpuMat cv::cuda::GpuMat::create( int                          rows,
                                                  int                          cols,
                                                  int                          type,
                                                  cv::Scalar                   s,
                                                  cv::cuda::GpuMat::Allocator* allocator = GpuMat::defaultAllocator() )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.GpuMat").create( $rows, $cols, $type, $s[, $allocator] ) -> <cv.cuda.GpuMat object>
```

```cpp
static cv::cuda::GpuMat cv::cuda::GpuMat::create( cv::Size                     size,
                                                  int                          type,
                                                  cv::Scalar                   s,
                                                  cv::cuda::GpuMat::Allocator* allocator = GpuMat::defaultAllocator() )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.GpuMat").create( $size, $type, $s[, $allocator] ) -> <cv.cuda.GpuMat object>
```

```cpp
static cv::cuda::GpuMat cv::cuda::GpuMat::create( const cv::cuda::GpuMat& m )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.GpuMat").create( $m ) -> <cv.cuda.GpuMat object>
```

```cpp
static cv::cuda::GpuMat cv::cuda::GpuMat::create( const cv::cuda::GpuMat& m,
                                                  cv::Range               rowRange,
                                                  cv::Range               colRange )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.GpuMat").create( $m, $rowRange, $colRange ) -> <cv.cuda.GpuMat object>
```

```cpp
static cv::cuda::GpuMat cv::cuda::GpuMat::create( const cv::cuda::GpuMat& m,
                                                  cv::Rect                roi )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.GpuMat").create( $m, $roi ) -> <cv.cuda.GpuMat object>
```

```cpp
static cv::cuda::GpuMat cv::cuda::GpuMat::create( _InputArray                  arr,
                                                  cv::cuda::GpuMat::Allocator* allocator = GpuMat::defaultAllocator() )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.GpuMat").create( $arr[, $allocator] ) -> <cv.cuda.GpuMat object>
```

```cpp
void cv::cuda::GpuMat::create( int rows,
                               int cols,
                               int type )

AutoIt:
    $oGpuMat.create( $rows, $cols, $type ) -> None
```

```cpp
void cv::cuda::GpuMat::create( cv::Size size,
                               int      type )

AutoIt:
    $oGpuMat.create( $size, $type ) -> None
```

### cv::cuda::GpuMat::swap

```cpp
void cv::cuda::GpuMat::swap( cv::cuda::GpuMat& mat )

AutoIt:
    $oGpuMat.swap( $mat ) -> None
```

### cv::cuda::GpuMat::upload

```cpp
void cv::cuda::GpuMat::upload( _InputArray arr )

AutoIt:
    $oGpuMat.upload( $arr ) -> None
```

```cpp
void cv::cuda::GpuMat::upload( _InputArray       arr,
                               cv::cuda::Stream& stream )

AutoIt:
    $oGpuMat.upload( $arr, $stream ) -> None
```

### cv::cuda::GpuMat::download

```cpp
void cv::cuda::GpuMat::download( _OutputArray dst )

AutoIt:
    $oGpuMat.download( [$dst] ) -> $dst
```

```cpp
void cv::cuda::GpuMat::download( _OutputArray      dst,
                                 cv::cuda::Stream& stream )

AutoIt:
    $oGpuMat.download( $stream[, $dst] ) -> $dst
```

### cv::cuda::GpuMat::clone

```cpp
cv::cuda::GpuMat cv::cuda::GpuMat::clone()

AutoIt:
    $oGpuMat.clone() -> retval
```

### cv::cuda::GpuMat::copyTo

```cpp
void cv::cuda::GpuMat::copyTo( _OutputArray dst )

AutoIt:
    $oGpuMat.copyTo( [$dst] ) -> $dst
```

```cpp
void cv::cuda::GpuMat::copyTo( _OutputArray      dst,
                               cv::cuda::Stream& stream )

AutoIt:
    $oGpuMat.copyTo( $stream[, $dst] ) -> $dst
```

```cpp
void cv::cuda::GpuMat::copyTo( _OutputArray dst,
                               _InputArray  mask )

AutoIt:
    $oGpuMat.copyTo( $mask[, $dst] ) -> $dst
```

```cpp
void cv::cuda::GpuMat::copyTo( _OutputArray      dst,
                               _InputArray       mask,
                               cv::cuda::Stream& stream )

AutoIt:
    $oGpuMat.copyTo( $mask, $stream[, $dst] ) -> $dst
```

### cv::cuda::GpuMat::setTo

```cpp
cv::cuda::GpuMat cv::cuda::GpuMat::setTo( cv::Scalar s )

AutoIt:
    $oGpuMat.setTo( $s ) -> retval
```

```cpp
cv::cuda::GpuMat cv::cuda::GpuMat::setTo( cv::Scalar        s,
                                          cv::cuda::Stream& stream )

AutoIt:
    $oGpuMat.setTo( $s, $stream ) -> retval
```

```cpp
cv::cuda::GpuMat cv::cuda::GpuMat::setTo( cv::Scalar  s,
                                          _InputArray mask )

AutoIt:
    $oGpuMat.setTo( $s, $mask ) -> retval
```

```cpp
cv::cuda::GpuMat cv::cuda::GpuMat::setTo( cv::Scalar        s,
                                          _InputArray       mask,
                                          cv::cuda::Stream& stream )

AutoIt:
    $oGpuMat.setTo( $s, $mask, $stream ) -> retval
```

### cv::cuda::GpuMat::convertTo

```cpp
void cv::cuda::GpuMat::convertTo( _OutputArray dst,
                                  int          rtype )

AutoIt:
    $oGpuMat.convertTo( $rtype[, $dst] ) -> $dst
```

```cpp
void cv::cuda::GpuMat::convertTo( _OutputArray      dst,
                                  int               rtype,
                                  cv::cuda::Stream& stream )

AutoIt:
    $oGpuMat.convertTo( $rtype, $stream[, $dst] ) -> $dst
```

```cpp
void cv::cuda::GpuMat::convertTo( _OutputArray dst,
                                  int          rtype,
                                  double       alpha,
                                  double       beta = 0.0 )

AutoIt:
    $oGpuMat.convertTo( $rtype, $alpha[, $dst[, $beta]] ) -> $dst
```

```cpp
void cv::cuda::GpuMat::convertTo( _OutputArray      dst,
                                  int               rtype,
                                  double            alpha,
                                  cv::cuda::Stream& stream )

AutoIt:
    $oGpuMat.convertTo( $rtype, $alpha, $stream[, $dst] ) -> $dst
```

```cpp
void cv::cuda::GpuMat::convertTo( _OutputArray      dst,
                                  int               rtype,
                                  double            alpha,
                                  double            beta,
                                  cv::cuda::Stream& stream )

AutoIt:
    $oGpuMat.convertTo( $rtype, $alpha, $beta, $stream[, $dst] ) -> $dst
```

### cv::cuda::GpuMat::assignTo

```cpp
void cv::cuda::GpuMat::assignTo( cv::cuda::GpuMat& m,
                                 int               type = -1 )

AutoIt:
    $oGpuMat.assignTo( $m[, $type] ) -> None
```

### cv::cuda::GpuMat::row

```cpp
cv::cuda::GpuMat cv::cuda::GpuMat::row( int y )

AutoIt:
    $oGpuMat.row( $y ) -> retval
```

### cv::cuda::GpuMat::col

```cpp
cv::cuda::GpuMat cv::cuda::GpuMat::col( int x )

AutoIt:
    $oGpuMat.col( $x ) -> retval
```

### cv::cuda::GpuMat::rowRange

```cpp
cv::cuda::GpuMat cv::cuda::GpuMat::rowRange( int startrow,
                                             int endrow )

AutoIt:
    $oGpuMat.rowRange( $startrow, $endrow ) -> retval
```

```cpp
cv::cuda::GpuMat cv::cuda::GpuMat::rowRange( cv::Range r )

AutoIt:
    $oGpuMat.rowRange( $r ) -> retval
```

### cv::cuda::GpuMat::colRange

```cpp
cv::cuda::GpuMat cv::cuda::GpuMat::colRange( int startcol,
                                             int endcol )

AutoIt:
    $oGpuMat.colRange( $startcol, $endcol ) -> retval
```

```cpp
cv::cuda::GpuMat cv::cuda::GpuMat::colRange( cv::Range r )

AutoIt:
    $oGpuMat.colRange( $r ) -> retval
```

### cv::cuda::GpuMat::reshape

```cpp
cv::cuda::GpuMat cv::cuda::GpuMat::reshape( int cn,
                                            int rows = 0 )

AutoIt:
    $oGpuMat.reshape( $cn[, $rows] ) -> retval
```

### cv::cuda::GpuMat::locateROI

```cpp
void cv::cuda::GpuMat::locateROI( cv::Size&  wholeSize,
                                  cv::Point& ofs )

AutoIt:
    $oGpuMat.locateROI( $wholeSize, $ofs ) -> None
```

### cv::cuda::GpuMat::adjustROI

```cpp
cv::cuda::GpuMat cv::cuda::GpuMat::adjustROI( int dtop,
                                              int dbottom,
                                              int dleft,
                                              int dright )

AutoIt:
    $oGpuMat.adjustROI( $dtop, $dbottom, $dleft, $dright ) -> retval
```

### cv::cuda::GpuMat::isContinuous

```cpp
bool cv::cuda::GpuMat::isContinuous()

AutoIt:
    $oGpuMat.isContinuous() -> retval
```

### cv::cuda::GpuMat::elemSize

```cpp
size_t cv::cuda::GpuMat::elemSize()

AutoIt:
    $oGpuMat.elemSize() -> retval
```

### cv::cuda::GpuMat::elemSize1

```cpp
size_t cv::cuda::GpuMat::elemSize1()

AutoIt:
    $oGpuMat.elemSize1() -> retval
```

### cv::cuda::GpuMat::type

```cpp
int cv::cuda::GpuMat::type()

AutoIt:
    $oGpuMat.type() -> retval
```

### cv::cuda::GpuMat::depth

```cpp
int cv::cuda::GpuMat::depth()

AutoIt:
    $oGpuMat.depth() -> retval
```

### cv::cuda::GpuMat::channels

```cpp
int cv::cuda::GpuMat::channels()

AutoIt:
    $oGpuMat.channels() -> retval
```

### cv::cuda::GpuMat::step1

```cpp
size_t cv::cuda::GpuMat::step1()

AutoIt:
    $oGpuMat.step1() -> retval
```

### cv::cuda::GpuMat::size

```cpp
cv::Size cv::cuda::GpuMat::size()

AutoIt:
    $oGpuMat.size() -> retval
```

### cv::cuda::GpuMat::empty

```cpp
bool cv::cuda::GpuMat::empty()

AutoIt:
    $oGpuMat.empty() -> retval
```

### cv::cuda::GpuMat::cudaPtr

```cpp
void* cv::cuda::GpuMat::cudaPtr()

AutoIt:
    $oGpuMat.cudaPtr() -> retval
```

### cv::cuda::GpuMat::updateContinuityFlag

```cpp
void cv::cuda::GpuMat::updateContinuityFlag()

AutoIt:
    $oGpuMat.updateContinuityFlag() -> None
```

## cv::cuda::BufferPool

### cv::cuda::BufferPool::getBuffer

```cpp
cv::cuda::GpuMat cv::cuda::BufferPool::getBuffer( int rows,
                                                  int cols,
                                                  int type )

AutoIt:
    $oBufferPool.getBuffer( $rows, $cols, $type ) -> retval
```

```cpp
cv::cuda::GpuMat cv::cuda::BufferPool::getBuffer( cv::Size size,
                                                  int      type )

AutoIt:
    $oBufferPool.getBuffer( $size, $type ) -> retval
```

### cv::cuda::BufferPool::getAllocator

```cpp
cv::Ptr<cv::cuda::GpuMat::Allocator> cv::cuda::BufferPool::getAllocator()

AutoIt:
    $oBufferPool.getAllocator() -> retval
```

## cv::cuda::HostMem

### cv::cuda::HostMem::create

```cpp
static cv::cuda::HostMem cv::cuda::HostMem::create( int alloc_type = HostMem::AllocType::PAGE_LOCKED )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.HostMem").create( [$alloc_type] ) -> <cv.cuda.HostMem object>
```

```cpp
static cv::cuda::HostMem cv::cuda::HostMem::create( int rows,
                                                    int cols,
                                                    int type,
                                                    int alloc_type = HostMem::AllocType::PAGE_LOCKED )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.HostMem").create( $rows, $cols, $type[, $alloc_type] ) -> <cv.cuda.HostMem object>
```

```cpp
static cv::cuda::HostMem cv::cuda::HostMem::create( cv::Size size,
                                                    int      type,
                                                    int      alloc_type = HostMem::AllocType::PAGE_LOCKED )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.HostMem").create( $size, $type[, $alloc_type] ) -> <cv.cuda.HostMem object>
```

```cpp
static cv::cuda::HostMem cv::cuda::HostMem::create( _InputArray arr,
                                                    int         alloc_type = HostMem::AllocType::PAGE_LOCKED )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.HostMem").create( $arr[, $alloc_type] ) -> <cv.cuda.HostMem object>
```

```cpp
void cv::cuda::HostMem::create( int rows,
                                int cols,
                                int type )

AutoIt:
    $oHostMem.create( $rows, $cols, $type ) -> None
```

```cpp
static cv::cuda::HostMem cv::cuda::HostMem::create( cv::cuda::HostMem m )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.HostMem").create( $m ) -> <cv.cuda.HostMem object>
```

### cv::cuda::HostMem::swap

```cpp
void cv::cuda::HostMem::swap( cv::cuda::HostMem& b )

AutoIt:
    $oHostMem.swap( $b ) -> None
```

### cv::cuda::HostMem::clone

```cpp
cv::cuda::HostMem cv::cuda::HostMem::clone()

AutoIt:
    $oHostMem.clone() -> retval
```

### cv::cuda::HostMem::reshape

```cpp
cv::cuda::HostMem cv::cuda::HostMem::reshape( int cn,
                                              int rows = 0 )

AutoIt:
    $oHostMem.reshape( $cn[, $rows] ) -> retval
```

### cv::cuda::HostMem::createMatHeader

```cpp
cv::Mat cv::cuda::HostMem::createMatHeader()

AutoIt:
    $oHostMem.createMatHeader() -> retval
```

### cv::cuda::HostMem::isContinuous

```cpp
bool cv::cuda::HostMem::isContinuous()

AutoIt:
    $oHostMem.isContinuous() -> retval
```

### cv::cuda::HostMem::elemSize

```cpp
size_t cv::cuda::HostMem::elemSize()

AutoIt:
    $oHostMem.elemSize() -> retval
```

### cv::cuda::HostMem::elemSize1

```cpp
size_t cv::cuda::HostMem::elemSize1()

AutoIt:
    $oHostMem.elemSize1() -> retval
```

### cv::cuda::HostMem::type

```cpp
int cv::cuda::HostMem::type()

AutoIt:
    $oHostMem.type() -> retval
```

### cv::cuda::HostMem::depth

```cpp
int cv::cuda::HostMem::depth()

AutoIt:
    $oHostMem.depth() -> retval
```

### cv::cuda::HostMem::channels

```cpp
int cv::cuda::HostMem::channels()

AutoIt:
    $oHostMem.channels() -> retval
```

### cv::cuda::HostMem::step1

```cpp
size_t cv::cuda::HostMem::step1()

AutoIt:
    $oHostMem.step1() -> retval
```

### cv::cuda::HostMem::size

```cpp
cv::Size cv::cuda::HostMem::size()

AutoIt:
    $oHostMem.size() -> retval
```

### cv::cuda::HostMem::empty

```cpp
bool cv::cuda::HostMem::empty()

AutoIt:
    $oHostMem.empty() -> retval
```

## cv::cuda::Stream

### cv::cuda::Stream::create

```cpp
static cv::cuda::Stream cv::cuda::Stream::create()

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.Stream").create() -> <cv.cuda.Stream object>
```

```cpp
static cv::cuda::Stream cv::cuda::Stream::create( const cv::Ptr<cv::cuda::GpuMat::Allocator>& allocator )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.Stream").create( $allocator ) -> <cv.cuda.Stream object>
```

```cpp
static cv::cuda::Stream cv::cuda::Stream::create( const size_t cudaFlags )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.Stream").create( $cudaFlags ) -> <cv.cuda.Stream object>
```

### cv::cuda::Stream::queryIfComplete

```cpp
bool cv::cuda::Stream::queryIfComplete()

AutoIt:
    $oStream.queryIfComplete() -> retval
```

### cv::cuda::Stream::waitForCompletion

```cpp
void cv::cuda::Stream::waitForCompletion()

AutoIt:
    $oStream.waitForCompletion() -> None
```

### cv::cuda::Stream::waitEvent

```cpp
void cv::cuda::Stream::waitEvent( const cv::cuda::Event& event )

AutoIt:
    $oStream.waitEvent( $event ) -> None
```

### cv::cuda::Stream::Null

```cpp
static cv::cuda::Stream cv::cuda::Stream::Null()

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.Stream").Null() -> retval
```

### cv::cuda::Stream::cudaPtr

```cpp
void* cv::cuda::Stream::cudaPtr()

AutoIt:
    $oStream.cudaPtr() -> retval
```

## cv::cuda::Event

### cv::cuda::Event::create

```cpp
static cv::cuda::Event cv::cuda::Event::create( int flags = Event::CreateFlags::DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.Event").create( [$flags] ) -> <cv.cuda.Event object>
```

### cv::cuda::Event::record

```cpp
void cv::cuda::Event::record( cv::cuda::Stream& stream = Stream::Null() )

AutoIt:
    $oEvent.record( [$stream] ) -> None
```

### cv::cuda::Event::queryIfComplete

```cpp
bool cv::cuda::Event::queryIfComplete()

AutoIt:
    $oEvent.queryIfComplete() -> retval
```

### cv::cuda::Event::waitForCompletion

```cpp
void cv::cuda::Event::waitForCompletion()

AutoIt:
    $oEvent.waitForCompletion() -> None
```

### cv::cuda::Event::elapsedTime

```cpp
static float cv::cuda::Event::elapsedTime( const cv::cuda::Event& start,
                                           const cv::cuda::Event& end )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.Event").elapsedTime( $start, $end ) -> retval
```

## cv::cuda::TargetArchs

### cv::cuda::TargetArchs::has

```cpp
static bool cv::cuda::TargetArchs::has( int major,
                                        int minor )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.TargetArchs").has( $major, $minor ) -> retval
```

### cv::cuda::TargetArchs::hasPtx

```cpp
static bool cv::cuda::TargetArchs::hasPtx( int major,
                                           int minor )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.TargetArchs").hasPtx( $major, $minor ) -> retval
```

### cv::cuda::TargetArchs::hasBin

```cpp
static bool cv::cuda::TargetArchs::hasBin( int major,
                                           int minor )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.TargetArchs").hasBin( $major, $minor ) -> retval
```

### cv::cuda::TargetArchs::hasEqualOrLessPtx

```cpp
static bool cv::cuda::TargetArchs::hasEqualOrLessPtx( int major,
                                                      int minor )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.TargetArchs").hasEqualOrLessPtx( $major, $minor ) -> retval
```

### cv::cuda::TargetArchs::hasEqualOrGreater

```cpp
static bool cv::cuda::TargetArchs::hasEqualOrGreater( int major,
                                                      int minor )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.TargetArchs").hasEqualOrGreater( $major, $minor ) -> retval
```

### cv::cuda::TargetArchs::hasEqualOrGreaterPtx

```cpp
static bool cv::cuda::TargetArchs::hasEqualOrGreaterPtx( int major,
                                                         int minor )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.TargetArchs").hasEqualOrGreaterPtx( $major, $minor ) -> retval
```

### cv::cuda::TargetArchs::hasEqualOrGreaterBin

```cpp
static bool cv::cuda::TargetArchs::hasEqualOrGreaterBin( int major,
                                                         int minor )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.TargetArchs").hasEqualOrGreaterBin( $major, $minor ) -> retval
```

## cv::cuda::DeviceInfo

### cv::cuda::DeviceInfo::create

```cpp
static cv::cuda::DeviceInfo cv::cuda::DeviceInfo::create()

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.DeviceInfo").create() -> <cv.cuda.DeviceInfo object>
```

```cpp
static cv::cuda::DeviceInfo cv::cuda::DeviceInfo::create( int device_id )

AutoIt:
    _OpenCV_ObjCreate("cv.cuda.DeviceInfo").create( $device_id ) -> <cv.cuda.DeviceInfo object>
```

### cv::cuda::DeviceInfo::deviceID

```cpp
int cv::cuda::DeviceInfo::deviceID()

AutoIt:
    $oDeviceInfo.deviceID() -> retval
```

### cv::cuda::DeviceInfo::totalGlobalMem

```cpp
size_t cv::cuda::DeviceInfo::totalGlobalMem()

AutoIt:
    $oDeviceInfo.totalGlobalMem() -> retval
```

### cv::cuda::DeviceInfo::sharedMemPerBlock

```cpp
size_t cv::cuda::DeviceInfo::sharedMemPerBlock()

AutoIt:
    $oDeviceInfo.sharedMemPerBlock() -> retval
```

### cv::cuda::DeviceInfo::regsPerBlock

```cpp
int cv::cuda::DeviceInfo::regsPerBlock()

AutoIt:
    $oDeviceInfo.regsPerBlock() -> retval
```

### cv::cuda::DeviceInfo::warpSize

```cpp
int cv::cuda::DeviceInfo::warpSize()

AutoIt:
    $oDeviceInfo.warpSize() -> retval
```

### cv::cuda::DeviceInfo::memPitch

```cpp
size_t cv::cuda::DeviceInfo::memPitch()

AutoIt:
    $oDeviceInfo.memPitch() -> retval
```

### cv::cuda::DeviceInfo::maxThreadsPerBlock

```cpp
int cv::cuda::DeviceInfo::maxThreadsPerBlock()

AutoIt:
    $oDeviceInfo.maxThreadsPerBlock() -> retval
```

### cv::cuda::DeviceInfo::maxThreadsDim

```cpp
cv::Vec3i cv::cuda::DeviceInfo::maxThreadsDim()

AutoIt:
    $oDeviceInfo.maxThreadsDim() -> retval
```

### cv::cuda::DeviceInfo::maxGridSize

```cpp
cv::Vec3i cv::cuda::DeviceInfo::maxGridSize()

AutoIt:
    $oDeviceInfo.maxGridSize() -> retval
```

### cv::cuda::DeviceInfo::clockRate

```cpp
int cv::cuda::DeviceInfo::clockRate()

AutoIt:
    $oDeviceInfo.clockRate() -> retval
```

### cv::cuda::DeviceInfo::totalConstMem

```cpp
size_t cv::cuda::DeviceInfo::totalConstMem()

AutoIt:
    $oDeviceInfo.totalConstMem() -> retval
```

### cv::cuda::DeviceInfo::majorVersion

```cpp
int cv::cuda::DeviceInfo::majorVersion()

AutoIt:
    $oDeviceInfo.majorVersion() -> retval
```

### cv::cuda::DeviceInfo::minorVersion

```cpp
int cv::cuda::DeviceInfo::minorVersion()

AutoIt:
    $oDeviceInfo.minorVersion() -> retval
```

### cv::cuda::DeviceInfo::textureAlignment

```cpp
size_t cv::cuda::DeviceInfo::textureAlignment()

AutoIt:
    $oDeviceInfo.textureAlignment() -> retval
```

### cv::cuda::DeviceInfo::texturePitchAlignment

```cpp
size_t cv::cuda::DeviceInfo::texturePitchAlignment()

AutoIt:
    $oDeviceInfo.texturePitchAlignment() -> retval
```

### cv::cuda::DeviceInfo::multiProcessorCount

```cpp
int cv::cuda::DeviceInfo::multiProcessorCount()

AutoIt:
    $oDeviceInfo.multiProcessorCount() -> retval
```

### cv::cuda::DeviceInfo::kernelExecTimeoutEnabled

```cpp
bool cv::cuda::DeviceInfo::kernelExecTimeoutEnabled()

AutoIt:
    $oDeviceInfo.kernelExecTimeoutEnabled() -> retval
```

### cv::cuda::DeviceInfo::integrated

```cpp
bool cv::cuda::DeviceInfo::integrated()

AutoIt:
    $oDeviceInfo.integrated() -> retval
```

### cv::cuda::DeviceInfo::canMapHostMemory

```cpp
bool cv::cuda::DeviceInfo::canMapHostMemory()

AutoIt:
    $oDeviceInfo.canMapHostMemory() -> retval
```

### cv::cuda::DeviceInfo::computeMode

```cpp
int cv::cuda::DeviceInfo::computeMode()

AutoIt:
    $oDeviceInfo.computeMode() -> retval
```

### cv::cuda::DeviceInfo::maxTexture1D

```cpp
int cv::cuda::DeviceInfo::maxTexture1D()

AutoIt:
    $oDeviceInfo.maxTexture1D() -> retval
```

### cv::cuda::DeviceInfo::maxTexture1DMipmap

```cpp
int cv::cuda::DeviceInfo::maxTexture1DMipmap()

AutoIt:
    $oDeviceInfo.maxTexture1DMipmap() -> retval
```

### cv::cuda::DeviceInfo::maxTexture1DLinear

```cpp
int cv::cuda::DeviceInfo::maxTexture1DLinear()

AutoIt:
    $oDeviceInfo.maxTexture1DLinear() -> retval
```

### cv::cuda::DeviceInfo::maxTexture2D

```cpp
cv::Vec2i cv::cuda::DeviceInfo::maxTexture2D()

AutoIt:
    $oDeviceInfo.maxTexture2D() -> retval
```

### cv::cuda::DeviceInfo::maxTexture2DMipmap

```cpp
cv::Vec2i cv::cuda::DeviceInfo::maxTexture2DMipmap()

AutoIt:
    $oDeviceInfo.maxTexture2DMipmap() -> retval
```

### cv::cuda::DeviceInfo::maxTexture2DLinear

```cpp
cv::Vec3i cv::cuda::DeviceInfo::maxTexture2DLinear()

AutoIt:
    $oDeviceInfo.maxTexture2DLinear() -> retval
```

### cv::cuda::DeviceInfo::maxTexture2DGather

```cpp
cv::Vec2i cv::cuda::DeviceInfo::maxTexture2DGather()

AutoIt:
    $oDeviceInfo.maxTexture2DGather() -> retval
```

### cv::cuda::DeviceInfo::maxTexture3D

```cpp
cv::Vec3i cv::cuda::DeviceInfo::maxTexture3D()

AutoIt:
    $oDeviceInfo.maxTexture3D() -> retval
```

### cv::cuda::DeviceInfo::maxTextureCubemap

```cpp
int cv::cuda::DeviceInfo::maxTextureCubemap()

AutoIt:
    $oDeviceInfo.maxTextureCubemap() -> retval
```

### cv::cuda::DeviceInfo::maxTexture1DLayered

```cpp
cv::Vec2i cv::cuda::DeviceInfo::maxTexture1DLayered()

AutoIt:
    $oDeviceInfo.maxTexture1DLayered() -> retval
```

### cv::cuda::DeviceInfo::maxTexture2DLayered

```cpp
cv::Vec3i cv::cuda::DeviceInfo::maxTexture2DLayered()

AutoIt:
    $oDeviceInfo.maxTexture2DLayered() -> retval
```

### cv::cuda::DeviceInfo::maxTextureCubemapLayered

```cpp
cv::Vec2i cv::cuda::DeviceInfo::maxTextureCubemapLayered()

AutoIt:
    $oDeviceInfo.maxTextureCubemapLayered() -> retval
```

### cv::cuda::DeviceInfo::maxSurface1D

```cpp
int cv::cuda::DeviceInfo::maxSurface1D()

AutoIt:
    $oDeviceInfo.maxSurface1D() -> retval
```

### cv::cuda::DeviceInfo::maxSurface2D

```cpp
cv::Vec2i cv::cuda::DeviceInfo::maxSurface2D()

AutoIt:
    $oDeviceInfo.maxSurface2D() -> retval
```

### cv::cuda::DeviceInfo::maxSurface3D

```cpp
cv::Vec3i cv::cuda::DeviceInfo::maxSurface3D()

AutoIt:
    $oDeviceInfo.maxSurface3D() -> retval
```

### cv::cuda::DeviceInfo::maxSurface1DLayered

```cpp
cv::Vec2i cv::cuda::DeviceInfo::maxSurface1DLayered()

AutoIt:
    $oDeviceInfo.maxSurface1DLayered() -> retval
```

### cv::cuda::DeviceInfo::maxSurface2DLayered

```cpp
cv::Vec3i cv::cuda::DeviceInfo::maxSurface2DLayered()

AutoIt:
    $oDeviceInfo.maxSurface2DLayered() -> retval
```

### cv::cuda::DeviceInfo::maxSurfaceCubemap

```cpp
int cv::cuda::DeviceInfo::maxSurfaceCubemap()

AutoIt:
    $oDeviceInfo.maxSurfaceCubemap() -> retval
```

### cv::cuda::DeviceInfo::maxSurfaceCubemapLayered

```cpp
cv::Vec2i cv::cuda::DeviceInfo::maxSurfaceCubemapLayered()

AutoIt:
    $oDeviceInfo.maxSurfaceCubemapLayered() -> retval
```

### cv::cuda::DeviceInfo::surfaceAlignment

```cpp
size_t cv::cuda::DeviceInfo::surfaceAlignment()

AutoIt:
    $oDeviceInfo.surfaceAlignment() -> retval
```

### cv::cuda::DeviceInfo::concurrentKernels

```cpp
bool cv::cuda::DeviceInfo::concurrentKernels()

AutoIt:
    $oDeviceInfo.concurrentKernels() -> retval
```

### cv::cuda::DeviceInfo::ECCEnabled

```cpp
bool cv::cuda::DeviceInfo::ECCEnabled()

AutoIt:
    $oDeviceInfo.ECCEnabled() -> retval
```

### cv::cuda::DeviceInfo::pciBusID

```cpp
int cv::cuda::DeviceInfo::pciBusID()

AutoIt:
    $oDeviceInfo.pciBusID() -> retval
```

### cv::cuda::DeviceInfo::pciDeviceID

```cpp
int cv::cuda::DeviceInfo::pciDeviceID()

AutoIt:
    $oDeviceInfo.pciDeviceID() -> retval
```

### cv::cuda::DeviceInfo::pciDomainID

```cpp
int cv::cuda::DeviceInfo::pciDomainID()

AutoIt:
    $oDeviceInfo.pciDomainID() -> retval
```

### cv::cuda::DeviceInfo::tccDriver

```cpp
bool cv::cuda::DeviceInfo::tccDriver()

AutoIt:
    $oDeviceInfo.tccDriver() -> retval
```

### cv::cuda::DeviceInfo::asyncEngineCount

```cpp
int cv::cuda::DeviceInfo::asyncEngineCount()

AutoIt:
    $oDeviceInfo.asyncEngineCount() -> retval
```

### cv::cuda::DeviceInfo::unifiedAddressing

```cpp
bool cv::cuda::DeviceInfo::unifiedAddressing()

AutoIt:
    $oDeviceInfo.unifiedAddressing() -> retval
```

### cv::cuda::DeviceInfo::memoryClockRate

```cpp
int cv::cuda::DeviceInfo::memoryClockRate()

AutoIt:
    $oDeviceInfo.memoryClockRate() -> retval
```

### cv::cuda::DeviceInfo::memoryBusWidth

```cpp
int cv::cuda::DeviceInfo::memoryBusWidth()

AutoIt:
    $oDeviceInfo.memoryBusWidth() -> retval
```

### cv::cuda::DeviceInfo::l2CacheSize

```cpp
int cv::cuda::DeviceInfo::l2CacheSize()

AutoIt:
    $oDeviceInfo.l2CacheSize() -> retval
```

### cv::cuda::DeviceInfo::maxThreadsPerMultiProcessor

```cpp
int cv::cuda::DeviceInfo::maxThreadsPerMultiProcessor()

AutoIt:
    $oDeviceInfo.maxThreadsPerMultiProcessor() -> retval
```

### cv::cuda::DeviceInfo::queryMemory

```cpp
void cv::cuda::DeviceInfo::queryMemory( size_t& totalMemory,
                                        size_t& freeMemory )

AutoIt:
    $oDeviceInfo.queryMemory( $totalMemory, $freeMemory ) -> None
```

### cv::cuda::DeviceInfo::freeMemory

```cpp
size_t cv::cuda::DeviceInfo::freeMemory()

AutoIt:
    $oDeviceInfo.freeMemory() -> retval
```

### cv::cuda::DeviceInfo::totalMemory

```cpp
size_t cv::cuda::DeviceInfo::totalMemory()

AutoIt:
    $oDeviceInfo.totalMemory() -> retval
```

### cv::cuda::DeviceInfo::isCompatible

```cpp
bool cv::cuda::DeviceInfo::isCompatible()

AutoIt:
    $oDeviceInfo.isCompatible() -> retval
```

## cv::Mat

### cv::Mat::create

```cpp
static cv::Mat cv::Mat::create()

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").create() -> <cv.Mat object>
```

```cpp
static cv::Mat cv::Mat::create( int rows,
                                int cols,
                                int type )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").create( $rows, $cols, $type ) -> <cv.Mat object>
```

```cpp
static cv::Mat cv::Mat::create( cv::Size size,
                                int      type )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").create( $size, $type ) -> <cv.Mat object>
```

```cpp
static cv::Mat cv::Mat::create( int        rows,
                                int        cols,
                                int        type,
                                cv::Scalar s )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").create( $rows, $cols, $type, $s ) -> <cv.Mat object>
```

```cpp
static cv::Mat cv::Mat::create( cv::Size   size,
                                int        type,
                                cv::Scalar s )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").create( $size, $type, $s ) -> <cv.Mat object>
```

```cpp
static cv::Mat cv::Mat::create( int    rows,
                                int    cols,
                                int    type,
                                void*  data,
                                size_t step = cv::Mat::AUTO_STEP )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").create( $rows, $cols, $type, $data[, $step] ) -> <cv.Mat object>
```

```cpp
static cv::Mat cv::Mat::create( cv::Mat m )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").create( $m ) -> <cv.Mat object>
```

```cpp
static cv::Mat cv::Mat::create( cv::Mat  src,
                                cv::Rect roi )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").create( $src, $roi ) -> <cv.Mat object>
```

### cv::Mat::row

```cpp
cv::Mat cv::Mat::row( int y )

AutoIt:
    $oMat.row( $y ) -> retval
```

### cv::Mat::col

```cpp
cv::Mat cv::Mat::col( int x )

AutoIt:
    $oMat.col( $x ) -> retval
```

### cv::Mat::rowRange

```cpp
cv::Mat cv::Mat::rowRange( int startrow,
                           int endrow )

AutoIt:
    $oMat.rowRange( $startrow, $endrow ) -> retval
```

```cpp
cv::Mat cv::Mat::rowRange( cv::Range r )

AutoIt:
    $oMat.rowRange( $r ) -> retval
```

### cv::Mat::colRange

```cpp
cv::Mat cv::Mat::colRange( int startcol,
                           int endcol )

AutoIt:
    $oMat.colRange( $startcol, $endcol ) -> retval
```

```cpp
cv::Mat cv::Mat::colRange( cv::Range r )

AutoIt:
    $oMat.colRange( $r ) -> retval
```

### cv::Mat::isContinuous

```cpp
bool cv::Mat::isContinuous()

AutoIt:
    $oMat.isContinuous() -> retval
```

### cv::Mat::isSubmatrix

```cpp
bool cv::Mat::isSubmatrix()

AutoIt:
    $oMat.isSubmatrix() -> retval
```

### cv::Mat::elemSize

```cpp
size_t cv::Mat::elemSize()

AutoIt:
    $oMat.elemSize() -> retval
```

### cv::Mat::elemSize1

```cpp
size_t cv::Mat::elemSize1()

AutoIt:
    $oMat.elemSize1() -> retval
```

### cv::Mat::type

```cpp
int cv::Mat::type()

AutoIt:
    $oMat.type() -> retval
```

### cv::Mat::depth

```cpp
int cv::Mat::depth()

AutoIt:
    $oMat.depth() -> retval
```

### cv::Mat::channels

```cpp
int cv::Mat::channels()

AutoIt:
    $oMat.channels() -> retval
```

### cv::Mat::step1

```cpp
size_t cv::Mat::step1( int i = 0 )

AutoIt:
    $oMat.step1( [$i] ) -> retval
```

### cv::Mat::empty

```cpp
bool cv::Mat::empty()

AutoIt:
    $oMat.empty() -> retval
```

### cv::Mat::total

```cpp
size_t cv::Mat::total()

AutoIt:
    $oMat.total() -> retval
```

```cpp
size_t cv::Mat::total( int startDim,
                       int endDim = INT_MAX )

AutoIt:
    $oMat.total( $startDim[, $endDim] ) -> retval
```

### cv::Mat::checkVector

```cpp
int cv::Mat::checkVector( int elemChannels,
                          int depth = -1,
                          int requireContinuous = true )

AutoIt:
    $oMat.checkVector( $elemChannels[, $depth[, $requireContinuous]] ) -> retval
```

### cv::Mat::ptr

```cpp
uchar* cv::Mat::ptr( int y = 0 )

AutoIt:
    $oMat.ptr( [$y] ) -> retval
```

```cpp
uchar* cv::Mat::ptr( int i0,
                     int i1 )

AutoIt:
    $oMat.ptr( $i0, $i1 ) -> retval
```

```cpp
uchar* cv::Mat::ptr( int i0,
                     int i1,
                     int i2 )

AutoIt:
    $oMat.ptr( $i0, $i1, $i2 ) -> retval
```

### cv::Mat::size

```cpp
cv::Size cv::Mat::size()

AutoIt:
    $oMat.size() -> retval
```

### cv::Mat::pop_back

```cpp
void cv::Mat::pop_back( size_t value )

AutoIt:
    $oMat.pop_back( $value ) -> None
```

### cv::Mat::push_back

```cpp
void cv::Mat::push_back( cv::Mat value )

AutoIt:
    $oMat.push_back( $value ) -> None
```

### cv::Mat::clone

```cpp
cv::Mat cv::Mat::clone()

AutoIt:
    $oMat.clone() -> retval
```

### cv::Mat::copy

```cpp
cv::Mat cv::Mat::copy()

AutoIt:
    $oMat.copy() -> retval
```

### cv::Mat::copyTo

```cpp
void cv::Mat::copyTo( _OutputArray m )

AutoIt:
    $oMat.copyTo( [$m] ) -> $m
```

```cpp
void cv::Mat::copyTo( _OutputArray m,
                      _InputArray  mask )

AutoIt:
    $oMat.copyTo( $mask[, $m] ) -> $m
```

### cv::Mat::setTo

```cpp
void cv::Mat::setTo( _InputArray value,
                     _InputArray mask = noArray() )

AutoIt:
    $oMat.setTo( $value[, $mask] ) -> None
```

### cv::Mat::convertTo

```cpp
void cv::Mat::convertTo( _OutputArray m,
                         int          rtype,
                         double       alpha = 1.0,
                         double       beta = 0.0 )

AutoIt:
    $oMat.convertTo( $rtype[, $m[, $alpha[, $beta]]] ) -> $m
```

### cv::Mat::reshape

```cpp
cv::Mat cv::Mat::reshape( int cn,
                          int rows = 0 )

AutoIt:
    $oMat.reshape( $cn[, $rows] ) -> retval
```

### cv::Mat::dot

```cpp
double cv::Mat::dot( _InputArray m )

AutoIt:
    $oMat.dot( $m ) -> retval
```

### cv::Mat::cross

```cpp
cv::Mat cv::Mat::cross( _InputArray m )

AutoIt:
    $oMat.cross( $m ) -> retval
```

### cv::Mat::diag

```cpp
cv::Mat cv::Mat::diag( int d = 0 )

AutoIt:
    $oMat.diag( [$d] ) -> retval
```

### cv::Mat::t

```cpp
cv::Mat cv::Mat::t()

AutoIt:
    $oMat.t() -> retval
```

### cv::Mat::convertToBitmap

```cpp
void* cv::Mat::convertToBitmap( bool copy = true )

AutoIt:
    $oMat.convertToBitmap( [$copy] ) -> retval
```

### cv::Mat::convertToShow

```cpp
cv::Mat cv::Mat::convertToShow( cv::Mat dst = Mat::zeros(this->__self->get()->rows, this->__self->get()->cols, CV_8UC3),
                                bool    toRGB = false )

AutoIt:
    $oMat.convertToShow( [$dst[, $toRGB]] ) -> retval, $dst
```

### cv::Mat::GdiplusResize

```cpp
cv::Mat cv::Mat::GdiplusResize( float newWidth,
                                float newHeight,
                                int   interpolation = 7 )

AutoIt:
    $oMat.GdiplusResize( $newWidth, $newHeight[, $interpolation] ) -> retval
```

### cv::Mat::PixelSearch

```cpp
_variant_t cv::Mat::PixelSearch( cv::Scalar color,
                                 int        left = 0,
                                 int        top = 0,
                                 int        right = this->__self->get()->cols - 1,
                                 int        bottom = this->__self->get()->rows - 1,
                                 uchar      shade_variation = 0,
                                 int        step = 1 )

AutoIt:
    $oMat.PixelSearch( $color[, $left[, $top[, $right[, $bottom[, $shade_variation[, $step]]]]]] ) -> retval
```

```cpp
_variant_t cv::Mat::PixelSearch( cv::Scalar color,
                                 cv::Rect   rect = Rect(0, 0, this->__self->get()->cols, this->__self->get()->rows),
                                 uchar      shade_variation = 0,
                                 int        step = 1 )

AutoIt:
    $oMat.PixelSearch( $color[, $rect[, $shade_variation[, $step]]] ) -> retval
```

### cv::Mat::PixelChecksum

```cpp
size_t cv::Mat::PixelChecksum( int left = 0,
                               int top = 0,
                               int right = this->__self->get()->cols - 1,
                               int bottom = this->__self->get()->rows - 1,
                               int step = 1,
                               int mode = 0 )

AutoIt:
    $oMat.PixelChecksum( [$left[, $top[, $right[, $bottom[, $step[, $mode]]]]]] ) -> retval
```

```cpp
size_t cv::Mat::PixelChecksum( cv::Rect rect = Rect(0, 0, this->__self->get()->cols, this->__self->get()->rows),
                               int      step = 1,
                               int      mode = 0 )

AutoIt:
    $oMat.PixelChecksum( [$rect[, $step[, $mode]]] ) -> retval
```

### cv::Mat::eye

```cpp
static cv::Mat cv::Mat::eye( int rows,
                             int cols,
                             int type )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").eye( $rows, $cols, $type ) -> retval
```

### cv::Mat::zeros

```cpp
static cv::Mat cv::Mat::zeros( int rows,
                               int cols,
                               int type )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").zeros( $rows, $cols, $type ) -> retval
```

```cpp
static cv::Mat cv::Mat::zeros( cv::Size size,
                               int      type )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").zeros( $size, $type ) -> retval
```

### cv::Mat::ones

```cpp
static cv::Mat cv::Mat::ones( int rows,
                              int cols,
                              int type )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").ones( $rows, $cols, $type ) -> retval
```

```cpp
static cv::Mat cv::Mat::ones( cv::Size size,
                              int      type )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").ones( $size, $type ) -> retval
```

### cv::Mat::createFromVec2b

```cpp
static cv::Mat cv::Mat::createFromVec2b( cv::Vec2b vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec2b( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec2b

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec2b( std::vector<cv::Vec2b> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec2b( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec3b

```cpp
static cv::Mat cv::Mat::createFromVec3b( cv::Vec3b vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec3b( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec3b

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec3b( std::vector<cv::Vec3b> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec3b( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec4b

```cpp
static cv::Mat cv::Mat::createFromVec4b( cv::Vec4b vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec4b( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec4b

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec4b( std::vector<cv::Vec4b> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec4b( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec2s

```cpp
static cv::Mat cv::Mat::createFromVec2s( cv::Vec2s vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec2s( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec2s

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec2s( std::vector<cv::Vec2s> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec2s( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec3s

```cpp
static cv::Mat cv::Mat::createFromVec3s( cv::Vec3s vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec3s( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec3s

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec3s( std::vector<cv::Vec3s> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec3s( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec4s

```cpp
static cv::Mat cv::Mat::createFromVec4s( cv::Vec4s vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec4s( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec4s

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec4s( std::vector<cv::Vec4s> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec4s( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec2w

```cpp
static cv::Mat cv::Mat::createFromVec2w( cv::Vec2w vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec2w( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec2w

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec2w( std::vector<cv::Vec2w> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec2w( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec3w

```cpp
static cv::Mat cv::Mat::createFromVec3w( cv::Vec3w vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec3w( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec3w

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec3w( std::vector<cv::Vec3w> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec3w( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec4w

```cpp
static cv::Mat cv::Mat::createFromVec4w( cv::Vec4w vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec4w( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec4w

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec4w( std::vector<cv::Vec4w> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec4w( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec2i

```cpp
static cv::Mat cv::Mat::createFromVec2i( cv::Vec2i vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec2i( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec2i

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec2i( std::vector<cv::Vec2i> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec2i( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec3i

```cpp
static cv::Mat cv::Mat::createFromVec3i( cv::Vec3i vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec3i( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec3i

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec3i( std::vector<cv::Vec3i> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec3i( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec4i

```cpp
static cv::Mat cv::Mat::createFromVec4i( cv::Vec4i vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec4i( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec4i

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec4i( std::vector<cv::Vec4i> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec4i( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec6i

```cpp
static cv::Mat cv::Mat::createFromVec6i( cv::Vec6i vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec6i( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec6i

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec6i( std::vector<cv::Vec6i> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec6i( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec8i

```cpp
static cv::Mat cv::Mat::createFromVec8i( cv::Vec8i vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec8i( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec8i

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec8i( std::vector<cv::Vec8i> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec8i( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec2f

```cpp
static cv::Mat cv::Mat::createFromVec2f( cv::Vec2f vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec2f( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec2f

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec2f( std::vector<cv::Vec2f> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec2f( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec3f

```cpp
static cv::Mat cv::Mat::createFromVec3f( cv::Vec3f vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec3f( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec3f

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec3f( std::vector<cv::Vec3f> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec3f( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec4f

```cpp
static cv::Mat cv::Mat::createFromVec4f( cv::Vec4f vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec4f( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec4f

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec4f( std::vector<cv::Vec4f> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec4f( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec6f

```cpp
static cv::Mat cv::Mat::createFromVec6f( cv::Vec6f vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec6f( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec6f

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec6f( std::vector<cv::Vec6f> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec6f( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec2d

```cpp
static cv::Mat cv::Mat::createFromVec2d( cv::Vec2d vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec2d( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec2d

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec2d( std::vector<cv::Vec2d> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec2d( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec3d

```cpp
static cv::Mat cv::Mat::createFromVec3d( cv::Vec3d vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec3d( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec3d

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec3d( std::vector<cv::Vec3d> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec3d( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec4d

```cpp
static cv::Mat cv::Mat::createFromVec4d( cv::Vec4d vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec4d( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec4d

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec4d( std::vector<cv::Vec4d> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec4d( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVec6d

```cpp
static cv::Mat cv::Mat::createFromVec6d( cv::Vec6d vec,
                                         bool      copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVec6d( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::createFromVectorOfVec6d

```cpp
static cv::Mat cv::Mat::createFromVectorOfVec6d( std::vector<cv::Vec6d> vec,
                                                 bool                   copyData = true )

AutoIt:
    _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec6d( $vec[, $copyData] ) -> <cv.Mat object>
```

### cv::Mat::Point_at

```cpp
cv::Point2d cv::Mat::Point_at( int i0 )

AutoIt:
    $oMat.Point_at( $i0 ) -> retval
```

```cpp
cv::Point2d cv::Mat::Point_at( int row,
                               int col )

AutoIt:
    $oMat.Point_at( $row, $col ) -> retval
```

```cpp
cv::Point2d cv::Mat::Point_at( int i0,
                               int i1,
                               int i2 )

AutoIt:
    $oMat.Point_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Point2d cv::Mat::Point_at( cv::Point pt )

AutoIt:
    $oMat.Point_at( $pt ) -> retval
```

### cv::Mat::at

```cpp
double cv::Mat::at( int i0 )

AutoIt:
    $oMat.at( $i0 ) -> retval
```

```cpp
double cv::Mat::at( int row,
                    int col )

AutoIt:
    $oMat.at( $row, $col ) -> retval
```

```cpp
double cv::Mat::at( int i0,
                    int i1,
                    int i2 )

AutoIt:
    $oMat.at( $i0, $i1, $i2 ) -> retval
```

```cpp
double cv::Mat::at( cv::Point pt )

AutoIt:
    $oMat.at( $pt ) -> retval
```

### cv::Mat::set_at

```cpp
void cv::Mat::set_at( int    i0,
                      double value )

AutoIt:
    $oMat.set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::set_at( int    row,
                      int    col,
                      double value )

AutoIt:
    $oMat.set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::set_at( int    i0,
                      int    i1,
                      int    i2,
                      double value )

AutoIt:
    $oMat.set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::set_at( cv::Point pt,
                      double    value )

AutoIt:
    $oMat.set_at( $pt, $value ) -> None
```

### cv::Mat::get_Item

```cpp
double cv::Mat::get_Item( int i0 )

AutoIt:
    $oMat.Item( $i0 ) -> retval
    cv.Mat( $i0 ) -> retval
```

```cpp
double cv::Mat::get_Item( int row,
                          int col )

AutoIt:
    $oMat.Item( $row, $col ) -> retval
    cv.Mat( $row, $col ) -> retval
```

```cpp
double cv::Mat::get_Item( int i0,
                          int i1,
                          int i2 )

AutoIt:
    $oMat.Item( $i0, $i1, $i2 ) -> retval
    cv.Mat( $i0, $i1, $i2 ) -> retval
```

```cpp
double cv::Mat::get_Item( cv::Point pt )

AutoIt:
    $oMat.Item( $pt ) -> retval
    cv.Mat( $pt ) -> retval
```

### cv::Mat::int_at

```cpp
int cv::Mat::int_at( int i0 )

AutoIt:
    $oMat.int_at( $i0 ) -> retval
```

```cpp
int cv::Mat::int_at( int row,
                     int col )

AutoIt:
    $oMat.int_at( $row, $col ) -> retval
```

```cpp
int cv::Mat::int_at( int i0,
                     int i1,
                     int i2 )

AutoIt:
    $oMat.int_at( $i0, $i1, $i2 ) -> retval
```

```cpp
int cv::Mat::int_at( cv::Point pt )

AutoIt:
    $oMat.int_at( $pt ) -> retval
```

### cv::Mat::int_set_at

```cpp
void cv::Mat::int_set_at( int i0,
                          int value )

AutoIt:
    $oMat.int_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::int_set_at( int row,
                          int col,
                          int value )

AutoIt:
    $oMat.int_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::int_set_at( int i0,
                          int i1,
                          int i2,
                          int value )

AutoIt:
    $oMat.int_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::int_set_at( cv::Point pt,
                          int       value )

AutoIt:
    $oMat.int_set_at( $pt, $value ) -> None
```

### cv::Mat::float_at

```cpp
float cv::Mat::float_at( int i0 )

AutoIt:
    $oMat.float_at( $i0 ) -> retval
```

```cpp
float cv::Mat::float_at( int row,
                         int col )

AutoIt:
    $oMat.float_at( $row, $col ) -> retval
```

```cpp
float cv::Mat::float_at( int i0,
                         int i1,
                         int i2 )

AutoIt:
    $oMat.float_at( $i0, $i1, $i2 ) -> retval
```

```cpp
float cv::Mat::float_at( cv::Point pt )

AutoIt:
    $oMat.float_at( $pt ) -> retval
```

### cv::Mat::float_set_at

```cpp
void cv::Mat::float_set_at( int   i0,
                            float value )

AutoIt:
    $oMat.float_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::float_set_at( int   row,
                            int   col,
                            float value )

AutoIt:
    $oMat.float_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::float_set_at( int   i0,
                            int   i1,
                            int   i2,
                            float value )

AutoIt:
    $oMat.float_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::float_set_at( cv::Point pt,
                            float     value )

AutoIt:
    $oMat.float_set_at( $pt, $value ) -> None
```

### cv::Mat::double_at

```cpp
double cv::Mat::double_at( int i0 )

AutoIt:
    $oMat.double_at( $i0 ) -> retval
```

```cpp
double cv::Mat::double_at( int row,
                           int col )

AutoIt:
    $oMat.double_at( $row, $col ) -> retval
```

```cpp
double cv::Mat::double_at( int i0,
                           int i1,
                           int i2 )

AutoIt:
    $oMat.double_at( $i0, $i1, $i2 ) -> retval
```

```cpp
double cv::Mat::double_at( cv::Point pt )

AutoIt:
    $oMat.double_at( $pt ) -> retval
```

### cv::Mat::double_set_at

```cpp
void cv::Mat::double_set_at( int    i0,
                             double value )

AutoIt:
    $oMat.double_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::double_set_at( int    row,
                             int    col,
                             double value )

AutoIt:
    $oMat.double_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::double_set_at( int    i0,
                             int    i1,
                             int    i2,
                             double value )

AutoIt:
    $oMat.double_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::double_set_at( cv::Point pt,
                             double    value )

AutoIt:
    $oMat.double_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec2b_at

```cpp
cv::Vec2b cv::Mat::Vec2b_at( int i0 )

AutoIt:
    $oMat.Vec2b_at( $i0 ) -> retval
```

```cpp
cv::Vec2b cv::Mat::Vec2b_at( int row,
                             int col )

AutoIt:
    $oMat.Vec2b_at( $row, $col ) -> retval
```

```cpp
cv::Vec2b cv::Mat::Vec2b_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec2b_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec2b cv::Mat::Vec2b_at( cv::Point pt )

AutoIt:
    $oMat.Vec2b_at( $pt ) -> retval
```

### cv::Mat::Vec2b_set_at

```cpp
void cv::Mat::Vec2b_set_at( int       i0,
                            cv::Vec2b value )

AutoIt:
    $oMat.Vec2b_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec2b_set_at( int       row,
                            int       col,
                            cv::Vec2b value )

AutoIt:
    $oMat.Vec2b_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec2b_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec2b value )

AutoIt:
    $oMat.Vec2b_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec2b_set_at( cv::Point pt,
                            cv::Vec2b value )

AutoIt:
    $oMat.Vec2b_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec3b_at

```cpp
cv::Vec3b cv::Mat::Vec3b_at( int i0 )

AutoIt:
    $oMat.Vec3b_at( $i0 ) -> retval
```

```cpp
cv::Vec3b cv::Mat::Vec3b_at( int row,
                             int col )

AutoIt:
    $oMat.Vec3b_at( $row, $col ) -> retval
```

```cpp
cv::Vec3b cv::Mat::Vec3b_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec3b_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec3b cv::Mat::Vec3b_at( cv::Point pt )

AutoIt:
    $oMat.Vec3b_at( $pt ) -> retval
```

### cv::Mat::Vec3b_set_at

```cpp
void cv::Mat::Vec3b_set_at( int       i0,
                            cv::Vec3b value )

AutoIt:
    $oMat.Vec3b_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec3b_set_at( int       row,
                            int       col,
                            cv::Vec3b value )

AutoIt:
    $oMat.Vec3b_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec3b_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec3b value )

AutoIt:
    $oMat.Vec3b_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec3b_set_at( cv::Point pt,
                            cv::Vec3b value )

AutoIt:
    $oMat.Vec3b_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec4b_at

```cpp
cv::Vec4b cv::Mat::Vec4b_at( int i0 )

AutoIt:
    $oMat.Vec4b_at( $i0 ) -> retval
```

```cpp
cv::Vec4b cv::Mat::Vec4b_at( int row,
                             int col )

AutoIt:
    $oMat.Vec4b_at( $row, $col ) -> retval
```

```cpp
cv::Vec4b cv::Mat::Vec4b_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec4b_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec4b cv::Mat::Vec4b_at( cv::Point pt )

AutoIt:
    $oMat.Vec4b_at( $pt ) -> retval
```

### cv::Mat::Vec4b_set_at

```cpp
void cv::Mat::Vec4b_set_at( int       i0,
                            cv::Vec4b value )

AutoIt:
    $oMat.Vec4b_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec4b_set_at( int       row,
                            int       col,
                            cv::Vec4b value )

AutoIt:
    $oMat.Vec4b_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec4b_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec4b value )

AutoIt:
    $oMat.Vec4b_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec4b_set_at( cv::Point pt,
                            cv::Vec4b value )

AutoIt:
    $oMat.Vec4b_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec2s_at

```cpp
cv::Vec2s cv::Mat::Vec2s_at( int i0 )

AutoIt:
    $oMat.Vec2s_at( $i0 ) -> retval
```

```cpp
cv::Vec2s cv::Mat::Vec2s_at( int row,
                             int col )

AutoIt:
    $oMat.Vec2s_at( $row, $col ) -> retval
```

```cpp
cv::Vec2s cv::Mat::Vec2s_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec2s_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec2s cv::Mat::Vec2s_at( cv::Point pt )

AutoIt:
    $oMat.Vec2s_at( $pt ) -> retval
```

### cv::Mat::Vec2s_set_at

```cpp
void cv::Mat::Vec2s_set_at( int       i0,
                            cv::Vec2s value )

AutoIt:
    $oMat.Vec2s_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec2s_set_at( int       row,
                            int       col,
                            cv::Vec2s value )

AutoIt:
    $oMat.Vec2s_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec2s_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec2s value )

AutoIt:
    $oMat.Vec2s_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec2s_set_at( cv::Point pt,
                            cv::Vec2s value )

AutoIt:
    $oMat.Vec2s_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec3s_at

```cpp
cv::Vec3s cv::Mat::Vec3s_at( int i0 )

AutoIt:
    $oMat.Vec3s_at( $i0 ) -> retval
```

```cpp
cv::Vec3s cv::Mat::Vec3s_at( int row,
                             int col )

AutoIt:
    $oMat.Vec3s_at( $row, $col ) -> retval
```

```cpp
cv::Vec3s cv::Mat::Vec3s_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec3s_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec3s cv::Mat::Vec3s_at( cv::Point pt )

AutoIt:
    $oMat.Vec3s_at( $pt ) -> retval
```

### cv::Mat::Vec3s_set_at

```cpp
void cv::Mat::Vec3s_set_at( int       i0,
                            cv::Vec3s value )

AutoIt:
    $oMat.Vec3s_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec3s_set_at( int       row,
                            int       col,
                            cv::Vec3s value )

AutoIt:
    $oMat.Vec3s_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec3s_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec3s value )

AutoIt:
    $oMat.Vec3s_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec3s_set_at( cv::Point pt,
                            cv::Vec3s value )

AutoIt:
    $oMat.Vec3s_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec4s_at

```cpp
cv::Vec4s cv::Mat::Vec4s_at( int i0 )

AutoIt:
    $oMat.Vec4s_at( $i0 ) -> retval
```

```cpp
cv::Vec4s cv::Mat::Vec4s_at( int row,
                             int col )

AutoIt:
    $oMat.Vec4s_at( $row, $col ) -> retval
```

```cpp
cv::Vec4s cv::Mat::Vec4s_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec4s_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec4s cv::Mat::Vec4s_at( cv::Point pt )

AutoIt:
    $oMat.Vec4s_at( $pt ) -> retval
```

### cv::Mat::Vec4s_set_at

```cpp
void cv::Mat::Vec4s_set_at( int       i0,
                            cv::Vec4s value )

AutoIt:
    $oMat.Vec4s_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec4s_set_at( int       row,
                            int       col,
                            cv::Vec4s value )

AutoIt:
    $oMat.Vec4s_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec4s_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec4s value )

AutoIt:
    $oMat.Vec4s_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec4s_set_at( cv::Point pt,
                            cv::Vec4s value )

AutoIt:
    $oMat.Vec4s_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec2w_at

```cpp
cv::Vec2w cv::Mat::Vec2w_at( int i0 )

AutoIt:
    $oMat.Vec2w_at( $i0 ) -> retval
```

```cpp
cv::Vec2w cv::Mat::Vec2w_at( int row,
                             int col )

AutoIt:
    $oMat.Vec2w_at( $row, $col ) -> retval
```

```cpp
cv::Vec2w cv::Mat::Vec2w_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec2w_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec2w cv::Mat::Vec2w_at( cv::Point pt )

AutoIt:
    $oMat.Vec2w_at( $pt ) -> retval
```

### cv::Mat::Vec2w_set_at

```cpp
void cv::Mat::Vec2w_set_at( int       i0,
                            cv::Vec2w value )

AutoIt:
    $oMat.Vec2w_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec2w_set_at( int       row,
                            int       col,
                            cv::Vec2w value )

AutoIt:
    $oMat.Vec2w_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec2w_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec2w value )

AutoIt:
    $oMat.Vec2w_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec2w_set_at( cv::Point pt,
                            cv::Vec2w value )

AutoIt:
    $oMat.Vec2w_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec3w_at

```cpp
cv::Vec3w cv::Mat::Vec3w_at( int i0 )

AutoIt:
    $oMat.Vec3w_at( $i0 ) -> retval
```

```cpp
cv::Vec3w cv::Mat::Vec3w_at( int row,
                             int col )

AutoIt:
    $oMat.Vec3w_at( $row, $col ) -> retval
```

```cpp
cv::Vec3w cv::Mat::Vec3w_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec3w_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec3w cv::Mat::Vec3w_at( cv::Point pt )

AutoIt:
    $oMat.Vec3w_at( $pt ) -> retval
```

### cv::Mat::Vec3w_set_at

```cpp
void cv::Mat::Vec3w_set_at( int       i0,
                            cv::Vec3w value )

AutoIt:
    $oMat.Vec3w_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec3w_set_at( int       row,
                            int       col,
                            cv::Vec3w value )

AutoIt:
    $oMat.Vec3w_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec3w_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec3w value )

AutoIt:
    $oMat.Vec3w_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec3w_set_at( cv::Point pt,
                            cv::Vec3w value )

AutoIt:
    $oMat.Vec3w_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec4w_at

```cpp
cv::Vec4w cv::Mat::Vec4w_at( int i0 )

AutoIt:
    $oMat.Vec4w_at( $i0 ) -> retval
```

```cpp
cv::Vec4w cv::Mat::Vec4w_at( int row,
                             int col )

AutoIt:
    $oMat.Vec4w_at( $row, $col ) -> retval
```

```cpp
cv::Vec4w cv::Mat::Vec4w_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec4w_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec4w cv::Mat::Vec4w_at( cv::Point pt )

AutoIt:
    $oMat.Vec4w_at( $pt ) -> retval
```

### cv::Mat::Vec4w_set_at

```cpp
void cv::Mat::Vec4w_set_at( int       i0,
                            cv::Vec4w value )

AutoIt:
    $oMat.Vec4w_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec4w_set_at( int       row,
                            int       col,
                            cv::Vec4w value )

AutoIt:
    $oMat.Vec4w_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec4w_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec4w value )

AutoIt:
    $oMat.Vec4w_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec4w_set_at( cv::Point pt,
                            cv::Vec4w value )

AutoIt:
    $oMat.Vec4w_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec2i_at

```cpp
cv::Vec2i cv::Mat::Vec2i_at( int i0 )

AutoIt:
    $oMat.Vec2i_at( $i0 ) -> retval
```

```cpp
cv::Vec2i cv::Mat::Vec2i_at( int row,
                             int col )

AutoIt:
    $oMat.Vec2i_at( $row, $col ) -> retval
```

```cpp
cv::Vec2i cv::Mat::Vec2i_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec2i_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec2i cv::Mat::Vec2i_at( cv::Point pt )

AutoIt:
    $oMat.Vec2i_at( $pt ) -> retval
```

### cv::Mat::Vec2i_set_at

```cpp
void cv::Mat::Vec2i_set_at( int       i0,
                            cv::Vec2i value )

AutoIt:
    $oMat.Vec2i_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec2i_set_at( int       row,
                            int       col,
                            cv::Vec2i value )

AutoIt:
    $oMat.Vec2i_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec2i_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec2i value )

AutoIt:
    $oMat.Vec2i_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec2i_set_at( cv::Point pt,
                            cv::Vec2i value )

AutoIt:
    $oMat.Vec2i_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec3i_at

```cpp
cv::Vec3i cv::Mat::Vec3i_at( int i0 )

AutoIt:
    $oMat.Vec3i_at( $i0 ) -> retval
```

```cpp
cv::Vec3i cv::Mat::Vec3i_at( int row,
                             int col )

AutoIt:
    $oMat.Vec3i_at( $row, $col ) -> retval
```

```cpp
cv::Vec3i cv::Mat::Vec3i_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec3i_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec3i cv::Mat::Vec3i_at( cv::Point pt )

AutoIt:
    $oMat.Vec3i_at( $pt ) -> retval
```

### cv::Mat::Vec3i_set_at

```cpp
void cv::Mat::Vec3i_set_at( int       i0,
                            cv::Vec3i value )

AutoIt:
    $oMat.Vec3i_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec3i_set_at( int       row,
                            int       col,
                            cv::Vec3i value )

AutoIt:
    $oMat.Vec3i_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec3i_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec3i value )

AutoIt:
    $oMat.Vec3i_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec3i_set_at( cv::Point pt,
                            cv::Vec3i value )

AutoIt:
    $oMat.Vec3i_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec4i_at

```cpp
cv::Vec4i cv::Mat::Vec4i_at( int i0 )

AutoIt:
    $oMat.Vec4i_at( $i0 ) -> retval
```

```cpp
cv::Vec4i cv::Mat::Vec4i_at( int row,
                             int col )

AutoIt:
    $oMat.Vec4i_at( $row, $col ) -> retval
```

```cpp
cv::Vec4i cv::Mat::Vec4i_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec4i_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec4i cv::Mat::Vec4i_at( cv::Point pt )

AutoIt:
    $oMat.Vec4i_at( $pt ) -> retval
```

### cv::Mat::Vec4i_set_at

```cpp
void cv::Mat::Vec4i_set_at( int       i0,
                            cv::Vec4i value )

AutoIt:
    $oMat.Vec4i_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec4i_set_at( int       row,
                            int       col,
                            cv::Vec4i value )

AutoIt:
    $oMat.Vec4i_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec4i_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec4i value )

AutoIt:
    $oMat.Vec4i_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec4i_set_at( cv::Point pt,
                            cv::Vec4i value )

AutoIt:
    $oMat.Vec4i_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec6i_at

```cpp
cv::Vec6i cv::Mat::Vec6i_at( int i0 )

AutoIt:
    $oMat.Vec6i_at( $i0 ) -> retval
```

```cpp
cv::Vec6i cv::Mat::Vec6i_at( int row,
                             int col )

AutoIt:
    $oMat.Vec6i_at( $row, $col ) -> retval
```

```cpp
cv::Vec6i cv::Mat::Vec6i_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec6i_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec6i cv::Mat::Vec6i_at( cv::Point pt )

AutoIt:
    $oMat.Vec6i_at( $pt ) -> retval
```

### cv::Mat::Vec6i_set_at

```cpp
void cv::Mat::Vec6i_set_at( int       i0,
                            cv::Vec6i value )

AutoIt:
    $oMat.Vec6i_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec6i_set_at( int       row,
                            int       col,
                            cv::Vec6i value )

AutoIt:
    $oMat.Vec6i_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec6i_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec6i value )

AutoIt:
    $oMat.Vec6i_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec6i_set_at( cv::Point pt,
                            cv::Vec6i value )

AutoIt:
    $oMat.Vec6i_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec8i_at

```cpp
cv::Vec8i cv::Mat::Vec8i_at( int i0 )

AutoIt:
    $oMat.Vec8i_at( $i0 ) -> retval
```

```cpp
cv::Vec8i cv::Mat::Vec8i_at( int row,
                             int col )

AutoIt:
    $oMat.Vec8i_at( $row, $col ) -> retval
```

```cpp
cv::Vec8i cv::Mat::Vec8i_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec8i_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec8i cv::Mat::Vec8i_at( cv::Point pt )

AutoIt:
    $oMat.Vec8i_at( $pt ) -> retval
```

### cv::Mat::Vec8i_set_at

```cpp
void cv::Mat::Vec8i_set_at( int       i0,
                            cv::Vec8i value )

AutoIt:
    $oMat.Vec8i_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec8i_set_at( int       row,
                            int       col,
                            cv::Vec8i value )

AutoIt:
    $oMat.Vec8i_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec8i_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec8i value )

AutoIt:
    $oMat.Vec8i_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec8i_set_at( cv::Point pt,
                            cv::Vec8i value )

AutoIt:
    $oMat.Vec8i_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec2f_at

```cpp
cv::Vec2f cv::Mat::Vec2f_at( int i0 )

AutoIt:
    $oMat.Vec2f_at( $i0 ) -> retval
```

```cpp
cv::Vec2f cv::Mat::Vec2f_at( int row,
                             int col )

AutoIt:
    $oMat.Vec2f_at( $row, $col ) -> retval
```

```cpp
cv::Vec2f cv::Mat::Vec2f_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec2f_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec2f cv::Mat::Vec2f_at( cv::Point pt )

AutoIt:
    $oMat.Vec2f_at( $pt ) -> retval
```

### cv::Mat::Vec2f_set_at

```cpp
void cv::Mat::Vec2f_set_at( int       i0,
                            cv::Vec2f value )

AutoIt:
    $oMat.Vec2f_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec2f_set_at( int       row,
                            int       col,
                            cv::Vec2f value )

AutoIt:
    $oMat.Vec2f_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec2f_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec2f value )

AutoIt:
    $oMat.Vec2f_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec2f_set_at( cv::Point pt,
                            cv::Vec2f value )

AutoIt:
    $oMat.Vec2f_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec3f_at

```cpp
cv::Vec3f cv::Mat::Vec3f_at( int i0 )

AutoIt:
    $oMat.Vec3f_at( $i0 ) -> retval
```

```cpp
cv::Vec3f cv::Mat::Vec3f_at( int row,
                             int col )

AutoIt:
    $oMat.Vec3f_at( $row, $col ) -> retval
```

```cpp
cv::Vec3f cv::Mat::Vec3f_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec3f_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec3f cv::Mat::Vec3f_at( cv::Point pt )

AutoIt:
    $oMat.Vec3f_at( $pt ) -> retval
```

### cv::Mat::Vec3f_set_at

```cpp
void cv::Mat::Vec3f_set_at( int       i0,
                            cv::Vec3f value )

AutoIt:
    $oMat.Vec3f_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec3f_set_at( int       row,
                            int       col,
                            cv::Vec3f value )

AutoIt:
    $oMat.Vec3f_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec3f_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec3f value )

AutoIt:
    $oMat.Vec3f_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec3f_set_at( cv::Point pt,
                            cv::Vec3f value )

AutoIt:
    $oMat.Vec3f_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec4f_at

```cpp
cv::Vec4f cv::Mat::Vec4f_at( int i0 )

AutoIt:
    $oMat.Vec4f_at( $i0 ) -> retval
```

```cpp
cv::Vec4f cv::Mat::Vec4f_at( int row,
                             int col )

AutoIt:
    $oMat.Vec4f_at( $row, $col ) -> retval
```

```cpp
cv::Vec4f cv::Mat::Vec4f_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec4f_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec4f cv::Mat::Vec4f_at( cv::Point pt )

AutoIt:
    $oMat.Vec4f_at( $pt ) -> retval
```

### cv::Mat::Vec4f_set_at

```cpp
void cv::Mat::Vec4f_set_at( int       i0,
                            cv::Vec4f value )

AutoIt:
    $oMat.Vec4f_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec4f_set_at( int       row,
                            int       col,
                            cv::Vec4f value )

AutoIt:
    $oMat.Vec4f_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec4f_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec4f value )

AutoIt:
    $oMat.Vec4f_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec4f_set_at( cv::Point pt,
                            cv::Vec4f value )

AutoIt:
    $oMat.Vec4f_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec6f_at

```cpp
cv::Vec6f cv::Mat::Vec6f_at( int i0 )

AutoIt:
    $oMat.Vec6f_at( $i0 ) -> retval
```

```cpp
cv::Vec6f cv::Mat::Vec6f_at( int row,
                             int col )

AutoIt:
    $oMat.Vec6f_at( $row, $col ) -> retval
```

```cpp
cv::Vec6f cv::Mat::Vec6f_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec6f_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec6f cv::Mat::Vec6f_at( cv::Point pt )

AutoIt:
    $oMat.Vec6f_at( $pt ) -> retval
```

### cv::Mat::Vec6f_set_at

```cpp
void cv::Mat::Vec6f_set_at( int       i0,
                            cv::Vec6f value )

AutoIt:
    $oMat.Vec6f_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec6f_set_at( int       row,
                            int       col,
                            cv::Vec6f value )

AutoIt:
    $oMat.Vec6f_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec6f_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec6f value )

AutoIt:
    $oMat.Vec6f_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec6f_set_at( cv::Point pt,
                            cv::Vec6f value )

AutoIt:
    $oMat.Vec6f_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec2d_at

```cpp
cv::Vec2d cv::Mat::Vec2d_at( int i0 )

AutoIt:
    $oMat.Vec2d_at( $i0 ) -> retval
```

```cpp
cv::Vec2d cv::Mat::Vec2d_at( int row,
                             int col )

AutoIt:
    $oMat.Vec2d_at( $row, $col ) -> retval
```

```cpp
cv::Vec2d cv::Mat::Vec2d_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec2d_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec2d cv::Mat::Vec2d_at( cv::Point pt )

AutoIt:
    $oMat.Vec2d_at( $pt ) -> retval
```

### cv::Mat::Vec2d_set_at

```cpp
void cv::Mat::Vec2d_set_at( int       i0,
                            cv::Vec2d value )

AutoIt:
    $oMat.Vec2d_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec2d_set_at( int       row,
                            int       col,
                            cv::Vec2d value )

AutoIt:
    $oMat.Vec2d_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec2d_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec2d value )

AutoIt:
    $oMat.Vec2d_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec2d_set_at( cv::Point pt,
                            cv::Vec2d value )

AutoIt:
    $oMat.Vec2d_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec3d_at

```cpp
cv::Vec3d cv::Mat::Vec3d_at( int i0 )

AutoIt:
    $oMat.Vec3d_at( $i0 ) -> retval
```

```cpp
cv::Vec3d cv::Mat::Vec3d_at( int row,
                             int col )

AutoIt:
    $oMat.Vec3d_at( $row, $col ) -> retval
```

```cpp
cv::Vec3d cv::Mat::Vec3d_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec3d_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec3d cv::Mat::Vec3d_at( cv::Point pt )

AutoIt:
    $oMat.Vec3d_at( $pt ) -> retval
```

### cv::Mat::Vec3d_set_at

```cpp
void cv::Mat::Vec3d_set_at( int       i0,
                            cv::Vec3d value )

AutoIt:
    $oMat.Vec3d_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec3d_set_at( int       row,
                            int       col,
                            cv::Vec3d value )

AutoIt:
    $oMat.Vec3d_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec3d_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec3d value )

AutoIt:
    $oMat.Vec3d_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec3d_set_at( cv::Point pt,
                            cv::Vec3d value )

AutoIt:
    $oMat.Vec3d_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec4d_at

```cpp
cv::Vec4d cv::Mat::Vec4d_at( int i0 )

AutoIt:
    $oMat.Vec4d_at( $i0 ) -> retval
```

```cpp
cv::Vec4d cv::Mat::Vec4d_at( int row,
                             int col )

AutoIt:
    $oMat.Vec4d_at( $row, $col ) -> retval
```

```cpp
cv::Vec4d cv::Mat::Vec4d_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec4d_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec4d cv::Mat::Vec4d_at( cv::Point pt )

AutoIt:
    $oMat.Vec4d_at( $pt ) -> retval
```

### cv::Mat::Vec4d_set_at

```cpp
void cv::Mat::Vec4d_set_at( int       i0,
                            cv::Vec4d value )

AutoIt:
    $oMat.Vec4d_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec4d_set_at( int       row,
                            int       col,
                            cv::Vec4d value )

AutoIt:
    $oMat.Vec4d_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec4d_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec4d value )

AutoIt:
    $oMat.Vec4d_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec4d_set_at( cv::Point pt,
                            cv::Vec4d value )

AutoIt:
    $oMat.Vec4d_set_at( $pt, $value ) -> None
```

### cv::Mat::Vec6d_at

```cpp
cv::Vec6d cv::Mat::Vec6d_at( int i0 )

AutoIt:
    $oMat.Vec6d_at( $i0 ) -> retval
```

```cpp
cv::Vec6d cv::Mat::Vec6d_at( int row,
                             int col )

AutoIt:
    $oMat.Vec6d_at( $row, $col ) -> retval
```

```cpp
cv::Vec6d cv::Mat::Vec6d_at( int i0,
                             int i1,
                             int i2 )

AutoIt:
    $oMat.Vec6d_at( $i0, $i1, $i2 ) -> retval
```

```cpp
cv::Vec6d cv::Mat::Vec6d_at( cv::Point pt )

AutoIt:
    $oMat.Vec6d_at( $pt ) -> retval
```

### cv::Mat::Vec6d_set_at

```cpp
void cv::Mat::Vec6d_set_at( int       i0,
                            cv::Vec6d value )

AutoIt:
    $oMat.Vec6d_set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::Vec6d_set_at( int       row,
                            int       col,
                            cv::Vec6d value )

AutoIt:
    $oMat.Vec6d_set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::Vec6d_set_at( int       i0,
                            int       i1,
                            int       i2,
                            cv::Vec6d value )

AutoIt:
    $oMat.Vec6d_set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::Vec6d_set_at( cv::Point pt,
                            cv::Vec6d value )

AutoIt:
    $oMat.Vec6d_set_at( $pt, $value ) -> None
```

## cv::UMat

### cv::UMat::create

```cpp
static cv::UMat cv::UMat::create()

AutoIt:
    _OpenCV_ObjCreate("cv.UMat").create() -> <cv.UMat object>
```

```cpp
static cv::UMat cv::UMat::create( cv::UMat m )

AutoIt:
    _OpenCV_ObjCreate("cv.UMat").create( $m ) -> <cv.UMat object>
```

```cpp
static cv::UMat cv::UMat::create( int usageFlags = cv::USAGE_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv.UMat").create( [$usageFlags] ) -> <cv.UMat object>
```

```cpp
static cv::UMat cv::UMat::create( int rows,
                                  int cols,
                                  int type,
                                  int usageFlags = cv::USAGE_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv.UMat").create( $rows, $cols, $type[, $usageFlags] ) -> <cv.UMat object>
```

```cpp
static cv::UMat cv::UMat::create( int        rows,
                                  int        cols,
                                  int        type,
                                  cv::Scalar s,
                                  int        usageFlags = cv::USAGE_DEFAULT )

AutoIt:
    _OpenCV_ObjCreate("cv.UMat").create( $rows, $cols, $type, $s[, $usageFlags] ) -> <cv.UMat object>
```

### cv::UMat::getMat

```cpp
cv::Mat cv::UMat::getMat( int access )

AutoIt:
    $oUMat.getMat( $access ) -> retval
```

## cv::ocl

### cv::ocl::haveOpenCL

```cpp
bool cv::ocl::haveOpenCL()

AutoIt:
    _OpenCV_ObjCreate("cv.ocl").haveOpenCL() -> retval
```

### cv::ocl::useOpenCL

```cpp
bool cv::ocl::useOpenCL()

AutoIt:
    _OpenCV_ObjCreate("cv.ocl").useOpenCL() -> retval
```

### cv::ocl::haveAmdBlas

```cpp
bool cv::ocl::haveAmdBlas()

AutoIt:
    _OpenCV_ObjCreate("cv.ocl").haveAmdBlas() -> retval
```

### cv::ocl::haveAmdFft

```cpp
bool cv::ocl::haveAmdFft()

AutoIt:
    _OpenCV_ObjCreate("cv.ocl").haveAmdFft() -> retval
```

### cv::ocl::setUseOpenCL

```cpp
void cv::ocl::setUseOpenCL( bool flag )

AutoIt:
    _OpenCV_ObjCreate("cv.ocl").setUseOpenCL( $flag ) -> None
```

### cv::ocl::finish

```cpp
void cv::ocl::finish()

AutoIt:
    _OpenCV_ObjCreate("cv.ocl").finish() -> None
```

## cv::ocl::Device

### cv::ocl::Device::create

```cpp
static cv::ocl::Device cv::ocl::Device::create()

AutoIt:
    _OpenCV_ObjCreate("cv.ocl.Device").create() -> <cv.ocl.Device object>
```

### cv::ocl::Device::name

```cpp
std::string cv::ocl::Device::name()

AutoIt:
    $oDevice.name() -> retval
```

### cv::ocl::Device::extensions

```cpp
std::string cv::ocl::Device::extensions()

AutoIt:
    $oDevice.extensions() -> retval
```

### cv::ocl::Device::isExtensionSupported

```cpp
bool cv::ocl::Device::isExtensionSupported( const std::string& extensionName )

AutoIt:
    $oDevice.isExtensionSupported( $extensionName ) -> retval
```

### cv::ocl::Device::version

```cpp
std::string cv::ocl::Device::version()

AutoIt:
    $oDevice.version() -> retval
```

### cv::ocl::Device::vendorName

```cpp
std::string cv::ocl::Device::vendorName()

AutoIt:
    $oDevice.vendorName() -> retval
```

### cv::ocl::Device::OpenCL_C_Version

```cpp
std::string cv::ocl::Device::OpenCL_C_Version()

AutoIt:
    $oDevice.OpenCL_C_Version() -> retval
```

### cv::ocl::Device::OpenCLVersion

```cpp
std::string cv::ocl::Device::OpenCLVersion()

AutoIt:
    $oDevice.OpenCLVersion() -> retval
```

### cv::ocl::Device::deviceVersionMajor

```cpp
int cv::ocl::Device::deviceVersionMajor()

AutoIt:
    $oDevice.deviceVersionMajor() -> retval
```

### cv::ocl::Device::deviceVersionMinor

```cpp
int cv::ocl::Device::deviceVersionMinor()

AutoIt:
    $oDevice.deviceVersionMinor() -> retval
```

### cv::ocl::Device::driverVersion

```cpp
std::string cv::ocl::Device::driverVersion()

AutoIt:
    $oDevice.driverVersion() -> retval
```

### cv::ocl::Device::type

```cpp
int cv::ocl::Device::type()

AutoIt:
    $oDevice.type() -> retval
```

### cv::ocl::Device::addressBits

```cpp
int cv::ocl::Device::addressBits()

AutoIt:
    $oDevice.addressBits() -> retval
```

### cv::ocl::Device::available

```cpp
bool cv::ocl::Device::available()

AutoIt:
    $oDevice.available() -> retval
```

### cv::ocl::Device::compilerAvailable

```cpp
bool cv::ocl::Device::compilerAvailable()

AutoIt:
    $oDevice.compilerAvailable() -> retval
```

### cv::ocl::Device::linkerAvailable

```cpp
bool cv::ocl::Device::linkerAvailable()

AutoIt:
    $oDevice.linkerAvailable() -> retval
```

### cv::ocl::Device::doubleFPConfig

```cpp
int cv::ocl::Device::doubleFPConfig()

AutoIt:
    $oDevice.doubleFPConfig() -> retval
```

### cv::ocl::Device::singleFPConfig

```cpp
int cv::ocl::Device::singleFPConfig()

AutoIt:
    $oDevice.singleFPConfig() -> retval
```

### cv::ocl::Device::halfFPConfig

```cpp
int cv::ocl::Device::halfFPConfig()

AutoIt:
    $oDevice.halfFPConfig() -> retval
```

### cv::ocl::Device::endianLittle

```cpp
bool cv::ocl::Device::endianLittle()

AutoIt:
    $oDevice.endianLittle() -> retval
```

### cv::ocl::Device::errorCorrectionSupport

```cpp
bool cv::ocl::Device::errorCorrectionSupport()

AutoIt:
    $oDevice.errorCorrectionSupport() -> retval
```

### cv::ocl::Device::executionCapabilities

```cpp
int cv::ocl::Device::executionCapabilities()

AutoIt:
    $oDevice.executionCapabilities() -> retval
```

### cv::ocl::Device::globalMemCacheSize

```cpp
size_t cv::ocl::Device::globalMemCacheSize()

AutoIt:
    $oDevice.globalMemCacheSize() -> retval
```

### cv::ocl::Device::globalMemCacheType

```cpp
int cv::ocl::Device::globalMemCacheType()

AutoIt:
    $oDevice.globalMemCacheType() -> retval
```

### cv::ocl::Device::globalMemCacheLineSize

```cpp
int cv::ocl::Device::globalMemCacheLineSize()

AutoIt:
    $oDevice.globalMemCacheLineSize() -> retval
```

### cv::ocl::Device::globalMemSize

```cpp
size_t cv::ocl::Device::globalMemSize()

AutoIt:
    $oDevice.globalMemSize() -> retval
```

### cv::ocl::Device::localMemSize

```cpp
size_t cv::ocl::Device::localMemSize()

AutoIt:
    $oDevice.localMemSize() -> retval
```

### cv::ocl::Device::localMemType

```cpp
int cv::ocl::Device::localMemType()

AutoIt:
    $oDevice.localMemType() -> retval
```

### cv::ocl::Device::hostUnifiedMemory

```cpp
bool cv::ocl::Device::hostUnifiedMemory()

AutoIt:
    $oDevice.hostUnifiedMemory() -> retval
```

### cv::ocl::Device::imageSupport

```cpp
bool cv::ocl::Device::imageSupport()

AutoIt:
    $oDevice.imageSupport() -> retval
```

### cv::ocl::Device::imageFromBufferSupport

```cpp
bool cv::ocl::Device::imageFromBufferSupport()

AutoIt:
    $oDevice.imageFromBufferSupport() -> retval
```

### cv::ocl::Device::intelSubgroupsSupport

```cpp
bool cv::ocl::Device::intelSubgroupsSupport()

AutoIt:
    $oDevice.intelSubgroupsSupport() -> retval
```

### cv::ocl::Device::image2DMaxWidth

```cpp
size_t cv::ocl::Device::image2DMaxWidth()

AutoIt:
    $oDevice.image2DMaxWidth() -> retval
```

### cv::ocl::Device::image2DMaxHeight

```cpp
size_t cv::ocl::Device::image2DMaxHeight()

AutoIt:
    $oDevice.image2DMaxHeight() -> retval
```

### cv::ocl::Device::image3DMaxWidth

```cpp
size_t cv::ocl::Device::image3DMaxWidth()

AutoIt:
    $oDevice.image3DMaxWidth() -> retval
```

### cv::ocl::Device::image3DMaxHeight

```cpp
size_t cv::ocl::Device::image3DMaxHeight()

AutoIt:
    $oDevice.image3DMaxHeight() -> retval
```

### cv::ocl::Device::image3DMaxDepth

```cpp
size_t cv::ocl::Device::image3DMaxDepth()

AutoIt:
    $oDevice.image3DMaxDepth() -> retval
```

### cv::ocl::Device::imageMaxBufferSize

```cpp
size_t cv::ocl::Device::imageMaxBufferSize()

AutoIt:
    $oDevice.imageMaxBufferSize() -> retval
```

### cv::ocl::Device::imageMaxArraySize

```cpp
size_t cv::ocl::Device::imageMaxArraySize()

AutoIt:
    $oDevice.imageMaxArraySize() -> retval
```

### cv::ocl::Device::vendorID

```cpp
int cv::ocl::Device::vendorID()

AutoIt:
    $oDevice.vendorID() -> retval
```

### cv::ocl::Device::isAMD

```cpp
bool cv::ocl::Device::isAMD()

AutoIt:
    $oDevice.isAMD() -> retval
```

### cv::ocl::Device::isIntel

```cpp
bool cv::ocl::Device::isIntel()

AutoIt:
    $oDevice.isIntel() -> retval
```

### cv::ocl::Device::isNVidia

```cpp
bool cv::ocl::Device::isNVidia()

AutoIt:
    $oDevice.isNVidia() -> retval
```

### cv::ocl::Device::maxClockFrequency

```cpp
int cv::ocl::Device::maxClockFrequency()

AutoIt:
    $oDevice.maxClockFrequency() -> retval
```

### cv::ocl::Device::maxComputeUnits

```cpp
int cv::ocl::Device::maxComputeUnits()

AutoIt:
    $oDevice.maxComputeUnits() -> retval
```

### cv::ocl::Device::maxConstantArgs

```cpp
int cv::ocl::Device::maxConstantArgs()

AutoIt:
    $oDevice.maxConstantArgs() -> retval
```

### cv::ocl::Device::maxConstantBufferSize

```cpp
size_t cv::ocl::Device::maxConstantBufferSize()

AutoIt:
    $oDevice.maxConstantBufferSize() -> retval
```

### cv::ocl::Device::maxMemAllocSize

```cpp
size_t cv::ocl::Device::maxMemAllocSize()

AutoIt:
    $oDevice.maxMemAllocSize() -> retval
```

### cv::ocl::Device::maxParameterSize

```cpp
size_t cv::ocl::Device::maxParameterSize()

AutoIt:
    $oDevice.maxParameterSize() -> retval
```

### cv::ocl::Device::maxReadImageArgs

```cpp
int cv::ocl::Device::maxReadImageArgs()

AutoIt:
    $oDevice.maxReadImageArgs() -> retval
```

### cv::ocl::Device::maxWriteImageArgs

```cpp
int cv::ocl::Device::maxWriteImageArgs()

AutoIt:
    $oDevice.maxWriteImageArgs() -> retval
```

### cv::ocl::Device::maxSamplers

```cpp
int cv::ocl::Device::maxSamplers()

AutoIt:
    $oDevice.maxSamplers() -> retval
```

### cv::ocl::Device::maxWorkGroupSize

```cpp
size_t cv::ocl::Device::maxWorkGroupSize()

AutoIt:
    $oDevice.maxWorkGroupSize() -> retval
```

### cv::ocl::Device::maxWorkItemDims

```cpp
int cv::ocl::Device::maxWorkItemDims()

AutoIt:
    $oDevice.maxWorkItemDims() -> retval
```

### cv::ocl::Device::memBaseAddrAlign

```cpp
int cv::ocl::Device::memBaseAddrAlign()

AutoIt:
    $oDevice.memBaseAddrAlign() -> retval
```

### cv::ocl::Device::nativeVectorWidthChar

```cpp
int cv::ocl::Device::nativeVectorWidthChar()

AutoIt:
    $oDevice.nativeVectorWidthChar() -> retval
```

### cv::ocl::Device::nativeVectorWidthShort

```cpp
int cv::ocl::Device::nativeVectorWidthShort()

AutoIt:
    $oDevice.nativeVectorWidthShort() -> retval
```

### cv::ocl::Device::nativeVectorWidthInt

```cpp
int cv::ocl::Device::nativeVectorWidthInt()

AutoIt:
    $oDevice.nativeVectorWidthInt() -> retval
```

### cv::ocl::Device::nativeVectorWidthLong

```cpp
int cv::ocl::Device::nativeVectorWidthLong()

AutoIt:
    $oDevice.nativeVectorWidthLong() -> retval
```

### cv::ocl::Device::nativeVectorWidthFloat

```cpp
int cv::ocl::Device::nativeVectorWidthFloat()

AutoIt:
    $oDevice.nativeVectorWidthFloat() -> retval
```

### cv::ocl::Device::nativeVectorWidthDouble

```cpp
int cv::ocl::Device::nativeVectorWidthDouble()

AutoIt:
    $oDevice.nativeVectorWidthDouble() -> retval
```

### cv::ocl::Device::nativeVectorWidthHalf

```cpp
int cv::ocl::Device::nativeVectorWidthHalf()

AutoIt:
    $oDevice.nativeVectorWidthHalf() -> retval
```

### cv::ocl::Device::preferredVectorWidthChar

```cpp
int cv::ocl::Device::preferredVectorWidthChar()

AutoIt:
    $oDevice.preferredVectorWidthChar() -> retval
```

### cv::ocl::Device::preferredVectorWidthShort

```cpp
int cv::ocl::Device::preferredVectorWidthShort()

AutoIt:
    $oDevice.preferredVectorWidthShort() -> retval
```

### cv::ocl::Device::preferredVectorWidthInt

```cpp
int cv::ocl::Device::preferredVectorWidthInt()

AutoIt:
    $oDevice.preferredVectorWidthInt() -> retval
```

### cv::ocl::Device::preferredVectorWidthLong

```cpp
int cv::ocl::Device::preferredVectorWidthLong()

AutoIt:
    $oDevice.preferredVectorWidthLong() -> retval
```

### cv::ocl::Device::preferredVectorWidthFloat

```cpp
int cv::ocl::Device::preferredVectorWidthFloat()

AutoIt:
    $oDevice.preferredVectorWidthFloat() -> retval
```

### cv::ocl::Device::preferredVectorWidthDouble

```cpp
int cv::ocl::Device::preferredVectorWidthDouble()

AutoIt:
    $oDevice.preferredVectorWidthDouble() -> retval
```

### cv::ocl::Device::preferredVectorWidthHalf

```cpp
int cv::ocl::Device::preferredVectorWidthHalf()

AutoIt:
    $oDevice.preferredVectorWidthHalf() -> retval
```

### cv::ocl::Device::printfBufferSize

```cpp
size_t cv::ocl::Device::printfBufferSize()

AutoIt:
    $oDevice.printfBufferSize() -> retval
```

### cv::ocl::Device::profilingTimerResolution

```cpp
size_t cv::ocl::Device::profilingTimerResolution()

AutoIt:
    $oDevice.profilingTimerResolution() -> retval
```

### cv::ocl::Device::getDefault

```cpp
static cv::ocl::Device cv::ocl::Device::getDefault()

AutoIt:
    _OpenCV_ObjCreate("cv.ocl.Device").getDefault() -> retval
```

## cv::FileStorage

### cv::FileStorage::create

```cpp
static cv::FileStorage cv::FileStorage::create()

AutoIt:
    _OpenCV_ObjCreate("cv.FileStorage").create() -> <cv.FileStorage object>
```

```cpp
static cv::FileStorage cv::FileStorage::create( const std::string& filename,
                                                int                flags,
                                                const std::string& encoding = String() )

AutoIt:
    _OpenCV_ObjCreate("cv.FileStorage").create( $filename, $flags[, $encoding] ) -> <cv.FileStorage object>
```

### cv::FileStorage::open

```cpp
bool cv::FileStorage::open( const std::string& filename,
                            int                flags,
                            const std::string& encoding = String() )

AutoIt:
    $oFileStorage.open( $filename, $flags[, $encoding] ) -> retval
```

### cv::FileStorage::isOpened

```cpp
bool cv::FileStorage::isOpened()

AutoIt:
    $oFileStorage.isOpened() -> retval
```

### cv::FileStorage::release

```cpp
void cv::FileStorage::release()

AutoIt:
    $oFileStorage.release() -> None
```

### cv::FileStorage::releaseAndGetString

```cpp
std::string cv::FileStorage::releaseAndGetString()

AutoIt:
    $oFileStorage.releaseAndGetString() -> retval
```

### cv::FileStorage::getFirstTopLevelNode

```cpp
cv::FileNode cv::FileStorage::getFirstTopLevelNode()

AutoIt:
    $oFileStorage.getFirstTopLevelNode() -> retval
```

### cv::FileStorage::root

```cpp
cv::FileNode cv::FileStorage::root( int streamidx = 0 )

AutoIt:
    $oFileStorage.root( [$streamidx] ) -> retval
```

### cv::FileStorage::getNode

```cpp
cv::FileNode cv::FileStorage::getNode( const char* nodename )

AutoIt:
    $oFileStorage.getNode( $nodename ) -> retval
```

### cv::FileStorage::write

```cpp
void cv::FileStorage::write( const std::string& name,
                             int                val )

AutoIt:
    $oFileStorage.write( $name, $val ) -> None
```

```cpp
void cv::FileStorage::write( const std::string& name,
                             double             val )

AutoIt:
    $oFileStorage.write( $name, $val ) -> None
```

```cpp
void cv::FileStorage::write( const std::string& name,
                             const std::string& val )

AutoIt:
    $oFileStorage.write( $name, $val ) -> None
```

```cpp
void cv::FileStorage::write( const std::string& name,
                             const cv::Mat&     val )

AutoIt:
    $oFileStorage.write( $name, $val ) -> None
```

```cpp
void cv::FileStorage::write( const std::string&              name,
                             const std::vector<std::string>& val )

AutoIt:
    $oFileStorage.write( $name, $val ) -> None
```

### cv::FileStorage::writeComment

```cpp
void cv::FileStorage::writeComment( const std::string& comment,
                                    bool               append = false )

AutoIt:
    $oFileStorage.writeComment( $comment[, $append] ) -> None
```

### cv::FileStorage::startWriteStruct

```cpp
void cv::FileStorage::startWriteStruct( const std::string& name,
                                        int                flags,
                                        const std::string& typeName = String() )

AutoIt:
    $oFileStorage.startWriteStruct( $name, $flags[, $typeName] ) -> None
```

### cv::FileStorage::endWriteStruct

```cpp
void cv::FileStorage::endWriteStruct()

AutoIt:
    $oFileStorage.endWriteStruct() -> None
```

### cv::FileStorage::getFormat

```cpp
int cv::FileStorage::getFormat()

AutoIt:
    $oFileStorage.getFormat() -> retval
```

## cv::FileNode

### cv::FileNode::create

```cpp
static cv::FileNode cv::FileNode::create()

AutoIt:
    _OpenCV_ObjCreate("cv.FileNode").create() -> <cv.FileNode object>
```

### cv::FileNode::getNode

```cpp
cv::FileNode cv::FileNode::getNode( const char* nodename )

AutoIt:
    $oFileNode.getNode( $nodename ) -> retval
```

### cv::FileNode::at

```cpp
cv::FileNode cv::FileNode::at( int i )

AutoIt:
    $oFileNode.at( $i ) -> retval
```

### cv::FileNode::keys

```cpp
std::vector<std::string> cv::FileNode::keys()

AutoIt:
    $oFileNode.keys() -> retval
```

### cv::FileNode::type

```cpp
int cv::FileNode::type()

AutoIt:
    $oFileNode.type() -> retval
```

### cv::FileNode::empty

```cpp
bool cv::FileNode::empty()

AutoIt:
    $oFileNode.empty() -> retval
```

### cv::FileNode::isNone

```cpp
bool cv::FileNode::isNone()

AutoIt:
    $oFileNode.isNone() -> retval
```

### cv::FileNode::isSeq

```cpp
bool cv::FileNode::isSeq()

AutoIt:
    $oFileNode.isSeq() -> retval
```

### cv::FileNode::isMap

```cpp
bool cv::FileNode::isMap()

AutoIt:
    $oFileNode.isMap() -> retval
```

### cv::FileNode::isInt

```cpp
bool cv::FileNode::isInt()

AutoIt:
    $oFileNode.isInt() -> retval
```

### cv::FileNode::isReal

```cpp
bool cv::FileNode::isReal()

AutoIt:
    $oFileNode.isReal() -> retval
```

### cv::FileNode::isString

```cpp
bool cv::FileNode::isString()

AutoIt:
    $oFileNode.isString() -> retval
```

### cv::FileNode::isNamed

```cpp
bool cv::FileNode::isNamed()

AutoIt:
    $oFileNode.isNamed() -> retval
```

### cv::FileNode::name

```cpp
std::string cv::FileNode::name()

AutoIt:
    $oFileNode.name() -> retval
```

### cv::FileNode::size

```cpp
size_t cv::FileNode::size()

AutoIt:
    $oFileNode.size() -> retval
```

### cv::FileNode::rawSize

```cpp
size_t cv::FileNode::rawSize()

AutoIt:
    $oFileNode.rawSize() -> retval
```

### cv::FileNode::real

```cpp
double cv::FileNode::real()

AutoIt:
    $oFileNode.real() -> retval
```

### cv::FileNode::string

```cpp
std::string cv::FileNode::string()

AutoIt:
    $oFileNode.string() -> retval
```

### cv::FileNode::mat

```cpp
cv::Mat cv::FileNode::mat()

AutoIt:
    $oFileNode.mat() -> retval
```

## cv::KeyPoint

### cv::KeyPoint::create

```cpp
static cv::KeyPoint cv::KeyPoint::create()

AutoIt:
    _OpenCV_ObjCreate("cv.KeyPoint").create() -> <cv.KeyPoint object>
```

```cpp
static cv::KeyPoint cv::KeyPoint::create( float x,
                                          float y,
                                          float size,
                                          float angle = -1,
                                          float response = 0,
                                          int   octave = 0,
                                          int   class_id = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv.KeyPoint").create( $x, $y, $size[, $angle[, $response[, $octave[, $class_id]]]] ) -> <cv.KeyPoint object>
```

### cv::KeyPoint::convert

```cpp
static void cv::KeyPoint::convert( const std::vector<cv::KeyPoint>& keypoints,
                                   std::vector<cv::Point2f>&        points2f,
                                   const std::vector<int>&          keypointIndexes = std::vector<int>() )

AutoIt:
    _OpenCV_ObjCreate("cv.KeyPoint").convert( $keypoints[, $keypointIndexes[, $points2f]] ) -> $points2f
```

```cpp
static void cv::KeyPoint::convert( const std::vector<cv::Point2f>& points2f,
                                   std::vector<cv::KeyPoint>&      keypoints,
                                   float                           size = 1,
                                   float                           response = 1,
                                   int                             octave = 0,
                                   int                             class_id = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv.KeyPoint").convert( $points2f[, $size[, $response[, $octave[, $class_id[, $keypoints]]]]] ) -> $keypoints
```

### cv::KeyPoint::overlap

```cpp
static float cv::KeyPoint::overlap( const cv::KeyPoint& kp1,
                                    const cv::KeyPoint& kp2 )

AutoIt:
    _OpenCV_ObjCreate("cv.KeyPoint").overlap( $kp1, $kp2 ) -> retval
```

## cv::DMatch

### cv::DMatch::create

```cpp
static cv::DMatch cv::DMatch::create()

AutoIt:
    _OpenCV_ObjCreate("cv.DMatch").create() -> <cv.DMatch object>
```

```cpp
static cv::DMatch cv::DMatch::create( int   _queryIdx,
                                      int   _trainIdx,
                                      float _distance )

AutoIt:
    _OpenCV_ObjCreate("cv.DMatch").create( $_queryIdx, $_trainIdx, $_distance ) -> <cv.DMatch object>
```

```cpp
static cv::DMatch cv::DMatch::create( int   _queryIdx,
                                      int   _trainIdx,
                                      int   _imgIdx,
                                      float _distance )

AutoIt:
    _OpenCV_ObjCreate("cv.DMatch").create( $_queryIdx, $_trainIdx, $_imgIdx, $_distance ) -> <cv.DMatch object>
```

## cv::TermCriteria

### cv::TermCriteria::create

```cpp
static cv::TermCriteria cv::TermCriteria::create()

AutoIt:
    _OpenCV_ObjCreate("cv.TermCriteria").create() -> <cv.TermCriteria object>
```

## cv::TickMeter

### cv::TickMeter::create

```cpp
static cv::TickMeter cv::TickMeter::create()

AutoIt:
    _OpenCV_ObjCreate("cv.TickMeter").create() -> <cv.TickMeter object>
```

### cv::TickMeter::start

```cpp
void cv::TickMeter::start()

AutoIt:
    $oTickMeter.start() -> None
```

### cv::TickMeter::stop

```cpp
void cv::TickMeter::stop()

AutoIt:
    $oTickMeter.stop() -> None
```

### cv::TickMeter::getTimeTicks

```cpp
int64 cv::TickMeter::getTimeTicks()

AutoIt:
    $oTickMeter.getTimeTicks() -> retval
```

### cv::TickMeter::getTimeMicro

```cpp
double cv::TickMeter::getTimeMicro()

AutoIt:
    $oTickMeter.getTimeMicro() -> retval
```

### cv::TickMeter::getTimeMilli

```cpp
double cv::TickMeter::getTimeMilli()

AutoIt:
    $oTickMeter.getTimeMilli() -> retval
```

### cv::TickMeter::getTimeSec

```cpp
double cv::TickMeter::getTimeSec()

AutoIt:
    $oTickMeter.getTimeSec() -> retval
```

### cv::TickMeter::getCounter

```cpp
int64 cv::TickMeter::getCounter()

AutoIt:
    $oTickMeter.getCounter() -> retval
```

### cv::TickMeter::getFPS

```cpp
double cv::TickMeter::getFPS()

AutoIt:
    $oTickMeter.getFPS() -> retval
```

### cv::TickMeter::getAvgTimeSec

```cpp
double cv::TickMeter::getAvgTimeSec()

AutoIt:
    $oTickMeter.getAvgTimeSec() -> retval
```

### cv::TickMeter::getAvgTimeMilli

```cpp
double cv::TickMeter::getAvgTimeMilli()

AutoIt:
    $oTickMeter.getAvgTimeMilli() -> retval
```

### cv::TickMeter::reset

```cpp
void cv::TickMeter::reset()

AutoIt:
    $oTickMeter.reset() -> None
```

## cv::samples

### cv::samples::findFile

```cpp
std::string cv::samples::findFile( const std::string& relative_path,
                                   bool               required = true,
                                   bool               silentMode = false )

AutoIt:
    _OpenCV_ObjCreate("cv.samples").findFile( $relative_path[, $required[, $silentMode]] ) -> retval
```

### cv::samples::findFileOrKeep

```cpp
std::string cv::samples::findFileOrKeep( const std::string& relative_path,
                                         bool               silentMode = false )

AutoIt:
    _OpenCV_ObjCreate("cv.samples").findFileOrKeep( $relative_path[, $silentMode] ) -> retval
```

### cv::samples::addSamplesDataSearchPath

```cpp
void cv::samples::addSamplesDataSearchPath( const std::string& path )

AutoIt:
    _OpenCV_ObjCreate("cv.samples").addSamplesDataSearchPath( $path ) -> None
```

### cv::samples::addSamplesDataSearchSubDirectory

```cpp
void cv::samples::addSamplesDataSearchSubDirectory( const std::string& subdir )

AutoIt:
    _OpenCV_ObjCreate("cv.samples").addSamplesDataSearchSubDirectory( $subdir ) -> None
```

## cv::flann::Index

### cv::flann::Index::create

```cpp
static cv::flann::Index cv::flann::Index::create()

AutoIt:
    _OpenCV_ObjCreate("cv.flann.Index").create() -> <cv.flann.Index object>
```

```cpp
static cv::flann::Index cv::flann::Index::create( _InputArray        features,
                                                  const IndexParams& params,
                                                  int                distType = cvflann::FLANN_DIST_L2 )

AutoIt:
    _OpenCV_ObjCreate("cv.flann.Index").create( $features, $params[, $distType] ) -> <cv.flann.Index object>
```

### cv::flann::Index::build

```cpp
void cv::flann::Index::build( _InputArray        features,
                              const IndexParams& params,
                              int                distType = cvflann::FLANN_DIST_L2 )

AutoIt:
    $oIndex.build( $features, $params[, $distType] ) -> None
```

### cv::flann::Index::knnSearch

```cpp
void cv::flann::Index::knnSearch( _InputArray         query,
                                  _OutputArray        indices,
                                  _OutputArray        dists,
                                  int                 knn,
                                  const SearchParams& params = SearchParams() )

AutoIt:
    $oIndex.knnSearch( $query, $knn[, $indices[, $dists[, $params]]] ) -> $indices, $dists
```

### cv::flann::Index::radiusSearch

```cpp
int cv::flann::Index::radiusSearch( _InputArray         query,
                                    _OutputArray        indices,
                                    _OutputArray        dists,
                                    double              radius,
                                    int                 maxResults,
                                    const SearchParams& params = SearchParams() )

AutoIt:
    $oIndex.radiusSearch( $query, $radius, $maxResults[, $indices[, $dists[, $params]]] ) -> retval, $indices, $dists
```

### cv::flann::Index::save

```cpp
void cv::flann::Index::save( const std::string& filename )

AutoIt:
    $oIndex.save( $filename ) -> None
```

### cv::flann::Index::load

```cpp
bool cv::flann::Index::load( _InputArray        features,
                             const std::string& filename )

AutoIt:
    $oIndex.load( $features, $filename ) -> retval
```

### cv::flann::Index::release

```cpp
void cv::flann::Index::release()

AutoIt:
    $oIndex.release() -> None
```

### cv::flann::Index::getDistance

```cpp
int cv::flann::Index::getDistance()

AutoIt:
    $oIndex.getDistance() -> retval
```

### cv::flann::Index::getAlgorithm

```cpp
int cv::flann::Index::getAlgorithm()

AutoIt:
    $oIndex.getAlgorithm() -> retval
```

## cv::GeneralizedHough

### cv::GeneralizedHough::setTemplate

```cpp
void cv::GeneralizedHough::setTemplate( _InputArray templ,
                                        cv::Point   templCenter = Point(-1, -1) )

AutoIt:
    $oGeneralizedHough.setTemplate( $templ[, $templCenter] ) -> None
```

```cpp
void cv::GeneralizedHough::setTemplate( _InputArray edges,
                                        _InputArray dx,
                                        _InputArray dy,
                                        cv::Point   templCenter = Point(-1, -1) )

AutoIt:
    $oGeneralizedHough.setTemplate( $edges, $dx, $dy[, $templCenter] ) -> None
```

### cv::GeneralizedHough::detect

```cpp
void cv::GeneralizedHough::detect( _InputArray  image,
                                   _OutputArray positions,
                                   _OutputArray votes = noArray() )

AutoIt:
    $oGeneralizedHough.detect( $image[, $positions[, $votes]] ) -> $positions, $votes
```

```cpp
void cv::GeneralizedHough::detect( _InputArray  edges,
                                   _InputArray  dx,
                                   _InputArray  dy,
                                   _OutputArray positions,
                                   _OutputArray votes = noArray() )

AutoIt:
    $oGeneralizedHough.detect( $edges, $dx, $dy[, $positions[, $votes]] ) -> $positions, $votes
```

### cv::GeneralizedHough::setCannyLowThresh

```cpp
void cv::GeneralizedHough::setCannyLowThresh( int cannyLowThresh )

AutoIt:
    $oGeneralizedHough.setCannyLowThresh( $cannyLowThresh ) -> None
```

### cv::GeneralizedHough::getCannyLowThresh

```cpp
int cv::GeneralizedHough::getCannyLowThresh()

AutoIt:
    $oGeneralizedHough.getCannyLowThresh() -> retval
```

### cv::GeneralizedHough::setCannyHighThresh

```cpp
void cv::GeneralizedHough::setCannyHighThresh( int cannyHighThresh )

AutoIt:
    $oGeneralizedHough.setCannyHighThresh( $cannyHighThresh ) -> None
```

### cv::GeneralizedHough::getCannyHighThresh

```cpp
int cv::GeneralizedHough::getCannyHighThresh()

AutoIt:
    $oGeneralizedHough.getCannyHighThresh() -> retval
```

### cv::GeneralizedHough::setMinDist

```cpp
void cv::GeneralizedHough::setMinDist( double minDist )

AutoIt:
    $oGeneralizedHough.setMinDist( $minDist ) -> None
```

### cv::GeneralizedHough::getMinDist

```cpp
double cv::GeneralizedHough::getMinDist()

AutoIt:
    $oGeneralizedHough.getMinDist() -> retval
```

### cv::GeneralizedHough::setDp

```cpp
void cv::GeneralizedHough::setDp( double dp )

AutoIt:
    $oGeneralizedHough.setDp( $dp ) -> None
```

### cv::GeneralizedHough::getDp

```cpp
double cv::GeneralizedHough::getDp()

AutoIt:
    $oGeneralizedHough.getDp() -> retval
```

### cv::GeneralizedHough::setMaxBufferSize

```cpp
void cv::GeneralizedHough::setMaxBufferSize( int maxBufferSize )

AutoIt:
    $oGeneralizedHough.setMaxBufferSize( $maxBufferSize ) -> None
```

### cv::GeneralizedHough::getMaxBufferSize

```cpp
int cv::GeneralizedHough::getMaxBufferSize()

AutoIt:
    $oGeneralizedHough.getMaxBufferSize() -> retval
```

### cv::GeneralizedHough::clear

```cpp
void cv::GeneralizedHough::clear()

AutoIt:
    $oGeneralizedHough.clear() -> None
```

### cv::GeneralizedHough::write

```cpp
void cv::GeneralizedHough::write( const cv::Ptr<cv::FileStorage>& fs,
                                  const std::string&              name = String() )

AutoIt:
    $oGeneralizedHough.write( $fs[, $name] ) -> None
```

### cv::GeneralizedHough::read

```cpp
void cv::GeneralizedHough::read( const cv::FileNode& fn )

AutoIt:
    $oGeneralizedHough.read( $fn ) -> None
```

### cv::GeneralizedHough::empty

```cpp
bool cv::GeneralizedHough::empty()

AutoIt:
    $oGeneralizedHough.empty() -> retval
```

### cv::GeneralizedHough::save

```cpp
void cv::GeneralizedHough::save( const std::string& filename )

AutoIt:
    $oGeneralizedHough.save( $filename ) -> None
```

### cv::GeneralizedHough::getDefaultName

```cpp
std::string cv::GeneralizedHough::getDefaultName()

AutoIt:
    $oGeneralizedHough.getDefaultName() -> retval
```

## cv::GeneralizedHoughBallard

### cv::GeneralizedHoughBallard::setLevels

```cpp
void cv::GeneralizedHoughBallard::setLevels( int levels )

AutoIt:
    $oGeneralizedHoughBallard.setLevels( $levels ) -> None
```

### cv::GeneralizedHoughBallard::getLevels

```cpp
int cv::GeneralizedHoughBallard::getLevels()

AutoIt:
    $oGeneralizedHoughBallard.getLevels() -> retval
```

### cv::GeneralizedHoughBallard::setVotesThreshold

```cpp
void cv::GeneralizedHoughBallard::setVotesThreshold( int votesThreshold )

AutoIt:
    $oGeneralizedHoughBallard.setVotesThreshold( $votesThreshold ) -> None
```

### cv::GeneralizedHoughBallard::getVotesThreshold

```cpp
int cv::GeneralizedHoughBallard::getVotesThreshold()

AutoIt:
    $oGeneralizedHoughBallard.getVotesThreshold() -> retval
```

### cv::GeneralizedHoughBallard::setTemplate

```cpp
void cv::GeneralizedHoughBallard::setTemplate( _InputArray templ,
                                               cv::Point   templCenter = Point(-1, -1) )

AutoIt:
    $oGeneralizedHoughBallard.setTemplate( $templ[, $templCenter] ) -> None
```

```cpp
void cv::GeneralizedHoughBallard::setTemplate( _InputArray edges,
                                               _InputArray dx,
                                               _InputArray dy,
                                               cv::Point   templCenter = Point(-1, -1) )

AutoIt:
    $oGeneralizedHoughBallard.setTemplate( $edges, $dx, $dy[, $templCenter] ) -> None
```

### cv::GeneralizedHoughBallard::detect

```cpp
void cv::GeneralizedHoughBallard::detect( _InputArray  image,
                                          _OutputArray positions,
                                          _OutputArray votes = noArray() )

AutoIt:
    $oGeneralizedHoughBallard.detect( $image[, $positions[, $votes]] ) -> $positions, $votes
```

```cpp
void cv::GeneralizedHoughBallard::detect( _InputArray  edges,
                                          _InputArray  dx,
                                          _InputArray  dy,
                                          _OutputArray positions,
                                          _OutputArray votes = noArray() )

AutoIt:
    $oGeneralizedHoughBallard.detect( $edges, $dx, $dy[, $positions[, $votes]] ) -> $positions, $votes
```

### cv::GeneralizedHoughBallard::setCannyLowThresh

```cpp
void cv::GeneralizedHoughBallard::setCannyLowThresh( int cannyLowThresh )

AutoIt:
    $oGeneralizedHoughBallard.setCannyLowThresh( $cannyLowThresh ) -> None
```

### cv::GeneralizedHoughBallard::getCannyLowThresh

```cpp
int cv::GeneralizedHoughBallard::getCannyLowThresh()

AutoIt:
    $oGeneralizedHoughBallard.getCannyLowThresh() -> retval
```

### cv::GeneralizedHoughBallard::setCannyHighThresh

```cpp
void cv::GeneralizedHoughBallard::setCannyHighThresh( int cannyHighThresh )

AutoIt:
    $oGeneralizedHoughBallard.setCannyHighThresh( $cannyHighThresh ) -> None
```

### cv::GeneralizedHoughBallard::getCannyHighThresh

```cpp
int cv::GeneralizedHoughBallard::getCannyHighThresh()

AutoIt:
    $oGeneralizedHoughBallard.getCannyHighThresh() -> retval
```

### cv::GeneralizedHoughBallard::setMinDist

```cpp
void cv::GeneralizedHoughBallard::setMinDist( double minDist )

AutoIt:
    $oGeneralizedHoughBallard.setMinDist( $minDist ) -> None
```

### cv::GeneralizedHoughBallard::getMinDist

```cpp
double cv::GeneralizedHoughBallard::getMinDist()

AutoIt:
    $oGeneralizedHoughBallard.getMinDist() -> retval
```

### cv::GeneralizedHoughBallard::setDp

```cpp
void cv::GeneralizedHoughBallard::setDp( double dp )

AutoIt:
    $oGeneralizedHoughBallard.setDp( $dp ) -> None
```

### cv::GeneralizedHoughBallard::getDp

```cpp
double cv::GeneralizedHoughBallard::getDp()

AutoIt:
    $oGeneralizedHoughBallard.getDp() -> retval
```

### cv::GeneralizedHoughBallard::setMaxBufferSize

```cpp
void cv::GeneralizedHoughBallard::setMaxBufferSize( int maxBufferSize )

AutoIt:
    $oGeneralizedHoughBallard.setMaxBufferSize( $maxBufferSize ) -> None
```

### cv::GeneralizedHoughBallard::getMaxBufferSize

```cpp
int cv::GeneralizedHoughBallard::getMaxBufferSize()

AutoIt:
    $oGeneralizedHoughBallard.getMaxBufferSize() -> retval
```

### cv::GeneralizedHoughBallard::clear

```cpp
void cv::GeneralizedHoughBallard::clear()

AutoIt:
    $oGeneralizedHoughBallard.clear() -> None
```

### cv::GeneralizedHoughBallard::write

```cpp
void cv::GeneralizedHoughBallard::write( const cv::Ptr<cv::FileStorage>& fs,
                                         const std::string&              name = String() )

AutoIt:
    $oGeneralizedHoughBallard.write( $fs[, $name] ) -> None
```

### cv::GeneralizedHoughBallard::read

```cpp
void cv::GeneralizedHoughBallard::read( const cv::FileNode& fn )

AutoIt:
    $oGeneralizedHoughBallard.read( $fn ) -> None
```

### cv::GeneralizedHoughBallard::empty

```cpp
bool cv::GeneralizedHoughBallard::empty()

AutoIt:
    $oGeneralizedHoughBallard.empty() -> retval
```

### cv::GeneralizedHoughBallard::save

```cpp
void cv::GeneralizedHoughBallard::save( const std::string& filename )

AutoIt:
    $oGeneralizedHoughBallard.save( $filename ) -> None
```

### cv::GeneralizedHoughBallard::getDefaultName

```cpp
std::string cv::GeneralizedHoughBallard::getDefaultName()

AutoIt:
    $oGeneralizedHoughBallard.getDefaultName() -> retval
```

## cv::GeneralizedHoughGuil

### cv::GeneralizedHoughGuil::setXi

```cpp
void cv::GeneralizedHoughGuil::setXi( double xi )

AutoIt:
    $oGeneralizedHoughGuil.setXi( $xi ) -> None
```

### cv::GeneralizedHoughGuil::getXi

```cpp
double cv::GeneralizedHoughGuil::getXi()

AutoIt:
    $oGeneralizedHoughGuil.getXi() -> retval
```

### cv::GeneralizedHoughGuil::setLevels

```cpp
void cv::GeneralizedHoughGuil::setLevels( int levels )

AutoIt:
    $oGeneralizedHoughGuil.setLevels( $levels ) -> None
```

### cv::GeneralizedHoughGuil::getLevels

```cpp
int cv::GeneralizedHoughGuil::getLevels()

AutoIt:
    $oGeneralizedHoughGuil.getLevels() -> retval
```

### cv::GeneralizedHoughGuil::setAngleEpsilon

```cpp
void cv::GeneralizedHoughGuil::setAngleEpsilon( double angleEpsilon )

AutoIt:
    $oGeneralizedHoughGuil.setAngleEpsilon( $angleEpsilon ) -> None
```

### cv::GeneralizedHoughGuil::getAngleEpsilon

```cpp
double cv::GeneralizedHoughGuil::getAngleEpsilon()

AutoIt:
    $oGeneralizedHoughGuil.getAngleEpsilon() -> retval
```

### cv::GeneralizedHoughGuil::setMinAngle

```cpp
void cv::GeneralizedHoughGuil::setMinAngle( double minAngle )

AutoIt:
    $oGeneralizedHoughGuil.setMinAngle( $minAngle ) -> None
```

### cv::GeneralizedHoughGuil::getMinAngle

```cpp
double cv::GeneralizedHoughGuil::getMinAngle()

AutoIt:
    $oGeneralizedHoughGuil.getMinAngle() -> retval
```

### cv::GeneralizedHoughGuil::setMaxAngle

```cpp
void cv::GeneralizedHoughGuil::setMaxAngle( double maxAngle )

AutoIt:
    $oGeneralizedHoughGuil.setMaxAngle( $maxAngle ) -> None
```

### cv::GeneralizedHoughGuil::getMaxAngle

```cpp
double cv::GeneralizedHoughGuil::getMaxAngle()

AutoIt:
    $oGeneralizedHoughGuil.getMaxAngle() -> retval
```

### cv::GeneralizedHoughGuil::setAngleStep

```cpp
void cv::GeneralizedHoughGuil::setAngleStep( double angleStep )

AutoIt:
    $oGeneralizedHoughGuil.setAngleStep( $angleStep ) -> None
```

### cv::GeneralizedHoughGuil::getAngleStep

```cpp
double cv::GeneralizedHoughGuil::getAngleStep()

AutoIt:
    $oGeneralizedHoughGuil.getAngleStep() -> retval
```

### cv::GeneralizedHoughGuil::setAngleThresh

```cpp
void cv::GeneralizedHoughGuil::setAngleThresh( int angleThresh )

AutoIt:
    $oGeneralizedHoughGuil.setAngleThresh( $angleThresh ) -> None
```

### cv::GeneralizedHoughGuil::getAngleThresh

```cpp
int cv::GeneralizedHoughGuil::getAngleThresh()

AutoIt:
    $oGeneralizedHoughGuil.getAngleThresh() -> retval
```

### cv::GeneralizedHoughGuil::setMinScale

```cpp
void cv::GeneralizedHoughGuil::setMinScale( double minScale )

AutoIt:
    $oGeneralizedHoughGuil.setMinScale( $minScale ) -> None
```

### cv::GeneralizedHoughGuil::getMinScale

```cpp
double cv::GeneralizedHoughGuil::getMinScale()

AutoIt:
    $oGeneralizedHoughGuil.getMinScale() -> retval
```

### cv::GeneralizedHoughGuil::setMaxScale

```cpp
void cv::GeneralizedHoughGuil::setMaxScale( double maxScale )

AutoIt:
    $oGeneralizedHoughGuil.setMaxScale( $maxScale ) -> None
```

### cv::GeneralizedHoughGuil::getMaxScale

```cpp
double cv::GeneralizedHoughGuil::getMaxScale()

AutoIt:
    $oGeneralizedHoughGuil.getMaxScale() -> retval
```

### cv::GeneralizedHoughGuil::setScaleStep

```cpp
void cv::GeneralizedHoughGuil::setScaleStep( double scaleStep )

AutoIt:
    $oGeneralizedHoughGuil.setScaleStep( $scaleStep ) -> None
```

### cv::GeneralizedHoughGuil::getScaleStep

```cpp
double cv::GeneralizedHoughGuil::getScaleStep()

AutoIt:
    $oGeneralizedHoughGuil.getScaleStep() -> retval
```

### cv::GeneralizedHoughGuil::setScaleThresh

```cpp
void cv::GeneralizedHoughGuil::setScaleThresh( int scaleThresh )

AutoIt:
    $oGeneralizedHoughGuil.setScaleThresh( $scaleThresh ) -> None
```

### cv::GeneralizedHoughGuil::getScaleThresh

```cpp
int cv::GeneralizedHoughGuil::getScaleThresh()

AutoIt:
    $oGeneralizedHoughGuil.getScaleThresh() -> retval
```

### cv::GeneralizedHoughGuil::setPosThresh

```cpp
void cv::GeneralizedHoughGuil::setPosThresh( int posThresh )

AutoIt:
    $oGeneralizedHoughGuil.setPosThresh( $posThresh ) -> None
```

### cv::GeneralizedHoughGuil::getPosThresh

```cpp
int cv::GeneralizedHoughGuil::getPosThresh()

AutoIt:
    $oGeneralizedHoughGuil.getPosThresh() -> retval
```

### cv::GeneralizedHoughGuil::setTemplate

```cpp
void cv::GeneralizedHoughGuil::setTemplate( _InputArray templ,
                                            cv::Point   templCenter = Point(-1, -1) )

AutoIt:
    $oGeneralizedHoughGuil.setTemplate( $templ[, $templCenter] ) -> None
```

```cpp
void cv::GeneralizedHoughGuil::setTemplate( _InputArray edges,
                                            _InputArray dx,
                                            _InputArray dy,
                                            cv::Point   templCenter = Point(-1, -1) )

AutoIt:
    $oGeneralizedHoughGuil.setTemplate( $edges, $dx, $dy[, $templCenter] ) -> None
```

### cv::GeneralizedHoughGuil::detect

```cpp
void cv::GeneralizedHoughGuil::detect( _InputArray  image,
                                       _OutputArray positions,
                                       _OutputArray votes = noArray() )

AutoIt:
    $oGeneralizedHoughGuil.detect( $image[, $positions[, $votes]] ) -> $positions, $votes
```

```cpp
void cv::GeneralizedHoughGuil::detect( _InputArray  edges,
                                       _InputArray  dx,
                                       _InputArray  dy,
                                       _OutputArray positions,
                                       _OutputArray votes = noArray() )

AutoIt:
    $oGeneralizedHoughGuil.detect( $edges, $dx, $dy[, $positions[, $votes]] ) -> $positions, $votes
```

### cv::GeneralizedHoughGuil::setCannyLowThresh

```cpp
void cv::GeneralizedHoughGuil::setCannyLowThresh( int cannyLowThresh )

AutoIt:
    $oGeneralizedHoughGuil.setCannyLowThresh( $cannyLowThresh ) -> None
```

### cv::GeneralizedHoughGuil::getCannyLowThresh

```cpp
int cv::GeneralizedHoughGuil::getCannyLowThresh()

AutoIt:
    $oGeneralizedHoughGuil.getCannyLowThresh() -> retval
```

### cv::GeneralizedHoughGuil::setCannyHighThresh

```cpp
void cv::GeneralizedHoughGuil::setCannyHighThresh( int cannyHighThresh )

AutoIt:
    $oGeneralizedHoughGuil.setCannyHighThresh( $cannyHighThresh ) -> None
```

### cv::GeneralizedHoughGuil::getCannyHighThresh

```cpp
int cv::GeneralizedHoughGuil::getCannyHighThresh()

AutoIt:
    $oGeneralizedHoughGuil.getCannyHighThresh() -> retval
```

### cv::GeneralizedHoughGuil::setMinDist

```cpp
void cv::GeneralizedHoughGuil::setMinDist( double minDist )

AutoIt:
    $oGeneralizedHoughGuil.setMinDist( $minDist ) -> None
```

### cv::GeneralizedHoughGuil::getMinDist

```cpp
double cv::GeneralizedHoughGuil::getMinDist()

AutoIt:
    $oGeneralizedHoughGuil.getMinDist() -> retval
```

### cv::GeneralizedHoughGuil::setDp

```cpp
void cv::GeneralizedHoughGuil::setDp( double dp )

AutoIt:
    $oGeneralizedHoughGuil.setDp( $dp ) -> None
```

### cv::GeneralizedHoughGuil::getDp

```cpp
double cv::GeneralizedHoughGuil::getDp()

AutoIt:
    $oGeneralizedHoughGuil.getDp() -> retval
```

### cv::GeneralizedHoughGuil::setMaxBufferSize

```cpp
void cv::GeneralizedHoughGuil::setMaxBufferSize( int maxBufferSize )

AutoIt:
    $oGeneralizedHoughGuil.setMaxBufferSize( $maxBufferSize ) -> None
```

### cv::GeneralizedHoughGuil::getMaxBufferSize

```cpp
int cv::GeneralizedHoughGuil::getMaxBufferSize()

AutoIt:
    $oGeneralizedHoughGuil.getMaxBufferSize() -> retval
```

### cv::GeneralizedHoughGuil::clear

```cpp
void cv::GeneralizedHoughGuil::clear()

AutoIt:
    $oGeneralizedHoughGuil.clear() -> None
```

### cv::GeneralizedHoughGuil::write

```cpp
void cv::GeneralizedHoughGuil::write( const cv::Ptr<cv::FileStorage>& fs,
                                      const std::string&              name = String() )

AutoIt:
    $oGeneralizedHoughGuil.write( $fs[, $name] ) -> None
```

### cv::GeneralizedHoughGuil::read

```cpp
void cv::GeneralizedHoughGuil::read( const cv::FileNode& fn )

AutoIt:
    $oGeneralizedHoughGuil.read( $fn ) -> None
```

### cv::GeneralizedHoughGuil::empty

```cpp
bool cv::GeneralizedHoughGuil::empty()

AutoIt:
    $oGeneralizedHoughGuil.empty() -> retval
```

### cv::GeneralizedHoughGuil::save

```cpp
void cv::GeneralizedHoughGuil::save( const std::string& filename )

AutoIt:
    $oGeneralizedHoughGuil.save( $filename ) -> None
```

### cv::GeneralizedHoughGuil::getDefaultName

```cpp
std::string cv::GeneralizedHoughGuil::getDefaultName()

AutoIt:
    $oGeneralizedHoughGuil.getDefaultName() -> retval
```

## cv::CLAHE

### cv::CLAHE::apply

```cpp
void cv::CLAHE::apply( _InputArray  src,
                       _OutputArray dst )

AutoIt:
    $oCLAHE.apply( $src[, $dst] ) -> $dst
```

### cv::CLAHE::setClipLimit

```cpp
void cv::CLAHE::setClipLimit( double clipLimit )

AutoIt:
    $oCLAHE.setClipLimit( $clipLimit ) -> None
```

### cv::CLAHE::getClipLimit

```cpp
double cv::CLAHE::getClipLimit()

AutoIt:
    $oCLAHE.getClipLimit() -> retval
```

### cv::CLAHE::setTilesGridSize

```cpp
void cv::CLAHE::setTilesGridSize( cv::Size tileGridSize )

AutoIt:
    $oCLAHE.setTilesGridSize( $tileGridSize ) -> None
```

### cv::CLAHE::getTilesGridSize

```cpp
cv::Size cv::CLAHE::getTilesGridSize()

AutoIt:
    $oCLAHE.getTilesGridSize() -> retval
```

### cv::CLAHE::collectGarbage

```cpp
void cv::CLAHE::collectGarbage()

AutoIt:
    $oCLAHE.collectGarbage() -> None
```

### cv::CLAHE::clear

```cpp
void cv::CLAHE::clear()

AutoIt:
    $oCLAHE.clear() -> None
```

### cv::CLAHE::write

```cpp
void cv::CLAHE::write( const cv::Ptr<cv::FileStorage>& fs,
                       const std::string&              name = String() )

AutoIt:
    $oCLAHE.write( $fs[, $name] ) -> None
```

### cv::CLAHE::read

```cpp
void cv::CLAHE::read( const cv::FileNode& fn )

AutoIt:
    $oCLAHE.read( $fn ) -> None
```

### cv::CLAHE::empty

```cpp
bool cv::CLAHE::empty()

AutoIt:
    $oCLAHE.empty() -> retval
```

### cv::CLAHE::save

```cpp
void cv::CLAHE::save( const std::string& filename )

AutoIt:
    $oCLAHE.save( $filename ) -> None
```

### cv::CLAHE::getDefaultName

```cpp
std::string cv::CLAHE::getDefaultName()

AutoIt:
    $oCLAHE.getDefaultName() -> retval
```

## cv::Subdiv2D

### cv::Subdiv2D::create

```cpp
static cv::Subdiv2D cv::Subdiv2D::create()

AutoIt:
    _OpenCV_ObjCreate("cv.Subdiv2D").create() -> <cv.Subdiv2D object>
```

```cpp
static cv::Subdiv2D cv::Subdiv2D::create( cv::Rect rect )

AutoIt:
    _OpenCV_ObjCreate("cv.Subdiv2D").create( $rect ) -> <cv.Subdiv2D object>
```

### cv::Subdiv2D::initDelaunay

```cpp
void cv::Subdiv2D::initDelaunay( cv::Rect rect )

AutoIt:
    $oSubdiv2D.initDelaunay( $rect ) -> None
```

### cv::Subdiv2D::insert

```cpp
int cv::Subdiv2D::insert( cv::Point2f pt )

AutoIt:
    $oSubdiv2D.insert( $pt ) -> retval
```

```cpp
void cv::Subdiv2D::insert( const std::vector<cv::Point2f>& ptvec )

AutoIt:
    $oSubdiv2D.insert( $ptvec ) -> None
```

### cv::Subdiv2D::locate

```cpp
int cv::Subdiv2D::locate( cv::Point2f pt,
                          int&        edge,
                          int&        vertex )

AutoIt:
    $oSubdiv2D.locate( $pt[, $edge[, $vertex]] ) -> retval, $edge, $vertex
```

### cv::Subdiv2D::findNearest

```cpp
int cv::Subdiv2D::findNearest( cv::Point2f  pt,
                               cv::Point2f* nearestPt = 0 )

AutoIt:
    $oSubdiv2D.findNearest( $pt[, $nearestPt] ) -> retval, $nearestPt
```

### cv::Subdiv2D::getEdgeList

```cpp
void cv::Subdiv2D::getEdgeList( std::vector<cv::Vec4f>& edgeList )

AutoIt:
    $oSubdiv2D.getEdgeList( [$edgeList] ) -> $edgeList
```

### cv::Subdiv2D::getLeadingEdgeList

```cpp
void cv::Subdiv2D::getLeadingEdgeList( std::vector<int>& leadingEdgeList )

AutoIt:
    $oSubdiv2D.getLeadingEdgeList( [$leadingEdgeList] ) -> $leadingEdgeList
```

### cv::Subdiv2D::getTriangleList

```cpp
void cv::Subdiv2D::getTriangleList( std::vector<cv::Vec6f>& triangleList )

AutoIt:
    $oSubdiv2D.getTriangleList( [$triangleList] ) -> $triangleList
```

### cv::Subdiv2D::getVoronoiFacetList

```cpp
void cv::Subdiv2D::getVoronoiFacetList( const std::vector<int>&                idx,
                                        std::vector<std::vector<cv::Point2f>>& facetList,
                                        std::vector<cv::Point2f>&              facetCenters )

AutoIt:
    $oSubdiv2D.getVoronoiFacetList( $idx[, $facetList[, $facetCenters]] ) -> $facetList, $facetCenters
```

### cv::Subdiv2D::getVertex

```cpp
cv::Point2f cv::Subdiv2D::getVertex( int  vertex,
                                     int* firstEdge = 0 )

AutoIt:
    $oSubdiv2D.getVertex( $vertex[, $firstEdge] ) -> retval, $firstEdge
```

### cv::Subdiv2D::getEdge

```cpp
int cv::Subdiv2D::getEdge( int edge,
                           int nextEdgeType )

AutoIt:
    $oSubdiv2D.getEdge( $edge, $nextEdgeType ) -> retval
```

### cv::Subdiv2D::nextEdge

```cpp
int cv::Subdiv2D::nextEdge( int edge )

AutoIt:
    $oSubdiv2D.nextEdge( $edge ) -> retval
```

### cv::Subdiv2D::rotateEdge

```cpp
int cv::Subdiv2D::rotateEdge( int edge,
                              int rotate )

AutoIt:
    $oSubdiv2D.rotateEdge( $edge, $rotate ) -> retval
```

### cv::Subdiv2D::symEdge

```cpp
int cv::Subdiv2D::symEdge( int edge )

AutoIt:
    $oSubdiv2D.symEdge( $edge ) -> retval
```

### cv::Subdiv2D::edgeOrg

```cpp
int cv::Subdiv2D::edgeOrg( int          edge,
                           cv::Point2f* orgpt = 0 )

AutoIt:
    $oSubdiv2D.edgeOrg( $edge[, $orgpt] ) -> retval, $orgpt
```

### cv::Subdiv2D::edgeDst

```cpp
int cv::Subdiv2D::edgeDst( int          edge,
                           cv::Point2f* dstpt = 0 )

AutoIt:
    $oSubdiv2D.edgeDst( $edge[, $dstpt] ) -> retval, $dstpt
```

## cv::LineSegmentDetector

### cv::LineSegmentDetector::detect

```cpp
void cv::LineSegmentDetector::detect( _InputArray  image,
                                      _OutputArray lines,
                                      _OutputArray width = noArray(),
                                      _OutputArray prec = noArray(),
                                      _OutputArray nfa = noArray() )

AutoIt:
    $oLineSegmentDetector.detect( $image[, $lines[, $width[, $prec[, $nfa]]]] ) -> $lines, $width, $prec, $nfa
```

### cv::LineSegmentDetector::drawSegments

```cpp
void cv::LineSegmentDetector::drawSegments( _InputOutputArray image,
                                            _InputArray       lines )

AutoIt:
    $oLineSegmentDetector.drawSegments( $image, $lines ) -> $image
```

### cv::LineSegmentDetector::compareSegments

```cpp
int cv::LineSegmentDetector::compareSegments( const cv::Size&   size,
                                              _InputArray       lines1,
                                              _InputArray       lines2,
                                              _InputOutputArray image = noArray() )

AutoIt:
    $oLineSegmentDetector.compareSegments( $size, $lines1, $lines2[, $image] ) -> retval, $image
```

### cv::LineSegmentDetector::clear

```cpp
void cv::LineSegmentDetector::clear()

AutoIt:
    $oLineSegmentDetector.clear() -> None
```

### cv::LineSegmentDetector::write

```cpp
void cv::LineSegmentDetector::write( const cv::Ptr<cv::FileStorage>& fs,
                                     const std::string&              name = String() )

AutoIt:
    $oLineSegmentDetector.write( $fs[, $name] ) -> None
```

### cv::LineSegmentDetector::read

```cpp
void cv::LineSegmentDetector::read( const cv::FileNode& fn )

AutoIt:
    $oLineSegmentDetector.read( $fn ) -> None
```

### cv::LineSegmentDetector::empty

```cpp
bool cv::LineSegmentDetector::empty()

AutoIt:
    $oLineSegmentDetector.empty() -> retval
```

### cv::LineSegmentDetector::save

```cpp
void cv::LineSegmentDetector::save( const std::string& filename )

AutoIt:
    $oLineSegmentDetector.save( $filename ) -> None
```

### cv::LineSegmentDetector::getDefaultName

```cpp
std::string cv::LineSegmentDetector::getDefaultName()

AutoIt:
    $oLineSegmentDetector.getDefaultName() -> retval
```

## cv::segmentation::IntelligentScissorsMB

### cv::segmentation::IntelligentScissorsMB::create

```cpp
static cv::segmentation::IntelligentScissorsMB cv::segmentation::IntelligentScissorsMB::create()

AutoIt:
    _OpenCV_ObjCreate("cv.segmentation.IntelligentScissorsMB").create() -> <cv.segmentation.IntelligentScissorsMB object>
```

### cv::segmentation::IntelligentScissorsMB::setWeights

```cpp
cv::segmentation::IntelligentScissorsMB cv::segmentation::IntelligentScissorsMB::setWeights( float weight_non_edge,
                                                                                             float weight_gradient_direction,
                                                                                             float weight_gradient_magnitude )

AutoIt:
    $oIntelligentScissorsMB.setWeights( $weight_non_edge, $weight_gradient_direction, $weight_gradient_magnitude ) -> retval
```

### cv::segmentation::IntelligentScissorsMB::setGradientMagnitudeMaxLimit

```cpp
cv::segmentation::IntelligentScissorsMB cv::segmentation::IntelligentScissorsMB::setGradientMagnitudeMaxLimit( float gradient_magnitude_threshold_max = 0.0f )

AutoIt:
    $oIntelligentScissorsMB.setGradientMagnitudeMaxLimit( [$gradient_magnitude_threshold_max] ) -> retval
```

### cv::segmentation::IntelligentScissorsMB::setEdgeFeatureZeroCrossingParameters

```cpp
cv::segmentation::IntelligentScissorsMB cv::segmentation::IntelligentScissorsMB::setEdgeFeatureZeroCrossingParameters( float gradient_magnitude_min_value = 0.0f )

AutoIt:
    $oIntelligentScissorsMB.setEdgeFeatureZeroCrossingParameters( [$gradient_magnitude_min_value] ) -> retval
```

### cv::segmentation::IntelligentScissorsMB::setEdgeFeatureCannyParameters

```cpp
cv::segmentation::IntelligentScissorsMB cv::segmentation::IntelligentScissorsMB::setEdgeFeatureCannyParameters( double threshold1,
                                                                                                                double threshold2,
                                                                                                                int    apertureSize = 3,
                                                                                                                bool   L2gradient = false )

AutoIt:
    $oIntelligentScissorsMB.setEdgeFeatureCannyParameters( $threshold1, $threshold2[, $apertureSize[, $L2gradient]] ) -> retval
```

### cv::segmentation::IntelligentScissorsMB::applyImage

```cpp
cv::segmentation::IntelligentScissorsMB cv::segmentation::IntelligentScissorsMB::applyImage( _InputArray image )

AutoIt:
    $oIntelligentScissorsMB.applyImage( $image ) -> retval
```

### cv::segmentation::IntelligentScissorsMB::applyImageFeatures

```cpp
cv::segmentation::IntelligentScissorsMB cv::segmentation::IntelligentScissorsMB::applyImageFeatures( _InputArray non_edge,
                                                                                                     _InputArray gradient_direction,
                                                                                                     _InputArray gradient_magnitude,
                                                                                                     _InputArray image = noArray() )

AutoIt:
    $oIntelligentScissorsMB.applyImageFeatures( $non_edge, $gradient_direction, $gradient_magnitude[, $image] ) -> retval
```

### cv::segmentation::IntelligentScissorsMB::buildMap

```cpp
void cv::segmentation::IntelligentScissorsMB::buildMap( const cv::Point& sourcePt )

AutoIt:
    $oIntelligentScissorsMB.buildMap( $sourcePt ) -> None
```

### cv::segmentation::IntelligentScissorsMB::getContour

```cpp
void cv::segmentation::IntelligentScissorsMB::getContour( const cv::Point& targetPt,
                                                          _OutputArray     contour,
                                                          bool             backward = false )

AutoIt:
    $oIntelligentScissorsMB.getContour( $targetPt[, $contour[, $backward]] ) -> $contour
```

## cv::ml::ParamGrid

### cv::ml::ParamGrid::create

```cpp
static cv::Ptr<cv::ml::ParamGrid> cv::ml::ParamGrid::create( double minVal = 0.,
                                                             double maxVal = 0.,
                                                             double logstep = 1. )

AutoIt:
    _OpenCV_ObjCreate("cv.ml.ParamGrid").create( [$minVal[, $maxVal[, $logstep]]] ) -> retval
```

## cv::ml::TrainData

### cv::ml::TrainData::getLayout

```cpp
int cv::ml::TrainData::getLayout()

AutoIt:
    $oTrainData.getLayout() -> retval
```

### cv::ml::TrainData::getNTrainSamples

```cpp
int cv::ml::TrainData::getNTrainSamples()

AutoIt:
    $oTrainData.getNTrainSamples() -> retval
```

### cv::ml::TrainData::getNTestSamples

```cpp
int cv::ml::TrainData::getNTestSamples()

AutoIt:
    $oTrainData.getNTestSamples() -> retval
```

### cv::ml::TrainData::getNSamples

```cpp
int cv::ml::TrainData::getNSamples()

AutoIt:
    $oTrainData.getNSamples() -> retval
```

### cv::ml::TrainData::getNVars

```cpp
int cv::ml::TrainData::getNVars()

AutoIt:
    $oTrainData.getNVars() -> retval
```

### cv::ml::TrainData::getNAllVars

```cpp
int cv::ml::TrainData::getNAllVars()

AutoIt:
    $oTrainData.getNAllVars() -> retval
```

### cv::ml::TrainData::getSample

```cpp
void cv::ml::TrainData::getSample( _InputArray varIdx,
                                   int         sidx,
                                   float*      buf )

AutoIt:
    $oTrainData.getSample( $varIdx, $sidx[, $buf] ) -> $buf
```

### cv::ml::TrainData::getSamples

```cpp
cv::Mat cv::ml::TrainData::getSamples()

AutoIt:
    $oTrainData.getSamples() -> retval
```

### cv::ml::TrainData::getMissing

```cpp
cv::Mat cv::ml::TrainData::getMissing()

AutoIt:
    $oTrainData.getMissing() -> retval
```

### cv::ml::TrainData::getTrainSamples

```cpp
cv::Mat cv::ml::TrainData::getTrainSamples( int  layout = ROW_SAMPLE,
                                            bool compressSamples = true,
                                            bool compressVars = true )

AutoIt:
    $oTrainData.getTrainSamples( [$layout[, $compressSamples[, $compressVars]]] ) -> retval
```

### cv::ml::TrainData::getTrainResponses

```cpp
cv::Mat cv::ml::TrainData::getTrainResponses()

AutoIt:
    $oTrainData.getTrainResponses() -> retval
```

### cv::ml::TrainData::getTrainNormCatResponses

```cpp
cv::Mat cv::ml::TrainData::getTrainNormCatResponses()

AutoIt:
    $oTrainData.getTrainNormCatResponses() -> retval
```

### cv::ml::TrainData::getTestResponses

```cpp
cv::Mat cv::ml::TrainData::getTestResponses()

AutoIt:
    $oTrainData.getTestResponses() -> retval
```

### cv::ml::TrainData::getTestNormCatResponses

```cpp
cv::Mat cv::ml::TrainData::getTestNormCatResponses()

AutoIt:
    $oTrainData.getTestNormCatResponses() -> retval
```

### cv::ml::TrainData::getResponses

```cpp
cv::Mat cv::ml::TrainData::getResponses()

AutoIt:
    $oTrainData.getResponses() -> retval
```

### cv::ml::TrainData::getNormCatResponses

```cpp
cv::Mat cv::ml::TrainData::getNormCatResponses()

AutoIt:
    $oTrainData.getNormCatResponses() -> retval
```

### cv::ml::TrainData::getSampleWeights

```cpp
cv::Mat cv::ml::TrainData::getSampleWeights()

AutoIt:
    $oTrainData.getSampleWeights() -> retval
```

### cv::ml::TrainData::getTrainSampleWeights

```cpp
cv::Mat cv::ml::TrainData::getTrainSampleWeights()

AutoIt:
    $oTrainData.getTrainSampleWeights() -> retval
```

### cv::ml::TrainData::getTestSampleWeights

```cpp
cv::Mat cv::ml::TrainData::getTestSampleWeights()

AutoIt:
    $oTrainData.getTestSampleWeights() -> retval
```

### cv::ml::TrainData::getVarIdx

```cpp
cv::Mat cv::ml::TrainData::getVarIdx()

AutoIt:
    $oTrainData.getVarIdx() -> retval
```

### cv::ml::TrainData::getVarType

```cpp
cv::Mat cv::ml::TrainData::getVarType()

AutoIt:
    $oTrainData.getVarType() -> retval
```

### cv::ml::TrainData::getVarSymbolFlags

```cpp
cv::Mat cv::ml::TrainData::getVarSymbolFlags()

AutoIt:
    $oTrainData.getVarSymbolFlags() -> retval
```

### cv::ml::TrainData::getResponseType

```cpp
int cv::ml::TrainData::getResponseType()

AutoIt:
    $oTrainData.getResponseType() -> retval
```

### cv::ml::TrainData::getTrainSampleIdx

```cpp
cv::Mat cv::ml::TrainData::getTrainSampleIdx()

AutoIt:
    $oTrainData.getTrainSampleIdx() -> retval
```

### cv::ml::TrainData::getTestSampleIdx

```cpp
cv::Mat cv::ml::TrainData::getTestSampleIdx()

AutoIt:
    $oTrainData.getTestSampleIdx() -> retval
```

### cv::ml::TrainData::getValues

```cpp
void cv::ml::TrainData::getValues( int         vi,
                                   _InputArray sidx,
                                   float*      values )

AutoIt:
    $oTrainData.getValues( $vi, $sidx[, $values] ) -> $values
```

### cv::ml::TrainData::getDefaultSubstValues

```cpp
cv::Mat cv::ml::TrainData::getDefaultSubstValues()

AutoIt:
    $oTrainData.getDefaultSubstValues() -> retval
```

### cv::ml::TrainData::getCatCount

```cpp
int cv::ml::TrainData::getCatCount( int vi )

AutoIt:
    $oTrainData.getCatCount( $vi ) -> retval
```

### cv::ml::TrainData::getClassLabels

```cpp
cv::Mat cv::ml::TrainData::getClassLabels()

AutoIt:
    $oTrainData.getClassLabels() -> retval
```

### cv::ml::TrainData::getCatOfs

```cpp
cv::Mat cv::ml::TrainData::getCatOfs()

AutoIt:
    $oTrainData.getCatOfs() -> retval
```

### cv::ml::TrainData::getCatMap

```cpp
cv::Mat cv::ml::TrainData::getCatMap()

AutoIt:
    $oTrainData.getCatMap() -> retval
```

### cv::ml::TrainData::setTrainTestSplit

```cpp
void cv::ml::TrainData::setTrainTestSplit( int  count,
                                           bool shuffle = true )

AutoIt:
    $oTrainData.setTrainTestSplit( $count[, $shuffle] ) -> None
```

### cv::ml::TrainData::setTrainTestSplitRatio

```cpp
void cv::ml::TrainData::setTrainTestSplitRatio( double ratio,
                                                bool   shuffle = true )

AutoIt:
    $oTrainData.setTrainTestSplitRatio( $ratio[, $shuffle] ) -> None
```

### cv::ml::TrainData::shuffleTrainTest

```cpp
void cv::ml::TrainData::shuffleTrainTest()

AutoIt:
    $oTrainData.shuffleTrainTest() -> None
```

### cv::ml::TrainData::getTestSamples

```cpp
cv::Mat cv::ml::TrainData::getTestSamples()

AutoIt:
    $oTrainData.getTestSamples() -> retval
```

### cv::ml::TrainData::getNames

```cpp
void cv::ml::TrainData::getNames( std::vector<std::string>& names )

AutoIt:
    $oTrainData.getNames( $names ) -> None
```

### cv::ml::TrainData::getSubVector

```cpp
static cv::Mat cv::ml::TrainData::getSubVector( const cv::Mat& vec,
                                                const cv::Mat& idx )

AutoIt:
    _OpenCV_ObjCreate("cv.ml.TrainData").getSubVector( $vec, $idx ) -> retval
```

### cv::ml::TrainData::getSubMatrix

```cpp
static cv::Mat cv::ml::TrainData::getSubMatrix( const cv::Mat& matrix,
                                                const cv::Mat& idx,
                                                int            layout )

AutoIt:
    _OpenCV_ObjCreate("cv.ml.TrainData").getSubMatrix( $matrix, $idx, $layout ) -> retval
```

### cv::ml::TrainData::create

```cpp
static cv::Ptr<cv::ml::TrainData> cv::ml::TrainData::create( _InputArray samples,
                                                             int         layout,
                                                             _InputArray responses,
                                                             _InputArray varIdx = noArray(),
                                                             _InputArray sampleIdx = noArray(),
                                                             _InputArray sampleWeights = noArray(),
                                                             _InputArray varType = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv.ml.TrainData").create( $samples, $layout, $responses[, $varIdx[, $sampleIdx[, $sampleWeights[, $varType]]]] ) -> retval
```

## cv::ml::StatModel

### cv::ml::StatModel::getVarCount

```cpp
int cv::ml::StatModel::getVarCount()

AutoIt:
    $oStatModel.getVarCount() -> retval
```

### cv::ml::StatModel::empty

```cpp
bool cv::ml::StatModel::empty()

AutoIt:
    $oStatModel.empty() -> retval
```

### cv::ml::StatModel::isTrained

```cpp
bool cv::ml::StatModel::isTrained()

AutoIt:
    $oStatModel.isTrained() -> retval
```

### cv::ml::StatModel::isClassifier

```cpp
bool cv::ml::StatModel::isClassifier()

AutoIt:
    $oStatModel.isClassifier() -> retval
```

### cv::ml::StatModel::train

```cpp
bool cv::ml::StatModel::train( const cv::Ptr<cv::ml::TrainData>& trainData,
                               int                               flags = 0 )

AutoIt:
    $oStatModel.train( $trainData[, $flags] ) -> retval
```

```cpp
bool cv::ml::StatModel::train( _InputArray samples,
                               int         layout,
                               _InputArray responses )

AutoIt:
    $oStatModel.train( $samples, $layout, $responses ) -> retval
```

### cv::ml::StatModel::calcError

```cpp
float cv::ml::StatModel::calcError( const cv::Ptr<cv::ml::TrainData>& data,
                                    bool                              test,
                                    _OutputArray                      resp )

AutoIt:
    $oStatModel.calcError( $data, $test[, $resp] ) -> retval, $resp
```

### cv::ml::StatModel::predict

```cpp
float cv::ml::StatModel::predict( _InputArray  samples,
                                  _OutputArray results = noArray(),
                                  int          flags = 0 )

AutoIt:
    $oStatModel.predict( $samples[, $results[, $flags]] ) -> retval, $results
```

### cv::ml::StatModel::clear

```cpp
void cv::ml::StatModel::clear()

AutoIt:
    $oStatModel.clear() -> None
```

### cv::ml::StatModel::write

```cpp
void cv::ml::StatModel::write( const cv::Ptr<cv::FileStorage>& fs,
                               const std::string&              name = String() )

AutoIt:
    $oStatModel.write( $fs[, $name] ) -> None
```

### cv::ml::StatModel::read

```cpp
void cv::ml::StatModel::read( const cv::FileNode& fn )

AutoIt:
    $oStatModel.read( $fn ) -> None
```

### cv::ml::StatModel::save

```cpp
void cv::ml::StatModel::save( const std::string& filename )

AutoIt:
    $oStatModel.save( $filename ) -> None
```

### cv::ml::StatModel::getDefaultName

```cpp
std::string cv::ml::StatModel::getDefaultName()

AutoIt:
    $oStatModel.getDefaultName() -> retval
```

## cv::ml::NormalBayesClassifier

### cv::ml::NormalBayesClassifier::predictProb

```cpp
float cv::ml::NormalBayesClassifier::predictProb( _InputArray  inputs,
                                                  _OutputArray outputs,
                                                  _OutputArray outputProbs,
                                                  int          flags = 0 )

AutoIt:
    $oNormalBayesClassifier.predictProb( $inputs[, $outputs[, $outputProbs[, $flags]]] ) -> retval, $outputs, $outputProbs
```

### cv::ml::NormalBayesClassifier::create

```cpp
static cv::Ptr<cv::ml::NormalBayesClassifier> cv::ml::NormalBayesClassifier::create()

AutoIt:
    _OpenCV_ObjCreate("cv.ml.NormalBayesClassifier").create() -> retval
```

### cv::ml::NormalBayesClassifier::load

```cpp
static cv::Ptr<cv::ml::NormalBayesClassifier> cv::ml::NormalBayesClassifier::load( const std::string& filepath,
                                                                                   const std::string& nodeName = String() )

AutoIt:
    _OpenCV_ObjCreate("cv.ml.NormalBayesClassifier").load( $filepath[, $nodeName] ) -> retval
```

### cv::ml::NormalBayesClassifier::getVarCount

```cpp
int cv::ml::NormalBayesClassifier::getVarCount()

AutoIt:
    $oNormalBayesClassifier.getVarCount() -> retval
```

### cv::ml::NormalBayesClassifier::empty

```cpp
bool cv::ml::NormalBayesClassifier::empty()

AutoIt:
    $oNormalBayesClassifier.empty() -> retval
```

### cv::ml::NormalBayesClassifier::isTrained

```cpp
bool cv::ml::NormalBayesClassifier::isTrained()

AutoIt:
    $oNormalBayesClassifier.isTrained() -> retval
```

### cv::ml::NormalBayesClassifier::isClassifier

```cpp
bool cv::ml::NormalBayesClassifier::isClassifier()

AutoIt:
    $oNormalBayesClassifier.isClassifier() -> retval
```

### cv::ml::NormalBayesClassifier::train

```cpp
bool cv::ml::NormalBayesClassifier::train( const cv::Ptr<cv::ml::TrainData>& trainData,
                                           int                               flags = 0 )

AutoIt:
    $oNormalBayesClassifier.train( $trainData[, $flags] ) -> retval
```

```cpp
bool cv::ml::NormalBayesClassifier::train( _InputArray samples,
                                           int         layout,
                                           _InputArray responses )

AutoIt:
    $oNormalBayesClassifier.train( $samples, $layout, $responses ) -> retval
```

### cv::ml::NormalBayesClassifier::calcError

```cpp
float cv::ml::NormalBayesClassifier::calcError( const cv::Ptr<cv::ml::TrainData>& data,
                                                bool                              test,
                                                _OutputArray                      resp )

AutoIt:
    $oNormalBayesClassifier.calcError( $data, $test[, $resp] ) -> retval, $resp
```

### cv::ml::NormalBayesClassifier::predict

```cpp
float cv::ml::NormalBayesClassifier::predict( _InputArray  samples,
                                              _OutputArray results = noArray(),
                                              int          flags = 0 )

AutoIt:
    $oNormalBayesClassifier.predict( $samples[, $results[, $flags]] ) -> retval, $results
```

### cv::ml::NormalBayesClassifier::clear

```cpp
void cv::ml::NormalBayesClassifier::clear()

AutoIt:
    $oNormalBayesClassifier.clear() -> None
```

### cv::ml::NormalBayesClassifier::write

```cpp
void cv::ml::NormalBayesClassifier::write( const cv::Ptr<cv::FileStorage>& fs,
                                           const std::string&              name = String() )

AutoIt:
    $oNormalBayesClassifier.write( $fs[, $name] ) -> None
```

### cv::ml::NormalBayesClassifier::read

```cpp
void cv::ml::NormalBayesClassifier::read( const cv::FileNode& fn )

AutoIt:
    $oNormalBayesClassifier.read( $fn ) -> None
```

### cv::ml::NormalBayesClassifier::save

```cpp
void cv::ml::NormalBayesClassifier::save( const std::string& filename )

AutoIt:
    $oNormalBayesClassifier.save( $filename ) -> None
```

### cv::ml::NormalBayesClassifier::getDefaultName

```cpp
std::string cv::ml::NormalBayesClassifier::getDefaultName()

AutoIt:
    $oNormalBayesClassifier.getDefaultName() -> retval
```

## cv::ml::KNearest

### cv::ml::KNearest::getDefaultK

```cpp
int cv::ml::KNearest::getDefaultK()

AutoIt:
    $oKNearest.getDefaultK() -> retval
```

### cv::ml::KNearest::setDefaultK

```cpp
void cv::ml::KNearest::setDefaultK( int val )

AutoIt:
    $oKNearest.setDefaultK( $val ) -> None
```

### cv::ml::KNearest::getIsClassifier

```cpp
bool cv::ml::KNearest::getIsClassifier()

AutoIt:
    $oKNearest.getIsClassifier() -> retval
```

### cv::ml::KNearest::setIsClassifier

```cpp
void cv::ml::KNearest::setIsClassifier( bool val )

AutoIt:
    $oKNearest.setIsClassifier( $val ) -> None
```

### cv::ml::KNearest::getEmax

```cpp
int cv::ml::KNearest::getEmax()

AutoIt:
    $oKNearest.getEmax() -> retval
```

### cv::ml::KNearest::setEmax

```cpp
void cv::ml::KNearest::setEmax( int val )

AutoIt:
    $oKNearest.setEmax( $val ) -> None
```

### cv::ml::KNearest::getAlgorithmType

```cpp
int cv::ml::KNearest::getAlgorithmType()

AutoIt:
    $oKNearest.getAlgorithmType() -> retval
```

### cv::ml::KNearest::setAlgorithmType

```cpp
void cv::ml::KNearest::setAlgorithmType( int val )

AutoIt:
    $oKNearest.setAlgorithmType( $val ) -> None
```

### cv::ml::KNearest::findNearest

```cpp
float cv::ml::KNearest::findNearest( _InputArray  samples,
                                     int          k,
                                     _OutputArray results,
                                     _OutputArray neighborResponses = noArray(),
                                     _OutputArray dist = noArray() )

AutoIt:
    $oKNearest.findNearest( $samples, $k[, $results[, $neighborResponses[, $dist]]] ) -> retval, $results, $neighborResponses, $dist
```

### cv::ml::KNearest::create

```cpp
static cv::Ptr<cv::ml::KNearest> cv::ml::KNearest::create()

AutoIt:
    _OpenCV_ObjCreate("cv.ml.KNearest").create() -> retval
```

### cv::ml::KNearest::load

```cpp
static cv::Ptr<cv::ml::KNearest> cv::ml::KNearest::load( const std::string& filepath )

AutoIt:
    _OpenCV_ObjCreate("cv.ml.KNearest").load( $filepath ) -> retval
```

### cv::ml::KNearest::getVarCount

```cpp
int cv::ml::KNearest::getVarCount()

AutoIt:
    $oKNearest.getVarCount() -> retval
```

### cv::ml::KNearest::empty

```cpp
bool cv::ml::KNearest::empty()

AutoIt:
    $oKNearest.empty() -> retval
```

### cv::ml::KNearest::isTrained

```cpp
bool cv::ml::KNearest::isTrained()

AutoIt:
    $oKNearest.isTrained() -> retval
```

### cv::ml::KNearest::isClassifier

```cpp
bool cv::ml::KNearest::isClassifier()

AutoIt:
    $oKNearest.isClassifier() -> retval
```

### cv::ml::KNearest::train

```cpp
bool cv::ml::KNearest::train( const cv::Ptr<cv::ml::TrainData>& trainData,
                              int                               flags = 0 )

AutoIt:
    $oKNearest.train( $trainData[, $flags] ) -> retval
```

```cpp
bool cv::ml::KNearest::train( _InputArray samples,
                              int         layout,
                              _InputArray responses )

AutoIt:
    $oKNearest.train( $samples, $layout, $responses ) -> retval
```

### cv::ml::KNearest::calcError

```cpp
float cv::ml::KNearest::calcError( const cv::Ptr<cv::ml::TrainData>& data,
                                   bool                              test,
                                   _OutputArray                      resp )

AutoIt:
    $oKNearest.calcError( $data, $test[, $resp] ) -> retval, $resp
```

### cv::ml::KNearest::predict

```cpp
float cv::ml::KNearest::predict( _InputArray  samples,
                                 _OutputArray results = noArray(),
                                 int          flags = 0 )

AutoIt:
    $oKNearest.predict( $samples[, $results[, $flags]] ) -> retval, $results
```

### cv::ml::KNearest::clear

```cpp
void cv::ml::KNearest::clear()

AutoIt:
    $oKNearest.clear() -> None
```

### cv::ml::KNearest::write

```cpp
void cv::ml::KNearest::write( const cv::Ptr<cv::FileStorage>& fs,
                              const std::string&              name = String() )

AutoIt:
    $oKNearest.write( $fs[, $name] ) -> None
```

### cv::ml::KNearest::read

```cpp
void cv::ml::KNearest::read( const cv::FileNode& fn )

AutoIt:
    $oKNearest.read( $fn ) -> None
```

### cv::ml::KNearest::save

```cpp
void cv::ml::KNearest::save( const std::string& filename )

AutoIt:
    $oKNearest.save( $filename ) -> None
```

### cv::ml::KNearest::getDefaultName

```cpp
std::string cv::ml::KNearest::getDefaultName()

AutoIt:
    $oKNearest.getDefaultName() -> retval
```

## cv::ml::SVM

### cv::ml::SVM::getType

```cpp
int cv::ml::SVM::getType()

AutoIt:
    $oSVM.getType() -> retval
```

### cv::ml::SVM::setType

```cpp
void cv::ml::SVM::setType( int val )

AutoIt:
    $oSVM.setType( $val ) -> None
```

### cv::ml::SVM::getGamma

```cpp
double cv::ml::SVM::getGamma()

AutoIt:
    $oSVM.getGamma() -> retval
```

### cv::ml::SVM::setGamma

```cpp
void cv::ml::SVM::setGamma( double val )

AutoIt:
    $oSVM.setGamma( $val ) -> None
```

### cv::ml::SVM::getCoef0

```cpp
double cv::ml::SVM::getCoef0()

AutoIt:
    $oSVM.getCoef0() -> retval
```

### cv::ml::SVM::setCoef0

```cpp
void cv::ml::SVM::setCoef0( double val )

AutoIt:
    $oSVM.setCoef0( $val ) -> None
```

### cv::ml::SVM::getDegree

```cpp
double cv::ml::SVM::getDegree()

AutoIt:
    $oSVM.getDegree() -> retval
```

### cv::ml::SVM::setDegree

```cpp
void cv::ml::SVM::setDegree( double val )

AutoIt:
    $oSVM.setDegree( $val ) -> None
```

### cv::ml::SVM::getC

```cpp
double cv::ml::SVM::getC()

AutoIt:
    $oSVM.getC() -> retval
```

### cv::ml::SVM::setC

```cpp
void cv::ml::SVM::setC( double val )

AutoIt:
    $oSVM.setC( $val ) -> None
```

### cv::ml::SVM::getNu

```cpp
double cv::ml::SVM::getNu()

AutoIt:
    $oSVM.getNu() -> retval
```

### cv::ml::SVM::setNu

```cpp
void cv::ml::SVM::setNu( double val )

AutoIt:
    $oSVM.setNu( $val ) -> None
```

### cv::ml::SVM::getP

```cpp
double cv::ml::SVM::getP()

AutoIt:
    $oSVM.getP() -> retval
```

### cv::ml::SVM::setP

```cpp
void cv::ml::SVM::setP( double val )

AutoIt:
    $oSVM.setP( $val ) -> None
```

### cv::ml::SVM::getClassWeights

```cpp
cv::Mat cv::ml::SVM::getClassWeights()

AutoIt:
    $oSVM.getClassWeights() -> retval
```

### cv::ml::SVM::setClassWeights

```cpp
void cv::ml::SVM::setClassWeights( const cv::Mat& val )

AutoIt:
    $oSVM.setClassWeights( $val ) -> None
```

### cv::ml::SVM::getTermCriteria

```cpp
cv::TermCriteria cv::ml::SVM::getTermCriteria()

AutoIt:
    $oSVM.getTermCriteria() -> retval
```

### cv::ml::SVM::setTermCriteria

```cpp
void cv::ml::SVM::setTermCriteria( const cv::TermCriteria& val )

AutoIt:
    $oSVM.setTermCriteria( $val ) -> None
```

### cv::ml::SVM::getKernelType

```cpp
int cv::ml::SVM::getKernelType()

AutoIt:
    $oSVM.getKernelType() -> retval
```

### cv::ml::SVM::setKernel

```cpp
void cv::ml::SVM::setKernel( int kernelType )

AutoIt:
    $oSVM.setKernel( $kernelType ) -> None
```

### cv::ml::SVM::trainAuto

```cpp
bool cv::ml::SVM::trainAuto( _InputArray                samples,
                             int                        layout,
                             _InputArray                responses,
                             int                        kFold = 10,
                             cv::Ptr<cv::ml::ParamGrid> Cgrid = SVM::getDefaultGridPtr(SVM::C),
                             cv::Ptr<cv::ml::ParamGrid> gammaGrid = SVM::getDefaultGridPtr(SVM::GAMMA),
                             cv::Ptr<cv::ml::ParamGrid> pGrid = SVM::getDefaultGridPtr(SVM::P),
                             cv::Ptr<cv::ml::ParamGrid> nuGrid = SVM::getDefaultGridPtr(SVM::NU),
                             cv::Ptr<cv::ml::ParamGrid> coeffGrid = SVM::getDefaultGridPtr(SVM::COEF),
                             cv::Ptr<cv::ml::ParamGrid> degreeGrid = SVM::getDefaultGridPtr(SVM::DEGREE),
                             bool                       balanced = false )

AutoIt:
    $oSVM.trainAuto( $samples, $layout, $responses[, $kFold[, $Cgrid[, $gammaGrid[, $pGrid[, $nuGrid[, $coeffGrid[, $degreeGrid[, $balanced]]]]]]]] ) -> retval
```

### cv::ml::SVM::getSupportVectors

```cpp
cv::Mat cv::ml::SVM::getSupportVectors()

AutoIt:
    $oSVM.getSupportVectors() -> retval
```

### cv::ml::SVM::getUncompressedSupportVectors

```cpp
cv::Mat cv::ml::SVM::getUncompressedSupportVectors()

AutoIt:
    $oSVM.getUncompressedSupportVectors() -> retval
```

### cv::ml::SVM::getDecisionFunction

```cpp
double cv::ml::SVM::getDecisionFunction( int          i,
                                         _OutputArray alpha,
                                         _OutputArray svidx )

AutoIt:
    $oSVM.getDecisionFunction( $i[, $alpha[, $svidx]] ) -> retval, $alpha, $svidx
```

### cv::ml::SVM::getDefaultGridPtr

```cpp
static cv::Ptr<cv::ml::ParamGrid> cv::ml::SVM::getDefaultGridPtr( int param_id )

AutoIt:
    _OpenCV_ObjCreate("cv.ml.SVM").getDefaultGridPtr( $param_id ) -> retval
```

### cv::ml::SVM::create

```cpp
static cv::Ptr<cv::ml::SVM> cv::ml::SVM::create()

AutoIt:
    _OpenCV_ObjCreate("cv.ml.SVM").create() -> retval
```

### cv::ml::SVM::load

```cpp
static cv::Ptr<cv::ml::SVM> cv::ml::SVM::load( const std::string& filepath )

AutoIt:
    _OpenCV_ObjCreate("cv.ml.SVM").load( $filepath ) -> retval
```

### cv::ml::SVM::getVarCount

```cpp
int cv::ml::SVM::getVarCount()

AutoIt:
    $oSVM.getVarCount() -> retval
```

### cv::ml::SVM::empty

```cpp
bool cv::ml::SVM::empty()

AutoIt:
    $oSVM.empty() -> retval
```

### cv::ml::SVM::isTrained

```cpp
bool cv::ml::SVM::isTrained()

AutoIt:
    $oSVM.isTrained() -> retval
```

### cv::ml::SVM::isClassifier

```cpp
bool cv::ml::SVM::isClassifier()

AutoIt:
    $oSVM.isClassifier() -> retval
```

### cv::ml::SVM::train

```cpp
bool cv::ml::SVM::train( const cv::Ptr<cv::ml::TrainData>& trainData,
                         int                               flags = 0 )

AutoIt:
    $oSVM.train( $trainData[, $flags] ) -> retval
```

```cpp
bool cv::ml::SVM::train( _InputArray samples,
                         int         layout,
                         _InputArray responses )

AutoIt:
    $oSVM.train( $samples, $layout, $responses ) -> retval
```

### cv::ml::SVM::calcError

```cpp
float cv::ml::SVM::calcError( const cv::Ptr<cv::ml::TrainData>& data,
                              bool                              test,
                              _OutputArray                      resp )

AutoIt:
    $oSVM.calcError( $data, $test[, $resp] ) -> retval, $resp
```

### cv::ml::SVM::predict

```cpp
float cv::ml::SVM::predict( _InputArray  samples,
                            _OutputArray results = noArray(),
                            int          flags = 0 )

AutoIt:
    $oSVM.predict( $samples[, $results[, $flags]] ) -> retval, $results
```

### cv::ml::SVM::clear

```cpp
void cv::ml::SVM::clear()

AutoIt:
    $oSVM.clear() -> None
```

### cv::ml::SVM::write

```cpp
void cv::ml::SVM::write( const cv::Ptr<cv::FileStorage>& fs,
                         const std::string&              name = String() )

AutoIt:
    $oSVM.write( $fs[, $name] ) -> None
```

### cv::ml::SVM::read

```cpp
void cv::ml::SVM::read( const cv::FileNode& fn )

AutoIt:
    $oSVM.read( $fn ) -> None
```

### cv::ml::SVM::save

```cpp
void cv::ml::SVM::save( const std::string& filename )

AutoIt:
    $oSVM.save( $filename ) -> None
```

### cv::ml::SVM::getDefaultName

```cpp
std::string cv::ml::SVM::getDefaultName()

AutoIt:
    $oSVM.getDefaultName() -> retval
```

## cv::ml::EM

### cv::ml::EM::getClustersNumber

```cpp
int cv::ml::EM::getClustersNumber()

AutoIt:
    $oEM.getClustersNumber() -> retval
```

### cv::ml::EM::setClustersNumber

```cpp
void cv::ml::EM::setClustersNumber( int val )

AutoIt:
    $oEM.setClustersNumber( $val ) -> None
```

### cv::ml::EM::getCovarianceMatrixType

```cpp
int cv::ml::EM::getCovarianceMatrixType()

AutoIt:
    $oEM.getCovarianceMatrixType() -> retval
```

### cv::ml::EM::setCovarianceMatrixType

```cpp
void cv::ml::EM::setCovarianceMatrixType( int val )

AutoIt:
    $oEM.setCovarianceMatrixType( $val ) -> None
```

### cv::ml::EM::getTermCriteria

```cpp
cv::TermCriteria cv::ml::EM::getTermCriteria()

AutoIt:
    $oEM.getTermCriteria() -> retval
```

### cv::ml::EM::setTermCriteria

```cpp
void cv::ml::EM::setTermCriteria( const cv::TermCriteria& val )

AutoIt:
    $oEM.setTermCriteria( $val ) -> None
```

### cv::ml::EM::getWeights

```cpp
cv::Mat cv::ml::EM::getWeights()

AutoIt:
    $oEM.getWeights() -> retval
```

### cv::ml::EM::getMeans

```cpp
cv::Mat cv::ml::EM::getMeans()

AutoIt:
    $oEM.getMeans() -> retval
```

### cv::ml::EM::getCovs

```cpp
void cv::ml::EM::getCovs( std::vector<cv::Mat>& covs )

AutoIt:
    $oEM.getCovs( [$covs] ) -> $covs
```

### cv::ml::EM::predict

```cpp
float cv::ml::EM::predict( _InputArray  samples,
                           _OutputArray results = noArray(),
                           int          flags = 0 )

AutoIt:
    $oEM.predict( $samples[, $results[, $flags]] ) -> retval, $results
```

### cv::ml::EM::predict2

```cpp
cv::Vec2d cv::ml::EM::predict2( _InputArray  sample,
                                _OutputArray probs )

AutoIt:
    $oEM.predict2( $sample[, $probs] ) -> retval, $probs
```

### cv::ml::EM::trainEM

```cpp
bool cv::ml::EM::trainEM( _InputArray  samples,
                          _OutputArray logLikelihoods = noArray(),
                          _OutputArray labels = noArray(),
                          _OutputArray probs = noArray() )

AutoIt:
    $oEM.trainEM( $samples[, $logLikelihoods[, $labels[, $probs]]] ) -> retval, $logLikelihoods, $labels, $probs
```

### cv::ml::EM::trainE

```cpp
bool cv::ml::EM::trainE( _InputArray  samples,
                         _InputArray  means0,
                         _InputArray  covs0 = noArray(),
                         _InputArray  weights0 = noArray(),
                         _OutputArray logLikelihoods = noArray(),
                         _OutputArray labels = noArray(),
                         _OutputArray probs = noArray() )

AutoIt:
    $oEM.trainE( $samples, $means0[, $covs0[, $weights0[, $logLikelihoods[, $labels[, $probs]]]]] ) -> retval, $logLikelihoods, $labels, $probs
```

### cv::ml::EM::trainM

```cpp
bool cv::ml::EM::trainM( _InputArray  samples,
                         _InputArray  probs0,
                         _OutputArray logLikelihoods = noArray(),
                         _OutputArray labels = noArray(),
                         _OutputArray probs = noArray() )

AutoIt:
    $oEM.trainM( $samples, $probs0[, $logLikelihoods[, $labels[, $probs]]] ) -> retval, $logLikelihoods, $labels, $probs
```

### cv::ml::EM::create

```cpp
static cv::Ptr<cv::ml::EM> cv::ml::EM::create()

AutoIt:
    _OpenCV_ObjCreate("cv.ml.EM").create() -> retval
```

### cv::ml::EM::load

```cpp
static cv::Ptr<cv::ml::EM> cv::ml::EM::load( const std::string& filepath,
                                             const std::string& nodeName = String() )

AutoIt:
    _OpenCV_ObjCreate("cv.ml.EM").load( $filepath[, $nodeName] ) -> retval
```

### cv::ml::EM::getVarCount

```cpp
int cv::ml::EM::getVarCount()

AutoIt:
    $oEM.getVarCount() -> retval
```

### cv::ml::EM::empty

```cpp
bool cv::ml::EM::empty()

AutoIt:
    $oEM.empty() -> retval
```

### cv::ml::EM::isTrained

```cpp
bool cv::ml::EM::isTrained()

AutoIt:
    $oEM.isTrained() -> retval
```

### cv::ml::EM::isClassifier

```cpp
bool cv::ml::EM::isClassifier()

AutoIt:
    $oEM.isClassifier() -> retval
```

### cv::ml::EM::train

```cpp
bool cv::ml::EM::train( const cv::Ptr<cv::ml::TrainData>& trainData,
                        int                               flags = 0 )

AutoIt:
    $oEM.train( $trainData[, $flags] ) -> retval
```

```cpp
bool cv::ml::EM::train( _InputArray samples,
                        int         layout,
                        _InputArray responses )

AutoIt:
    $oEM.train( $samples, $layout, $responses ) -> retval
```

### cv::ml::EM::calcError

```cpp
float cv::ml::EM::calcError( const cv::Ptr<cv::ml::TrainData>& data,
                             bool                              test,
                             _OutputArray                      resp )

AutoIt:
    $oEM.calcError( $data, $test[, $resp] ) -> retval, $resp
```

### cv::ml::EM::clear

```cpp
void cv::ml::EM::clear()

AutoIt:
    $oEM.clear() -> None
```

### cv::ml::EM::write

```cpp
void cv::ml::EM::write( const cv::Ptr<cv::FileStorage>& fs,
                        const std::string&              name = String() )

AutoIt:
    $oEM.write( $fs[, $name] ) -> None
```

### cv::ml::EM::read

```cpp
void cv::ml::EM::read( const cv::FileNode& fn )

AutoIt:
    $oEM.read( $fn ) -> None
```

### cv::ml::EM::save

```cpp
void cv::ml::EM::save( const std::string& filename )

AutoIt:
    $oEM.save( $filename ) -> None
```

### cv::ml::EM::getDefaultName

```cpp
std::string cv::ml::EM::getDefaultName()

AutoIt:
    $oEM.getDefaultName() -> retval
```

## cv::ml::DTrees

### cv::ml::DTrees::getMaxCategories

```cpp
int cv::ml::DTrees::getMaxCategories()

AutoIt:
    $oDTrees.getMaxCategories() -> retval
```

### cv::ml::DTrees::setMaxCategories

```cpp
void cv::ml::DTrees::setMaxCategories( int val )

AutoIt:
    $oDTrees.setMaxCategories( $val ) -> None
```

### cv::ml::DTrees::getMaxDepth

```cpp
int cv::ml::DTrees::getMaxDepth()

AutoIt:
    $oDTrees.getMaxDepth() -> retval
```

### cv::ml::DTrees::setMaxDepth

```cpp
void cv::ml::DTrees::setMaxDepth( int val )

AutoIt:
    $oDTrees.setMaxDepth( $val ) -> None
```

### cv::ml::DTrees::getMinSampleCount

```cpp
int cv::ml::DTrees::getMinSampleCount()

AutoIt:
    $oDTrees.getMinSampleCount() -> retval
```

### cv::ml::DTrees::setMinSampleCount

```cpp
void cv::ml::DTrees::setMinSampleCount( int val )

AutoIt:
    $oDTrees.setMinSampleCount( $val ) -> None
```

### cv::ml::DTrees::getCVFolds

```cpp
int cv::ml::DTrees::getCVFolds()

AutoIt:
    $oDTrees.getCVFolds() -> retval
```

### cv::ml::DTrees::setCVFolds

```cpp
void cv::ml::DTrees::setCVFolds( int val )

AutoIt:
    $oDTrees.setCVFolds( $val ) -> None
```

### cv::ml::DTrees::getUseSurrogates

```cpp
bool cv::ml::DTrees::getUseSurrogates()

AutoIt:
    $oDTrees.getUseSurrogates() -> retval
```

### cv::ml::DTrees::setUseSurrogates

```cpp
void cv::ml::DTrees::setUseSurrogates( bool val )

AutoIt:
    $oDTrees.setUseSurrogates( $val ) -> None
```

### cv::ml::DTrees::getUse1SERule

```cpp
bool cv::ml::DTrees::getUse1SERule()

AutoIt:
    $oDTrees.getUse1SERule() -> retval
```

### cv::ml::DTrees::setUse1SERule

```cpp
void cv::ml::DTrees::setUse1SERule( bool val )

AutoIt:
    $oDTrees.setUse1SERule( $val ) -> None
```

### cv::ml::DTrees::getTruncatePrunedTree

```cpp
bool cv::ml::DTrees::getTruncatePrunedTree()

AutoIt:
    $oDTrees.getTruncatePrunedTree() -> retval
```

### cv::ml::DTrees::setTruncatePrunedTree

```cpp
void cv::ml::DTrees::setTruncatePrunedTree( bool val )

AutoIt:
    $oDTrees.setTruncatePrunedTree( $val ) -> None
```

### cv::ml::DTrees::getRegressionAccuracy

```cpp
float cv::ml::DTrees::getRegressionAccuracy()

AutoIt:
    $oDTrees.getRegressionAccuracy() -> retval
```

### cv::ml::DTrees::setRegressionAccuracy

```cpp
void cv::ml::DTrees::setRegressionAccuracy( float val )

AutoIt:
    $oDTrees.setRegressionAccuracy( $val ) -> None
```

### cv::ml::DTrees::getPriors

```cpp
cv::Mat cv::ml::DTrees::getPriors()

AutoIt:
    $oDTrees.getPriors() -> retval
```

### cv::ml::DTrees::setPriors

```cpp
void cv::ml::DTrees::setPriors( const cv::Mat& val )

AutoIt:
    $oDTrees.setPriors( $val ) -> None
```

### cv::ml::DTrees::create

```cpp
static cv::Ptr<cv::ml::DTrees> cv::ml::DTrees::create()

AutoIt:
    _OpenCV_ObjCreate("cv.ml.DTrees").create() -> retval
```

### cv::ml::DTrees::load

```cpp
static cv::Ptr<cv::ml::DTrees> cv::ml::DTrees::load( const std::string& filepath,
                                                     const std::string& nodeName = String() )

AutoIt:
    _OpenCV_ObjCreate("cv.ml.DTrees").load( $filepath[, $nodeName] ) -> retval
```

### cv::ml::DTrees::getVarCount

```cpp
int cv::ml::DTrees::getVarCount()

AutoIt:
    $oDTrees.getVarCount() -> retval
```

### cv::ml::DTrees::empty

```cpp
bool cv::ml::DTrees::empty()

AutoIt:
    $oDTrees.empty() -> retval
```

### cv::ml::DTrees::isTrained

```cpp
bool cv::ml::DTrees::isTrained()

AutoIt:
    $oDTrees.isTrained() -> retval
```

### cv::ml::DTrees::isClassifier

```cpp
bool cv::ml::DTrees::isClassifier()

AutoIt:
    $oDTrees.isClassifier() -> retval
```

### cv::ml::DTrees::train

```cpp
bool cv::ml::DTrees::train( const cv::Ptr<cv::ml::TrainData>& trainData,
                            int                               flags = 0 )

AutoIt:
    $oDTrees.train( $trainData[, $flags] ) -> retval
```

```cpp
bool cv::ml::DTrees::train( _InputArray samples,
                            int         layout,
                            _InputArray responses )

AutoIt:
    $oDTrees.train( $samples, $layout, $responses ) -> retval
```

### cv::ml::DTrees::calcError

```cpp
float cv::ml::DTrees::calcError( const cv::Ptr<cv::ml::TrainData>& data,
                                 bool                              test,
                                 _OutputArray                      resp )

AutoIt:
    $oDTrees.calcError( $data, $test[, $resp] ) -> retval, $resp
```

### cv::ml::DTrees::predict

```cpp
float cv::ml::DTrees::predict( _InputArray  samples,
                               _OutputArray results = noArray(),
                               int          flags = 0 )

AutoIt:
    $oDTrees.predict( $samples[, $results[, $flags]] ) -> retval, $results
```

### cv::ml::DTrees::clear

```cpp
void cv::ml::DTrees::clear()

AutoIt:
    $oDTrees.clear() -> None
```

### cv::ml::DTrees::write

```cpp
void cv::ml::DTrees::write( const cv::Ptr<cv::FileStorage>& fs,
                            const std::string&              name = String() )

AutoIt:
    $oDTrees.write( $fs[, $name] ) -> None
```

### cv::ml::DTrees::read

```cpp
void cv::ml::DTrees::read( const cv::FileNode& fn )

AutoIt:
    $oDTrees.read( $fn ) -> None
```

### cv::ml::DTrees::save

```cpp
void cv::ml::DTrees::save( const std::string& filename )

AutoIt:
    $oDTrees.save( $filename ) -> None
```

### cv::ml::DTrees::getDefaultName

```cpp
std::string cv::ml::DTrees::getDefaultName()

AutoIt:
    $oDTrees.getDefaultName() -> retval
```

## cv::ml::RTrees

### cv::ml::RTrees::getCalculateVarImportance

```cpp
bool cv::ml::RTrees::getCalculateVarImportance()

AutoIt:
    $oRTrees.getCalculateVarImportance() -> retval
```

### cv::ml::RTrees::setCalculateVarImportance

```cpp
void cv::ml::RTrees::setCalculateVarImportance( bool val )

AutoIt:
    $oRTrees.setCalculateVarImportance( $val ) -> None
```

### cv::ml::RTrees::getActiveVarCount

```cpp
int cv::ml::RTrees::getActiveVarCount()

AutoIt:
    $oRTrees.getActiveVarCount() -> retval
```

### cv::ml::RTrees::setActiveVarCount

```cpp
void cv::ml::RTrees::setActiveVarCount( int val )

AutoIt:
    $oRTrees.setActiveVarCount( $val ) -> None
```

### cv::ml::RTrees::getTermCriteria

```cpp
cv::TermCriteria cv::ml::RTrees::getTermCriteria()

AutoIt:
    $oRTrees.getTermCriteria() -> retval
```

### cv::ml::RTrees::setTermCriteria

```cpp
void cv::ml::RTrees::setTermCriteria( const cv::TermCriteria& val )

AutoIt:
    $oRTrees.setTermCriteria( $val ) -> None
```

### cv::ml::RTrees::getVarImportance

```cpp
cv::Mat cv::ml::RTrees::getVarImportance()

AutoIt:
    $oRTrees.getVarImportance() -> retval
```

### cv::ml::RTrees::getVotes

```cpp
void cv::ml::RTrees::getVotes( _InputArray  samples,
                               _OutputArray results,
                               int          flags )

AutoIt:
    $oRTrees.getVotes( $samples, $flags[, $results] ) -> $results
```

### cv::ml::RTrees::getOOBError

```cpp
double cv::ml::RTrees::getOOBError()

AutoIt:
    $oRTrees.getOOBError() -> retval
```

### cv::ml::RTrees::create

```cpp
static cv::Ptr<cv::ml::RTrees> cv::ml::RTrees::create()

AutoIt:
    _OpenCV_ObjCreate("cv.ml.RTrees").create() -> retval
```

### cv::ml::RTrees::load

```cpp
static cv::Ptr<cv::ml::RTrees> cv::ml::RTrees::load( const std::string& filepath,
                                                     const std::string& nodeName = String() )

AutoIt:
    _OpenCV_ObjCreate("cv.ml.RTrees").load( $filepath[, $nodeName] ) -> retval
```

### cv::ml::RTrees::getMaxCategories

```cpp
int cv::ml::RTrees::getMaxCategories()

AutoIt:
    $oRTrees.getMaxCategories() -> retval
```

### cv::ml::RTrees::setMaxCategories

```cpp
void cv::ml::RTrees::setMaxCategories( int val )

AutoIt:
    $oRTrees.setMaxCategories( $val ) -> None
```

### cv::ml::RTrees::getMaxDepth

```cpp
int cv::ml::RTrees::getMaxDepth()

AutoIt:
    $oRTrees.getMaxDepth() -> retval
```

### cv::ml::RTrees::setMaxDepth

```cpp
void cv::ml::RTrees::setMaxDepth( int val )

AutoIt:
    $oRTrees.setMaxDepth( $val ) -> None
```

### cv::ml::RTrees::getMinSampleCount

```cpp
int cv::ml::RTrees::getMinSampleCount()

AutoIt:
    $oRTrees.getMinSampleCount() -> retval
```

### cv::ml::RTrees::setMinSampleCount

```cpp
void cv::ml::RTrees::setMinSampleCount( int val )

AutoIt:
    $oRTrees.setMinSampleCount( $val ) -> None
```

### cv::ml::RTrees::getCVFolds

```cpp
int cv::ml::RTrees::getCVFolds()

AutoIt:
    $oRTrees.getCVFolds() -> retval
```

### cv::ml::RTrees::setCVFolds

```cpp
void cv::ml::RTrees::setCVFolds( int val )

AutoIt:
    $oRTrees.setCVFolds( $val ) -> None
```

### cv::ml::RTrees::getUseSurrogates

```cpp
bool cv::ml::RTrees::getUseSurrogates()

AutoIt:
    $oRTrees.getUseSurrogates() -> retval
```

### cv::ml::RTrees::setUseSurrogates

```cpp
void cv::ml::RTrees::setUseSurrogates( bool val )

AutoIt:
    $oRTrees.setUseSurrogates( $val ) -> None
```

### cv::ml::RTrees::getUse1SERule

```cpp
bool cv::ml::RTrees::getUse1SERule()

AutoIt:
    $oRTrees.getUse1SERule() -> retval
```

### cv::ml::RTrees::setUse1SERule

```cpp
void cv::ml::RTrees::setUse1SERule( bool val )

AutoIt:
    $oRTrees.setUse1SERule( $val ) -> None
```

### cv::ml::RTrees::getTruncatePrunedTree

```cpp
bool cv::ml::RTrees::getTruncatePrunedTree()

AutoIt:
    $oRTrees.getTruncatePrunedTree() -> retval
```

### cv::ml::RTrees::setTruncatePrunedTree

```cpp
void cv::ml::RTrees::setTruncatePrunedTree( bool val )

AutoIt:
    $oRTrees.setTruncatePrunedTree( $val ) -> None
```

### cv::ml::RTrees::getRegressionAccuracy

```cpp
float cv::ml::RTrees::getRegressionAccuracy()

AutoIt:
    $oRTrees.getRegressionAccuracy() -> retval
```

### cv::ml::RTrees::setRegressionAccuracy

```cpp
void cv::ml::RTrees::setRegressionAccuracy( float val )

AutoIt:
    $oRTrees.setRegressionAccuracy( $val ) -> None
```

### cv::ml::RTrees::getPriors

```cpp
cv::Mat cv::ml::RTrees::getPriors()

AutoIt:
    $oRTrees.getPriors() -> retval
```

### cv::ml::RTrees::setPriors

```cpp
void cv::ml::RTrees::setPriors( const cv::Mat& val )

AutoIt:
    $oRTrees.setPriors( $val ) -> None
```

### cv::ml::RTrees::getVarCount

```cpp
int cv::ml::RTrees::getVarCount()

AutoIt:
    $oRTrees.getVarCount() -> retval
```

### cv::ml::RTrees::empty

```cpp
bool cv::ml::RTrees::empty()

AutoIt:
    $oRTrees.empty() -> retval
```

### cv::ml::RTrees::isTrained

```cpp
bool cv::ml::RTrees::isTrained()

AutoIt:
    $oRTrees.isTrained() -> retval
```

### cv::ml::RTrees::isClassifier

```cpp
bool cv::ml::RTrees::isClassifier()

AutoIt:
    $oRTrees.isClassifier() -> retval
```

### cv::ml::RTrees::train

```cpp
bool cv::ml::RTrees::train( const cv::Ptr<cv::ml::TrainData>& trainData,
                            int                               flags = 0 )

AutoIt:
    $oRTrees.train( $trainData[, $flags] ) -> retval
```

```cpp
bool cv::ml::RTrees::train( _InputArray samples,
                            int         layout,
                            _InputArray responses )

AutoIt:
    $oRTrees.train( $samples, $layout, $responses ) -> retval
```

### cv::ml::RTrees::calcError

```cpp
float cv::ml::RTrees::calcError( const cv::Ptr<cv::ml::TrainData>& data,
                                 bool                              test,
                                 _OutputArray                      resp )

AutoIt:
    $oRTrees.calcError( $data, $test[, $resp] ) -> retval, $resp
```

### cv::ml::RTrees::predict

```cpp
float cv::ml::RTrees::predict( _InputArray  samples,
                               _OutputArray results = noArray(),
                               int          flags = 0 )

AutoIt:
    $oRTrees.predict( $samples[, $results[, $flags]] ) -> retval, $results
```

### cv::ml::RTrees::clear

```cpp
void cv::ml::RTrees::clear()

AutoIt:
    $oRTrees.clear() -> None
```

### cv::ml::RTrees::write

```cpp
void cv::ml::RTrees::write( const cv::Ptr<cv::FileStorage>& fs,
                            const std::string&              name = String() )

AutoIt:
    $oRTrees.write( $fs[, $name] ) -> None
```

### cv::ml::RTrees::read

```cpp
void cv::ml::RTrees::read( const cv::FileNode& fn )

AutoIt:
    $oRTrees.read( $fn ) -> None
```

### cv::ml::RTrees::save

```cpp
void cv::ml::RTrees::save( const std::string& filename )

AutoIt:
    $oRTrees.save( $filename ) -> None
```

### cv::ml::RTrees::getDefaultName

```cpp
std::string cv::ml::RTrees::getDefaultName()

AutoIt:
    $oRTrees.getDefaultName() -> retval
```

## cv::ml::Boost

### cv::ml::Boost::getBoostType

```cpp
int cv::ml::Boost::getBoostType()

AutoIt:
    $oBoost.getBoostType() -> retval
```

### cv::ml::Boost::setBoostType

```cpp
void cv::ml::Boost::setBoostType( int val )

AutoIt:
    $oBoost.setBoostType( $val ) -> None
```

### cv::ml::Boost::getWeakCount

```cpp
int cv::ml::Boost::getWeakCount()

AutoIt:
    $oBoost.getWeakCount() -> retval
```

### cv::ml::Boost::setWeakCount

```cpp
void cv::ml::Boost::setWeakCount( int val )

AutoIt:
    $oBoost.setWeakCount( $val ) -> None
```

### cv::ml::Boost::getWeightTrimRate

```cpp
double cv::ml::Boost::getWeightTrimRate()

AutoIt:
    $oBoost.getWeightTrimRate() -> retval
```

### cv::ml::Boost::setWeightTrimRate

```cpp
void cv::ml::Boost::setWeightTrimRate( double val )

AutoIt:
    $oBoost.setWeightTrimRate( $val ) -> None
```

### cv::ml::Boost::create

```cpp
static cv::Ptr<cv::ml::Boost> cv::ml::Boost::create()

AutoIt:
    _OpenCV_ObjCreate("cv.ml.Boost").create() -> retval
```

### cv::ml::Boost::load

```cpp
static cv::Ptr<cv::ml::Boost> cv::ml::Boost::load( const std::string& filepath,
                                                   const std::string& nodeName = String() )

AutoIt:
    _OpenCV_ObjCreate("cv.ml.Boost").load( $filepath[, $nodeName] ) -> retval
```

### cv::ml::Boost::getMaxCategories

```cpp
int cv::ml::Boost::getMaxCategories()

AutoIt:
    $oBoost.getMaxCategories() -> retval
```

### cv::ml::Boost::setMaxCategories

```cpp
void cv::ml::Boost::setMaxCategories( int val )

AutoIt:
    $oBoost.setMaxCategories( $val ) -> None
```

### cv::ml::Boost::getMaxDepth

```cpp
int cv::ml::Boost::getMaxDepth()

AutoIt:
    $oBoost.getMaxDepth() -> retval
```

### cv::ml::Boost::setMaxDepth

```cpp
void cv::ml::Boost::setMaxDepth( int val )

AutoIt:
    $oBoost.setMaxDepth( $val ) -> None
```

### cv::ml::Boost::getMinSampleCount

```cpp
int cv::ml::Boost::getMinSampleCount()

AutoIt:
    $oBoost.getMinSampleCount() -> retval
```

### cv::ml::Boost::setMinSampleCount

```cpp
void cv::ml::Boost::setMinSampleCount( int val )

AutoIt:
    $oBoost.setMinSampleCount( $val ) -> None
```

### cv::ml::Boost::getCVFolds

```cpp
int cv::ml::Boost::getCVFolds()

AutoIt:
    $oBoost.getCVFolds() -> retval
```

### cv::ml::Boost::setCVFolds

```cpp
void cv::ml::Boost::setCVFolds( int val )

AutoIt:
    $oBoost.setCVFolds( $val ) -> None
```

### cv::ml::Boost::getUseSurrogates

```cpp
bool cv::ml::Boost::getUseSurrogates()

AutoIt:
    $oBoost.getUseSurrogates() -> retval
```

### cv::ml::Boost::setUseSurrogates

```cpp
void cv::ml::Boost::setUseSurrogates( bool val )

AutoIt:
    $oBoost.setUseSurrogates( $val ) -> None
```

### cv::ml::Boost::getUse1SERule

```cpp
bool cv::ml::Boost::getUse1SERule()

AutoIt:
    $oBoost.getUse1SERule() -> retval
```

### cv::ml::Boost::setUse1SERule

```cpp
void cv::ml::Boost::setUse1SERule( bool val )

AutoIt:
    $oBoost.setUse1SERule( $val ) -> None
```

### cv::ml::Boost::getTruncatePrunedTree

```cpp
bool cv::ml::Boost::getTruncatePrunedTree()

AutoIt:
    $oBoost.getTruncatePrunedTree() -> retval
```

### cv::ml::Boost::setTruncatePrunedTree

```cpp
void cv::ml::Boost::setTruncatePrunedTree( bool val )

AutoIt:
    $oBoost.setTruncatePrunedTree( $val ) -> None
```

### cv::ml::Boost::getRegressionAccuracy

```cpp
float cv::ml::Boost::getRegressionAccuracy()

AutoIt:
    $oBoost.getRegressionAccuracy() -> retval
```

### cv::ml::Boost::setRegressionAccuracy

```cpp
void cv::ml::Boost::setRegressionAccuracy( float val )

AutoIt:
    $oBoost.setRegressionAccuracy( $val ) -> None
```

### cv::ml::Boost::getPriors

```cpp
cv::Mat cv::ml::Boost::getPriors()

AutoIt:
    $oBoost.getPriors() -> retval
```

### cv::ml::Boost::setPriors

```cpp
void cv::ml::Boost::setPriors( const cv::Mat& val )

AutoIt:
    $oBoost.setPriors( $val ) -> None
```

### cv::ml::Boost::getVarCount

```cpp
int cv::ml::Boost::getVarCount()

AutoIt:
    $oBoost.getVarCount() -> retval
```

### cv::ml::Boost::empty

```cpp
bool cv::ml::Boost::empty()

AutoIt:
    $oBoost.empty() -> retval
```

### cv::ml::Boost::isTrained

```cpp
bool cv::ml::Boost::isTrained()

AutoIt:
    $oBoost.isTrained() -> retval
```

### cv::ml::Boost::isClassifier

```cpp
bool cv::ml::Boost::isClassifier()

AutoIt:
    $oBoost.isClassifier() -> retval
```

### cv::ml::Boost::train

```cpp
bool cv::ml::Boost::train( const cv::Ptr<cv::ml::TrainData>& trainData,
                           int                               flags = 0 )

AutoIt:
    $oBoost.train( $trainData[, $flags] ) -> retval
```

```cpp
bool cv::ml::Boost::train( _InputArray samples,
                           int         layout,
                           _InputArray responses )

AutoIt:
    $oBoost.train( $samples, $layout, $responses ) -> retval
```

### cv::ml::Boost::calcError

```cpp
float cv::ml::Boost::calcError( const cv::Ptr<cv::ml::TrainData>& data,
                                bool                              test,
                                _OutputArray                      resp )

AutoIt:
    $oBoost.calcError( $data, $test[, $resp] ) -> retval, $resp
```

### cv::ml::Boost::predict

```cpp
float cv::ml::Boost::predict( _InputArray  samples,
                              _OutputArray results = noArray(),
                              int          flags = 0 )

AutoIt:
    $oBoost.predict( $samples[, $results[, $flags]] ) -> retval, $results
```

### cv::ml::Boost::clear

```cpp
void cv::ml::Boost::clear()

AutoIt:
    $oBoost.clear() -> None
```

### cv::ml::Boost::write

```cpp
void cv::ml::Boost::write( const cv::Ptr<cv::FileStorage>& fs,
                           const std::string&              name = String() )

AutoIt:
    $oBoost.write( $fs[, $name] ) -> None
```

### cv::ml::Boost::read

```cpp
void cv::ml::Boost::read( const cv::FileNode& fn )

AutoIt:
    $oBoost.read( $fn ) -> None
```

### cv::ml::Boost::save

```cpp
void cv::ml::Boost::save( const std::string& filename )

AutoIt:
    $oBoost.save( $filename ) -> None
```

### cv::ml::Boost::getDefaultName

```cpp
std::string cv::ml::Boost::getDefaultName()

AutoIt:
    $oBoost.getDefaultName() -> retval
```

## cv::ml::ANN_MLP

### cv::ml::ANN_MLP::setTrainMethod

```cpp
void cv::ml::ANN_MLP::setTrainMethod( int    method,
                                      double param1 = 0,
                                      double param2 = 0 )

AutoIt:
    $oANN_MLP.setTrainMethod( $method[, $param1[, $param2]] ) -> None
```

### cv::ml::ANN_MLP::getTrainMethod

```cpp
int cv::ml::ANN_MLP::getTrainMethod()

AutoIt:
    $oANN_MLP.getTrainMethod() -> retval
```

### cv::ml::ANN_MLP::setActivationFunction

```cpp
void cv::ml::ANN_MLP::setActivationFunction( int    type,
                                             double param1 = 0,
                                             double param2 = 0 )

AutoIt:
    $oANN_MLP.setActivationFunction( $type[, $param1[, $param2]] ) -> None
```

### cv::ml::ANN_MLP::setLayerSizes

```cpp
void cv::ml::ANN_MLP::setLayerSizes( _InputArray _layer_sizes )

AutoIt:
    $oANN_MLP.setLayerSizes( $_layer_sizes ) -> None
```

### cv::ml::ANN_MLP::getLayerSizes

```cpp
cv::Mat cv::ml::ANN_MLP::getLayerSizes()

AutoIt:
    $oANN_MLP.getLayerSizes() -> retval
```

### cv::ml::ANN_MLP::getTermCriteria

```cpp
cv::TermCriteria cv::ml::ANN_MLP::getTermCriteria()

AutoIt:
    $oANN_MLP.getTermCriteria() -> retval
```

### cv::ml::ANN_MLP::setTermCriteria

```cpp
void cv::ml::ANN_MLP::setTermCriteria( cv::TermCriteria val )

AutoIt:
    $oANN_MLP.setTermCriteria( $val ) -> None
```

### cv::ml::ANN_MLP::getBackpropWeightScale

```cpp
double cv::ml::ANN_MLP::getBackpropWeightScale()

AutoIt:
    $oANN_MLP.getBackpropWeightScale() -> retval
```

### cv::ml::ANN_MLP::setBackpropWeightScale

```cpp
void cv::ml::ANN_MLP::setBackpropWeightScale( double val )

AutoIt:
    $oANN_MLP.setBackpropWeightScale( $val ) -> None
```

### cv::ml::ANN_MLP::getBackpropMomentumScale

```cpp
double cv::ml::ANN_MLP::getBackpropMomentumScale()

AutoIt:
    $oANN_MLP.getBackpropMomentumScale() -> retval
```

### cv::ml::ANN_MLP::setBackpropMomentumScale

```cpp
void cv::ml::ANN_MLP::setBackpropMomentumScale( double val )

AutoIt:
    $oANN_MLP.setBackpropMomentumScale( $val ) -> None
```

### cv::ml::ANN_MLP::getRpropDW0

```cpp
double cv::ml::ANN_MLP::getRpropDW0()

AutoIt:
    $oANN_MLP.getRpropDW0() -> retval
```

### cv::ml::ANN_MLP::setRpropDW0

```cpp
void cv::ml::ANN_MLP::setRpropDW0( double val )

AutoIt:
    $oANN_MLP.setRpropDW0( $val ) -> None
```

### cv::ml::ANN_MLP::getRpropDWPlus

```cpp
double cv::ml::ANN_MLP::getRpropDWPlus()

AutoIt:
    $oANN_MLP.getRpropDWPlus() -> retval
```

### cv::ml::ANN_MLP::setRpropDWPlus

```cpp
void cv::ml::ANN_MLP::setRpropDWPlus( double val )

AutoIt:
    $oANN_MLP.setRpropDWPlus( $val ) -> None
```

### cv::ml::ANN_MLP::getRpropDWMinus

```cpp
double cv::ml::ANN_MLP::getRpropDWMinus()

AutoIt:
    $oANN_MLP.getRpropDWMinus() -> retval
```

### cv::ml::ANN_MLP::setRpropDWMinus

```cpp
void cv::ml::ANN_MLP::setRpropDWMinus( double val )

AutoIt:
    $oANN_MLP.setRpropDWMinus( $val ) -> None
```

### cv::ml::ANN_MLP::getRpropDWMin

```cpp
double cv::ml::ANN_MLP::getRpropDWMin()

AutoIt:
    $oANN_MLP.getRpropDWMin() -> retval
```

### cv::ml::ANN_MLP::setRpropDWMin

```cpp
void cv::ml::ANN_MLP::setRpropDWMin( double val )

AutoIt:
    $oANN_MLP.setRpropDWMin( $val ) -> None
```

### cv::ml::ANN_MLP::getRpropDWMax

```cpp
double cv::ml::ANN_MLP::getRpropDWMax()

AutoIt:
    $oANN_MLP.getRpropDWMax() -> retval
```

### cv::ml::ANN_MLP::setRpropDWMax

```cpp
void cv::ml::ANN_MLP::setRpropDWMax( double val )

AutoIt:
    $oANN_MLP.setRpropDWMax( $val ) -> None
```

### cv::ml::ANN_MLP::getAnnealInitialT

```cpp
double cv::ml::ANN_MLP::getAnnealInitialT()

AutoIt:
    $oANN_MLP.getAnnealInitialT() -> retval
```

### cv::ml::ANN_MLP::setAnnealInitialT

```cpp
void cv::ml::ANN_MLP::setAnnealInitialT( double val )

AutoIt:
    $oANN_MLP.setAnnealInitialT( $val ) -> None
```

### cv::ml::ANN_MLP::getAnnealFinalT

```cpp
double cv::ml::ANN_MLP::getAnnealFinalT()

AutoIt:
    $oANN_MLP.getAnnealFinalT() -> retval
```

### cv::ml::ANN_MLP::setAnnealFinalT

```cpp
void cv::ml::ANN_MLP::setAnnealFinalT( double val )

AutoIt:
    $oANN_MLP.setAnnealFinalT( $val ) -> None
```

### cv::ml::ANN_MLP::getAnnealCoolingRatio

```cpp
double cv::ml::ANN_MLP::getAnnealCoolingRatio()

AutoIt:
    $oANN_MLP.getAnnealCoolingRatio() -> retval
```

### cv::ml::ANN_MLP::setAnnealCoolingRatio

```cpp
void cv::ml::ANN_MLP::setAnnealCoolingRatio( double val )

AutoIt:
    $oANN_MLP.setAnnealCoolingRatio( $val ) -> None
```

### cv::ml::ANN_MLP::getAnnealItePerStep

```cpp
int cv::ml::ANN_MLP::getAnnealItePerStep()

AutoIt:
    $oANN_MLP.getAnnealItePerStep() -> retval
```

### cv::ml::ANN_MLP::setAnnealItePerStep

```cpp
void cv::ml::ANN_MLP::setAnnealItePerStep( int val )

AutoIt:
    $oANN_MLP.setAnnealItePerStep( $val ) -> None
```

### cv::ml::ANN_MLP::getWeights

```cpp
cv::Mat cv::ml::ANN_MLP::getWeights( int layerIdx )

AutoIt:
    $oANN_MLP.getWeights( $layerIdx ) -> retval
```

### cv::ml::ANN_MLP::create

```cpp
static cv::Ptr<cv::ml::ANN_MLP> cv::ml::ANN_MLP::create()

AutoIt:
    _OpenCV_ObjCreate("cv.ml.ANN_MLP").create() -> retval
```

### cv::ml::ANN_MLP::load

```cpp
static cv::Ptr<cv::ml::ANN_MLP> cv::ml::ANN_MLP::load( const std::string& filepath )

AutoIt:
    _OpenCV_ObjCreate("cv.ml.ANN_MLP").load( $filepath ) -> retval
```

### cv::ml::ANN_MLP::getVarCount

```cpp
int cv::ml::ANN_MLP::getVarCount()

AutoIt:
    $oANN_MLP.getVarCount() -> retval
```

### cv::ml::ANN_MLP::empty

```cpp
bool cv::ml::ANN_MLP::empty()

AutoIt:
    $oANN_MLP.empty() -> retval
```

### cv::ml::ANN_MLP::isTrained

```cpp
bool cv::ml::ANN_MLP::isTrained()

AutoIt:
    $oANN_MLP.isTrained() -> retval
```

### cv::ml::ANN_MLP::isClassifier

```cpp
bool cv::ml::ANN_MLP::isClassifier()

AutoIt:
    $oANN_MLP.isClassifier() -> retval
```

### cv::ml::ANN_MLP::train

```cpp
bool cv::ml::ANN_MLP::train( const cv::Ptr<cv::ml::TrainData>& trainData,
                             int                               flags = 0 )

AutoIt:
    $oANN_MLP.train( $trainData[, $flags] ) -> retval
```

```cpp
bool cv::ml::ANN_MLP::train( _InputArray samples,
                             int         layout,
                             _InputArray responses )

AutoIt:
    $oANN_MLP.train( $samples, $layout, $responses ) -> retval
```

### cv::ml::ANN_MLP::calcError

```cpp
float cv::ml::ANN_MLP::calcError( const cv::Ptr<cv::ml::TrainData>& data,
                                  bool                              test,
                                  _OutputArray                      resp )

AutoIt:
    $oANN_MLP.calcError( $data, $test[, $resp] ) -> retval, $resp
```

### cv::ml::ANN_MLP::predict

```cpp
float cv::ml::ANN_MLP::predict( _InputArray  samples,
                                _OutputArray results = noArray(),
                                int          flags = 0 )

AutoIt:
    $oANN_MLP.predict( $samples[, $results[, $flags]] ) -> retval, $results
```

### cv::ml::ANN_MLP::clear

```cpp
void cv::ml::ANN_MLP::clear()

AutoIt:
    $oANN_MLP.clear() -> None
```

### cv::ml::ANN_MLP::write

```cpp
void cv::ml::ANN_MLP::write( const cv::Ptr<cv::FileStorage>& fs,
                             const std::string&              name = String() )

AutoIt:
    $oANN_MLP.write( $fs[, $name] ) -> None
```

### cv::ml::ANN_MLP::read

```cpp
void cv::ml::ANN_MLP::read( const cv::FileNode& fn )

AutoIt:
    $oANN_MLP.read( $fn ) -> None
```

### cv::ml::ANN_MLP::save

```cpp
void cv::ml::ANN_MLP::save( const std::string& filename )

AutoIt:
    $oANN_MLP.save( $filename ) -> None
```

### cv::ml::ANN_MLP::getDefaultName

```cpp
std::string cv::ml::ANN_MLP::getDefaultName()

AutoIt:
    $oANN_MLP.getDefaultName() -> retval
```

## cv::ml::LogisticRegression

### cv::ml::LogisticRegression::getLearningRate

```cpp
double cv::ml::LogisticRegression::getLearningRate()

AutoIt:
    $oLogisticRegression.getLearningRate() -> retval
```

### cv::ml::LogisticRegression::setLearningRate

```cpp
void cv::ml::LogisticRegression::setLearningRate( double val )

AutoIt:
    $oLogisticRegression.setLearningRate( $val ) -> None
```

### cv::ml::LogisticRegression::getIterations

```cpp
int cv::ml::LogisticRegression::getIterations()

AutoIt:
    $oLogisticRegression.getIterations() -> retval
```

### cv::ml::LogisticRegression::setIterations

```cpp
void cv::ml::LogisticRegression::setIterations( int val )

AutoIt:
    $oLogisticRegression.setIterations( $val ) -> None
```

### cv::ml::LogisticRegression::getRegularization

```cpp
int cv::ml::LogisticRegression::getRegularization()

AutoIt:
    $oLogisticRegression.getRegularization() -> retval
```

### cv::ml::LogisticRegression::setRegularization

```cpp
void cv::ml::LogisticRegression::setRegularization( int val )

AutoIt:
    $oLogisticRegression.setRegularization( $val ) -> None
```

### cv::ml::LogisticRegression::getTrainMethod

```cpp
int cv::ml::LogisticRegression::getTrainMethod()

AutoIt:
    $oLogisticRegression.getTrainMethod() -> retval
```

### cv::ml::LogisticRegression::setTrainMethod

```cpp
void cv::ml::LogisticRegression::setTrainMethod( int val )

AutoIt:
    $oLogisticRegression.setTrainMethod( $val ) -> None
```

### cv::ml::LogisticRegression::getMiniBatchSize

```cpp
int cv::ml::LogisticRegression::getMiniBatchSize()

AutoIt:
    $oLogisticRegression.getMiniBatchSize() -> retval
```

### cv::ml::LogisticRegression::setMiniBatchSize

```cpp
void cv::ml::LogisticRegression::setMiniBatchSize( int val )

AutoIt:
    $oLogisticRegression.setMiniBatchSize( $val ) -> None
```

### cv::ml::LogisticRegression::getTermCriteria

```cpp
cv::TermCriteria cv::ml::LogisticRegression::getTermCriteria()

AutoIt:
    $oLogisticRegression.getTermCriteria() -> retval
```

### cv::ml::LogisticRegression::setTermCriteria

```cpp
void cv::ml::LogisticRegression::setTermCriteria( cv::TermCriteria val )

AutoIt:
    $oLogisticRegression.setTermCriteria( $val ) -> None
```

### cv::ml::LogisticRegression::predict

```cpp
float cv::ml::LogisticRegression::predict( _InputArray  samples,
                                           _OutputArray results = noArray(),
                                           int          flags = 0 )

AutoIt:
    $oLogisticRegression.predict( $samples[, $results[, $flags]] ) -> retval, $results
```

### cv::ml::LogisticRegression::get_learnt_thetas

```cpp
cv::Mat cv::ml::LogisticRegression::get_learnt_thetas()

AutoIt:
    $oLogisticRegression.get_learnt_thetas() -> retval
```

### cv::ml::LogisticRegression::create

```cpp
static cv::Ptr<cv::ml::LogisticRegression> cv::ml::LogisticRegression::create()

AutoIt:
    _OpenCV_ObjCreate("cv.ml.LogisticRegression").create() -> retval
```

### cv::ml::LogisticRegression::load

```cpp
static cv::Ptr<cv::ml::LogisticRegression> cv::ml::LogisticRegression::load( const std::string& filepath,
                                                                             const std::string& nodeName = String() )

AutoIt:
    _OpenCV_ObjCreate("cv.ml.LogisticRegression").load( $filepath[, $nodeName] ) -> retval
```

### cv::ml::LogisticRegression::getVarCount

```cpp
int cv::ml::LogisticRegression::getVarCount()

AutoIt:
    $oLogisticRegression.getVarCount() -> retval
```

### cv::ml::LogisticRegression::empty

```cpp
bool cv::ml::LogisticRegression::empty()

AutoIt:
    $oLogisticRegression.empty() -> retval
```

### cv::ml::LogisticRegression::isTrained

```cpp
bool cv::ml::LogisticRegression::isTrained()

AutoIt:
    $oLogisticRegression.isTrained() -> retval
```

### cv::ml::LogisticRegression::isClassifier

```cpp
bool cv::ml::LogisticRegression::isClassifier()

AutoIt:
    $oLogisticRegression.isClassifier() -> retval
```

### cv::ml::LogisticRegression::train

```cpp
bool cv::ml::LogisticRegression::train( const cv::Ptr<cv::ml::TrainData>& trainData,
                                        int                               flags = 0 )

AutoIt:
    $oLogisticRegression.train( $trainData[, $flags] ) -> retval
```

```cpp
bool cv::ml::LogisticRegression::train( _InputArray samples,
                                        int         layout,
                                        _InputArray responses )

AutoIt:
    $oLogisticRegression.train( $samples, $layout, $responses ) -> retval
```

### cv::ml::LogisticRegression::calcError

```cpp
float cv::ml::LogisticRegression::calcError( const cv::Ptr<cv::ml::TrainData>& data,
                                             bool                              test,
                                             _OutputArray                      resp )

AutoIt:
    $oLogisticRegression.calcError( $data, $test[, $resp] ) -> retval, $resp
```

### cv::ml::LogisticRegression::clear

```cpp
void cv::ml::LogisticRegression::clear()

AutoIt:
    $oLogisticRegression.clear() -> None
```

### cv::ml::LogisticRegression::write

```cpp
void cv::ml::LogisticRegression::write( const cv::Ptr<cv::FileStorage>& fs,
                                        const std::string&              name = String() )

AutoIt:
    $oLogisticRegression.write( $fs[, $name] ) -> None
```

### cv::ml::LogisticRegression::read

```cpp
void cv::ml::LogisticRegression::read( const cv::FileNode& fn )

AutoIt:
    $oLogisticRegression.read( $fn ) -> None
```

### cv::ml::LogisticRegression::save

```cpp
void cv::ml::LogisticRegression::save( const std::string& filename )

AutoIt:
    $oLogisticRegression.save( $filename ) -> None
```

### cv::ml::LogisticRegression::getDefaultName

```cpp
std::string cv::ml::LogisticRegression::getDefaultName()

AutoIt:
    $oLogisticRegression.getDefaultName() -> retval
```

## cv::ml::SVMSGD

### cv::ml::SVMSGD::getWeights

```cpp
cv::Mat cv::ml::SVMSGD::getWeights()

AutoIt:
    $oSVMSGD.getWeights() -> retval
```

### cv::ml::SVMSGD::getShift

```cpp
float cv::ml::SVMSGD::getShift()

AutoIt:
    $oSVMSGD.getShift() -> retval
```

### cv::ml::SVMSGD::create

```cpp
static cv::Ptr<cv::ml::SVMSGD> cv::ml::SVMSGD::create()

AutoIt:
    _OpenCV_ObjCreate("cv.ml.SVMSGD").create() -> retval
```

### cv::ml::SVMSGD::load

```cpp
static cv::Ptr<cv::ml::SVMSGD> cv::ml::SVMSGD::load( const std::string& filepath,
                                                     const std::string& nodeName = String() )

AutoIt:
    _OpenCV_ObjCreate("cv.ml.SVMSGD").load( $filepath[, $nodeName] ) -> retval
```

### cv::ml::SVMSGD::setOptimalParameters

```cpp
void cv::ml::SVMSGD::setOptimalParameters( int svmsgdType = SVMSGD::ASGD,
                                           int marginType = SVMSGD::SOFT_MARGIN )

AutoIt:
    $oSVMSGD.setOptimalParameters( [$svmsgdType[, $marginType]] ) -> None
```

### cv::ml::SVMSGD::getSvmsgdType

```cpp
int cv::ml::SVMSGD::getSvmsgdType()

AutoIt:
    $oSVMSGD.getSvmsgdType() -> retval
```

### cv::ml::SVMSGD::setSvmsgdType

```cpp
void cv::ml::SVMSGD::setSvmsgdType( int svmsgdType )

AutoIt:
    $oSVMSGD.setSvmsgdType( $svmsgdType ) -> None
```

### cv::ml::SVMSGD::getMarginType

```cpp
int cv::ml::SVMSGD::getMarginType()

AutoIt:
    $oSVMSGD.getMarginType() -> retval
```

### cv::ml::SVMSGD::setMarginType

```cpp
void cv::ml::SVMSGD::setMarginType( int marginType )

AutoIt:
    $oSVMSGD.setMarginType( $marginType ) -> None
```

### cv::ml::SVMSGD::getMarginRegularization

```cpp
float cv::ml::SVMSGD::getMarginRegularization()

AutoIt:
    $oSVMSGD.getMarginRegularization() -> retval
```

### cv::ml::SVMSGD::setMarginRegularization

```cpp
void cv::ml::SVMSGD::setMarginRegularization( float marginRegularization )

AutoIt:
    $oSVMSGD.setMarginRegularization( $marginRegularization ) -> None
```

### cv::ml::SVMSGD::getInitialStepSize

```cpp
float cv::ml::SVMSGD::getInitialStepSize()

AutoIt:
    $oSVMSGD.getInitialStepSize() -> retval
```

### cv::ml::SVMSGD::setInitialStepSize

```cpp
void cv::ml::SVMSGD::setInitialStepSize( float InitialStepSize )

AutoIt:
    $oSVMSGD.setInitialStepSize( $InitialStepSize ) -> None
```

### cv::ml::SVMSGD::getStepDecreasingPower

```cpp
float cv::ml::SVMSGD::getStepDecreasingPower()

AutoIt:
    $oSVMSGD.getStepDecreasingPower() -> retval
```

### cv::ml::SVMSGD::setStepDecreasingPower

```cpp
void cv::ml::SVMSGD::setStepDecreasingPower( float stepDecreasingPower )

AutoIt:
    $oSVMSGD.setStepDecreasingPower( $stepDecreasingPower ) -> None
```

### cv::ml::SVMSGD::getTermCriteria

```cpp
cv::TermCriteria cv::ml::SVMSGD::getTermCriteria()

AutoIt:
    $oSVMSGD.getTermCriteria() -> retval
```

### cv::ml::SVMSGD::setTermCriteria

```cpp
void cv::ml::SVMSGD::setTermCriteria( const cv::TermCriteria& val )

AutoIt:
    $oSVMSGD.setTermCriteria( $val ) -> None
```

### cv::ml::SVMSGD::getVarCount

```cpp
int cv::ml::SVMSGD::getVarCount()

AutoIt:
    $oSVMSGD.getVarCount() -> retval
```

### cv::ml::SVMSGD::empty

```cpp
bool cv::ml::SVMSGD::empty()

AutoIt:
    $oSVMSGD.empty() -> retval
```

### cv::ml::SVMSGD::isTrained

```cpp
bool cv::ml::SVMSGD::isTrained()

AutoIt:
    $oSVMSGD.isTrained() -> retval
```

### cv::ml::SVMSGD::isClassifier

```cpp
bool cv::ml::SVMSGD::isClassifier()

AutoIt:
    $oSVMSGD.isClassifier() -> retval
```

### cv::ml::SVMSGD::train

```cpp
bool cv::ml::SVMSGD::train( const cv::Ptr<cv::ml::TrainData>& trainData,
                            int                               flags = 0 )

AutoIt:
    $oSVMSGD.train( $trainData[, $flags] ) -> retval
```

```cpp
bool cv::ml::SVMSGD::train( _InputArray samples,
                            int         layout,
                            _InputArray responses )

AutoIt:
    $oSVMSGD.train( $samples, $layout, $responses ) -> retval
```

### cv::ml::SVMSGD::calcError

```cpp
float cv::ml::SVMSGD::calcError( const cv::Ptr<cv::ml::TrainData>& data,
                                 bool                              test,
                                 _OutputArray                      resp )

AutoIt:
    $oSVMSGD.calcError( $data, $test[, $resp] ) -> retval, $resp
```

### cv::ml::SVMSGD::predict

```cpp
float cv::ml::SVMSGD::predict( _InputArray  samples,
                               _OutputArray results = noArray(),
                               int          flags = 0 )

AutoIt:
    $oSVMSGD.predict( $samples[, $results[, $flags]] ) -> retval, $results
```

### cv::ml::SVMSGD::clear

```cpp
void cv::ml::SVMSGD::clear()

AutoIt:
    $oSVMSGD.clear() -> None
```

### cv::ml::SVMSGD::write

```cpp
void cv::ml::SVMSGD::write( const cv::Ptr<cv::FileStorage>& fs,
                            const std::string&              name = String() )

AutoIt:
    $oSVMSGD.write( $fs[, $name] ) -> None
```

### cv::ml::SVMSGD::read

```cpp
void cv::ml::SVMSGD::read( const cv::FileNode& fn )

AutoIt:
    $oSVMSGD.read( $fn ) -> None
```

### cv::ml::SVMSGD::save

```cpp
void cv::ml::SVMSGD::save( const std::string& filename )

AutoIt:
    $oSVMSGD.save( $filename ) -> None
```

### cv::ml::SVMSGD::getDefaultName

```cpp
std::string cv::ml::SVMSGD::getDefaultName()

AutoIt:
    $oSVMSGD.getDefaultName() -> retval
```

## cv::Tonemap

### cv::Tonemap::process

```cpp
void cv::Tonemap::process( _InputArray  src,
                           _OutputArray dst )

AutoIt:
    $oTonemap.process( $src[, $dst] ) -> $dst
```

### cv::Tonemap::getGamma

```cpp
float cv::Tonemap::getGamma()

AutoIt:
    $oTonemap.getGamma() -> retval
```

### cv::Tonemap::setGamma

```cpp
void cv::Tonemap::setGamma( float gamma )

AutoIt:
    $oTonemap.setGamma( $gamma ) -> None
```

### cv::Tonemap::clear

```cpp
void cv::Tonemap::clear()

AutoIt:
    $oTonemap.clear() -> None
```

### cv::Tonemap::write

```cpp
void cv::Tonemap::write( const cv::Ptr<cv::FileStorage>& fs,
                         const std::string&              name = String() )

AutoIt:
    $oTonemap.write( $fs[, $name] ) -> None
```

### cv::Tonemap::read

```cpp
void cv::Tonemap::read( const cv::FileNode& fn )

AutoIt:
    $oTonemap.read( $fn ) -> None
```

### cv::Tonemap::empty

```cpp
bool cv::Tonemap::empty()

AutoIt:
    $oTonemap.empty() -> retval
```

### cv::Tonemap::save

```cpp
void cv::Tonemap::save( const std::string& filename )

AutoIt:
    $oTonemap.save( $filename ) -> None
```

### cv::Tonemap::getDefaultName

```cpp
std::string cv::Tonemap::getDefaultName()

AutoIt:
    $oTonemap.getDefaultName() -> retval
```

## cv::TonemapDrago

### cv::TonemapDrago::getSaturation

```cpp
float cv::TonemapDrago::getSaturation()

AutoIt:
    $oTonemapDrago.getSaturation() -> retval
```

### cv::TonemapDrago::setSaturation

```cpp
void cv::TonemapDrago::setSaturation( float saturation )

AutoIt:
    $oTonemapDrago.setSaturation( $saturation ) -> None
```

### cv::TonemapDrago::getBias

```cpp
float cv::TonemapDrago::getBias()

AutoIt:
    $oTonemapDrago.getBias() -> retval
```

### cv::TonemapDrago::setBias

```cpp
void cv::TonemapDrago::setBias( float bias )

AutoIt:
    $oTonemapDrago.setBias( $bias ) -> None
```

### cv::TonemapDrago::process

```cpp
void cv::TonemapDrago::process( _InputArray  src,
                                _OutputArray dst )

AutoIt:
    $oTonemapDrago.process( $src[, $dst] ) -> $dst
```

### cv::TonemapDrago::getGamma

```cpp
float cv::TonemapDrago::getGamma()

AutoIt:
    $oTonemapDrago.getGamma() -> retval
```

### cv::TonemapDrago::setGamma

```cpp
void cv::TonemapDrago::setGamma( float gamma )

AutoIt:
    $oTonemapDrago.setGamma( $gamma ) -> None
```

### cv::TonemapDrago::clear

```cpp
void cv::TonemapDrago::clear()

AutoIt:
    $oTonemapDrago.clear() -> None
```

### cv::TonemapDrago::write

```cpp
void cv::TonemapDrago::write( const cv::Ptr<cv::FileStorage>& fs,
                              const std::string&              name = String() )

AutoIt:
    $oTonemapDrago.write( $fs[, $name] ) -> None
```

### cv::TonemapDrago::read

```cpp
void cv::TonemapDrago::read( const cv::FileNode& fn )

AutoIt:
    $oTonemapDrago.read( $fn ) -> None
```

### cv::TonemapDrago::empty

```cpp
bool cv::TonemapDrago::empty()

AutoIt:
    $oTonemapDrago.empty() -> retval
```

### cv::TonemapDrago::save

```cpp
void cv::TonemapDrago::save( const std::string& filename )

AutoIt:
    $oTonemapDrago.save( $filename ) -> None
```

### cv::TonemapDrago::getDefaultName

```cpp
std::string cv::TonemapDrago::getDefaultName()

AutoIt:
    $oTonemapDrago.getDefaultName() -> retval
```

## cv::TonemapReinhard

### cv::TonemapReinhard::getIntensity

```cpp
float cv::TonemapReinhard::getIntensity()

AutoIt:
    $oTonemapReinhard.getIntensity() -> retval
```

### cv::TonemapReinhard::setIntensity

```cpp
void cv::TonemapReinhard::setIntensity( float intensity )

AutoIt:
    $oTonemapReinhard.setIntensity( $intensity ) -> None
```

### cv::TonemapReinhard::getLightAdaptation

```cpp
float cv::TonemapReinhard::getLightAdaptation()

AutoIt:
    $oTonemapReinhard.getLightAdaptation() -> retval
```

### cv::TonemapReinhard::setLightAdaptation

```cpp
void cv::TonemapReinhard::setLightAdaptation( float light_adapt )

AutoIt:
    $oTonemapReinhard.setLightAdaptation( $light_adapt ) -> None
```

### cv::TonemapReinhard::getColorAdaptation

```cpp
float cv::TonemapReinhard::getColorAdaptation()

AutoIt:
    $oTonemapReinhard.getColorAdaptation() -> retval
```

### cv::TonemapReinhard::setColorAdaptation

```cpp
void cv::TonemapReinhard::setColorAdaptation( float color_adapt )

AutoIt:
    $oTonemapReinhard.setColorAdaptation( $color_adapt ) -> None
```

### cv::TonemapReinhard::process

```cpp
void cv::TonemapReinhard::process( _InputArray  src,
                                   _OutputArray dst )

AutoIt:
    $oTonemapReinhard.process( $src[, $dst] ) -> $dst
```

### cv::TonemapReinhard::getGamma

```cpp
float cv::TonemapReinhard::getGamma()

AutoIt:
    $oTonemapReinhard.getGamma() -> retval
```

### cv::TonemapReinhard::setGamma

```cpp
void cv::TonemapReinhard::setGamma( float gamma )

AutoIt:
    $oTonemapReinhard.setGamma( $gamma ) -> None
```

### cv::TonemapReinhard::clear

```cpp
void cv::TonemapReinhard::clear()

AutoIt:
    $oTonemapReinhard.clear() -> None
```

### cv::TonemapReinhard::write

```cpp
void cv::TonemapReinhard::write( const cv::Ptr<cv::FileStorage>& fs,
                                 const std::string&              name = String() )

AutoIt:
    $oTonemapReinhard.write( $fs[, $name] ) -> None
```

### cv::TonemapReinhard::read

```cpp
void cv::TonemapReinhard::read( const cv::FileNode& fn )

AutoIt:
    $oTonemapReinhard.read( $fn ) -> None
```

### cv::TonemapReinhard::empty

```cpp
bool cv::TonemapReinhard::empty()

AutoIt:
    $oTonemapReinhard.empty() -> retval
```

### cv::TonemapReinhard::save

```cpp
void cv::TonemapReinhard::save( const std::string& filename )

AutoIt:
    $oTonemapReinhard.save( $filename ) -> None
```

### cv::TonemapReinhard::getDefaultName

```cpp
std::string cv::TonemapReinhard::getDefaultName()

AutoIt:
    $oTonemapReinhard.getDefaultName() -> retval
```

## cv::TonemapMantiuk

### cv::TonemapMantiuk::getScale

```cpp
float cv::TonemapMantiuk::getScale()

AutoIt:
    $oTonemapMantiuk.getScale() -> retval
```

### cv::TonemapMantiuk::setScale

```cpp
void cv::TonemapMantiuk::setScale( float scale )

AutoIt:
    $oTonemapMantiuk.setScale( $scale ) -> None
```

### cv::TonemapMantiuk::getSaturation

```cpp
float cv::TonemapMantiuk::getSaturation()

AutoIt:
    $oTonemapMantiuk.getSaturation() -> retval
```

### cv::TonemapMantiuk::setSaturation

```cpp
void cv::TonemapMantiuk::setSaturation( float saturation )

AutoIt:
    $oTonemapMantiuk.setSaturation( $saturation ) -> None
```

### cv::TonemapMantiuk::process

```cpp
void cv::TonemapMantiuk::process( _InputArray  src,
                                  _OutputArray dst )

AutoIt:
    $oTonemapMantiuk.process( $src[, $dst] ) -> $dst
```

### cv::TonemapMantiuk::getGamma

```cpp
float cv::TonemapMantiuk::getGamma()

AutoIt:
    $oTonemapMantiuk.getGamma() -> retval
```

### cv::TonemapMantiuk::setGamma

```cpp
void cv::TonemapMantiuk::setGamma( float gamma )

AutoIt:
    $oTonemapMantiuk.setGamma( $gamma ) -> None
```

### cv::TonemapMantiuk::clear

```cpp
void cv::TonemapMantiuk::clear()

AutoIt:
    $oTonemapMantiuk.clear() -> None
```

### cv::TonemapMantiuk::write

```cpp
void cv::TonemapMantiuk::write( const cv::Ptr<cv::FileStorage>& fs,
                                const std::string&              name = String() )

AutoIt:
    $oTonemapMantiuk.write( $fs[, $name] ) -> None
```

### cv::TonemapMantiuk::read

```cpp
void cv::TonemapMantiuk::read( const cv::FileNode& fn )

AutoIt:
    $oTonemapMantiuk.read( $fn ) -> None
```

### cv::TonemapMantiuk::empty

```cpp
bool cv::TonemapMantiuk::empty()

AutoIt:
    $oTonemapMantiuk.empty() -> retval
```

### cv::TonemapMantiuk::save

```cpp
void cv::TonemapMantiuk::save( const std::string& filename )

AutoIt:
    $oTonemapMantiuk.save( $filename ) -> None
```

### cv::TonemapMantiuk::getDefaultName

```cpp
std::string cv::TonemapMantiuk::getDefaultName()

AutoIt:
    $oTonemapMantiuk.getDefaultName() -> retval
```

## cv::AlignExposures

### cv::AlignExposures::process

```cpp
void cv::AlignExposures::process( _InputArray           src,
                                  std::vector<cv::Mat>& dst,
                                  _InputArray           times,
                                  _InputArray           response )

AutoIt:
    $oAlignExposures.process( $src, $dst, $times, $response ) -> None
```

### cv::AlignExposures::clear

```cpp
void cv::AlignExposures::clear()

AutoIt:
    $oAlignExposures.clear() -> None
```

### cv::AlignExposures::write

```cpp
void cv::AlignExposures::write( const cv::Ptr<cv::FileStorage>& fs,
                                const std::string&              name = String() )

AutoIt:
    $oAlignExposures.write( $fs[, $name] ) -> None
```

### cv::AlignExposures::read

```cpp
void cv::AlignExposures::read( const cv::FileNode& fn )

AutoIt:
    $oAlignExposures.read( $fn ) -> None
```

### cv::AlignExposures::empty

```cpp
bool cv::AlignExposures::empty()

AutoIt:
    $oAlignExposures.empty() -> retval
```

### cv::AlignExposures::save

```cpp
void cv::AlignExposures::save( const std::string& filename )

AutoIt:
    $oAlignExposures.save( $filename ) -> None
```

### cv::AlignExposures::getDefaultName

```cpp
std::string cv::AlignExposures::getDefaultName()

AutoIt:
    $oAlignExposures.getDefaultName() -> retval
```

## cv::AlignMTB

### cv::AlignMTB::process

```cpp
void cv::AlignMTB::process( _InputArray           src,
                            std::vector<cv::Mat>& dst,
                            _InputArray           times,
                            _InputArray           response )

AutoIt:
    $oAlignMTB.process( $src, $dst, $times, $response ) -> None
```

```cpp
void cv::AlignMTB::process( _InputArray           src,
                            std::vector<cv::Mat>& dst )

AutoIt:
    $oAlignMTB.process( $src, $dst ) -> None
```

### cv::AlignMTB::calculateShift

```cpp
cv::Point cv::AlignMTB::calculateShift( _InputArray img0,
                                        _InputArray img1 )

AutoIt:
    $oAlignMTB.calculateShift( $img0, $img1 ) -> retval
```

### cv::AlignMTB::shiftMat

```cpp
void cv::AlignMTB::shiftMat( _InputArray     src,
                             _OutputArray    dst,
                             const cv::Point shift )

AutoIt:
    $oAlignMTB.shiftMat( $src, $shift[, $dst] ) -> $dst
```

### cv::AlignMTB::computeBitmaps

```cpp
void cv::AlignMTB::computeBitmaps( _InputArray  img,
                                   _OutputArray tb,
                                   _OutputArray eb )

AutoIt:
    $oAlignMTB.computeBitmaps( $img[, $tb[, $eb]] ) -> $tb, $eb
```

### cv::AlignMTB::getMaxBits

```cpp
int cv::AlignMTB::getMaxBits()

AutoIt:
    $oAlignMTB.getMaxBits() -> retval
```

### cv::AlignMTB::setMaxBits

```cpp
void cv::AlignMTB::setMaxBits( int max_bits )

AutoIt:
    $oAlignMTB.setMaxBits( $max_bits ) -> None
```

### cv::AlignMTB::getExcludeRange

```cpp
int cv::AlignMTB::getExcludeRange()

AutoIt:
    $oAlignMTB.getExcludeRange() -> retval
```

### cv::AlignMTB::setExcludeRange

```cpp
void cv::AlignMTB::setExcludeRange( int exclude_range )

AutoIt:
    $oAlignMTB.setExcludeRange( $exclude_range ) -> None
```

### cv::AlignMTB::getCut

```cpp
bool cv::AlignMTB::getCut()

AutoIt:
    $oAlignMTB.getCut() -> retval
```

### cv::AlignMTB::setCut

```cpp
void cv::AlignMTB::setCut( bool value )

AutoIt:
    $oAlignMTB.setCut( $value ) -> None
```

### cv::AlignMTB::clear

```cpp
void cv::AlignMTB::clear()

AutoIt:
    $oAlignMTB.clear() -> None
```

### cv::AlignMTB::write

```cpp
void cv::AlignMTB::write( const cv::Ptr<cv::FileStorage>& fs,
                          const std::string&              name = String() )

AutoIt:
    $oAlignMTB.write( $fs[, $name] ) -> None
```

### cv::AlignMTB::read

```cpp
void cv::AlignMTB::read( const cv::FileNode& fn )

AutoIt:
    $oAlignMTB.read( $fn ) -> None
```

### cv::AlignMTB::empty

```cpp
bool cv::AlignMTB::empty()

AutoIt:
    $oAlignMTB.empty() -> retval
```

### cv::AlignMTB::save

```cpp
void cv::AlignMTB::save( const std::string& filename )

AutoIt:
    $oAlignMTB.save( $filename ) -> None
```

### cv::AlignMTB::getDefaultName

```cpp
std::string cv::AlignMTB::getDefaultName()

AutoIt:
    $oAlignMTB.getDefaultName() -> retval
```

## cv::CalibrateCRF

### cv::CalibrateCRF::process

```cpp
void cv::CalibrateCRF::process( _InputArray  src,
                                _OutputArray dst,
                                _InputArray  times )

AutoIt:
    $oCalibrateCRF.process( $src, $times[, $dst] ) -> $dst
```

### cv::CalibrateCRF::clear

```cpp
void cv::CalibrateCRF::clear()

AutoIt:
    $oCalibrateCRF.clear() -> None
```

### cv::CalibrateCRF::write

```cpp
void cv::CalibrateCRF::write( const cv::Ptr<cv::FileStorage>& fs,
                              const std::string&              name = String() )

AutoIt:
    $oCalibrateCRF.write( $fs[, $name] ) -> None
```

### cv::CalibrateCRF::read

```cpp
void cv::CalibrateCRF::read( const cv::FileNode& fn )

AutoIt:
    $oCalibrateCRF.read( $fn ) -> None
```

### cv::CalibrateCRF::empty

```cpp
bool cv::CalibrateCRF::empty()

AutoIt:
    $oCalibrateCRF.empty() -> retval
```

### cv::CalibrateCRF::save

```cpp
void cv::CalibrateCRF::save( const std::string& filename )

AutoIt:
    $oCalibrateCRF.save( $filename ) -> None
```

### cv::CalibrateCRF::getDefaultName

```cpp
std::string cv::CalibrateCRF::getDefaultName()

AutoIt:
    $oCalibrateCRF.getDefaultName() -> retval
```

## cv::CalibrateDebevec

### cv::CalibrateDebevec::getLambda

```cpp
float cv::CalibrateDebevec::getLambda()

AutoIt:
    $oCalibrateDebevec.getLambda() -> retval
```

### cv::CalibrateDebevec::setLambda

```cpp
void cv::CalibrateDebevec::setLambda( float lambda )

AutoIt:
    $oCalibrateDebevec.setLambda( $lambda ) -> None
```

### cv::CalibrateDebevec::getSamples

```cpp
int cv::CalibrateDebevec::getSamples()

AutoIt:
    $oCalibrateDebevec.getSamples() -> retval
```

### cv::CalibrateDebevec::setSamples

```cpp
void cv::CalibrateDebevec::setSamples( int samples )

AutoIt:
    $oCalibrateDebevec.setSamples( $samples ) -> None
```

### cv::CalibrateDebevec::getRandom

```cpp
bool cv::CalibrateDebevec::getRandom()

AutoIt:
    $oCalibrateDebevec.getRandom() -> retval
```

### cv::CalibrateDebevec::setRandom

```cpp
void cv::CalibrateDebevec::setRandom( bool random )

AutoIt:
    $oCalibrateDebevec.setRandom( $random ) -> None
```

### cv::CalibrateDebevec::process

```cpp
void cv::CalibrateDebevec::process( _InputArray  src,
                                    _OutputArray dst,
                                    _InputArray  times )

AutoIt:
    $oCalibrateDebevec.process( $src, $times[, $dst] ) -> $dst
```

### cv::CalibrateDebevec::clear

```cpp
void cv::CalibrateDebevec::clear()

AutoIt:
    $oCalibrateDebevec.clear() -> None
```

### cv::CalibrateDebevec::write

```cpp
void cv::CalibrateDebevec::write( const cv::Ptr<cv::FileStorage>& fs,
                                  const std::string&              name = String() )

AutoIt:
    $oCalibrateDebevec.write( $fs[, $name] ) -> None
```

### cv::CalibrateDebevec::read

```cpp
void cv::CalibrateDebevec::read( const cv::FileNode& fn )

AutoIt:
    $oCalibrateDebevec.read( $fn ) -> None
```

### cv::CalibrateDebevec::empty

```cpp
bool cv::CalibrateDebevec::empty()

AutoIt:
    $oCalibrateDebevec.empty() -> retval
```

### cv::CalibrateDebevec::save

```cpp
void cv::CalibrateDebevec::save( const std::string& filename )

AutoIt:
    $oCalibrateDebevec.save( $filename ) -> None
```

### cv::CalibrateDebevec::getDefaultName

```cpp
std::string cv::CalibrateDebevec::getDefaultName()

AutoIt:
    $oCalibrateDebevec.getDefaultName() -> retval
```

## cv::CalibrateRobertson

### cv::CalibrateRobertson::getMaxIter

```cpp
int cv::CalibrateRobertson::getMaxIter()

AutoIt:
    $oCalibrateRobertson.getMaxIter() -> retval
```

### cv::CalibrateRobertson::setMaxIter

```cpp
void cv::CalibrateRobertson::setMaxIter( int max_iter )

AutoIt:
    $oCalibrateRobertson.setMaxIter( $max_iter ) -> None
```

### cv::CalibrateRobertson::getThreshold

```cpp
float cv::CalibrateRobertson::getThreshold()

AutoIt:
    $oCalibrateRobertson.getThreshold() -> retval
```

### cv::CalibrateRobertson::setThreshold

```cpp
void cv::CalibrateRobertson::setThreshold( float threshold )

AutoIt:
    $oCalibrateRobertson.setThreshold( $threshold ) -> None
```

### cv::CalibrateRobertson::getRadiance

```cpp
cv::Mat cv::CalibrateRobertson::getRadiance()

AutoIt:
    $oCalibrateRobertson.getRadiance() -> retval
```

### cv::CalibrateRobertson::process

```cpp
void cv::CalibrateRobertson::process( _InputArray  src,
                                      _OutputArray dst,
                                      _InputArray  times )

AutoIt:
    $oCalibrateRobertson.process( $src, $times[, $dst] ) -> $dst
```

### cv::CalibrateRobertson::clear

```cpp
void cv::CalibrateRobertson::clear()

AutoIt:
    $oCalibrateRobertson.clear() -> None
```

### cv::CalibrateRobertson::write

```cpp
void cv::CalibrateRobertson::write( const cv::Ptr<cv::FileStorage>& fs,
                                    const std::string&              name = String() )

AutoIt:
    $oCalibrateRobertson.write( $fs[, $name] ) -> None
```

### cv::CalibrateRobertson::read

```cpp
void cv::CalibrateRobertson::read( const cv::FileNode& fn )

AutoIt:
    $oCalibrateRobertson.read( $fn ) -> None
```

### cv::CalibrateRobertson::empty

```cpp
bool cv::CalibrateRobertson::empty()

AutoIt:
    $oCalibrateRobertson.empty() -> retval
```

### cv::CalibrateRobertson::save

```cpp
void cv::CalibrateRobertson::save( const std::string& filename )

AutoIt:
    $oCalibrateRobertson.save( $filename ) -> None
```

### cv::CalibrateRobertson::getDefaultName

```cpp
std::string cv::CalibrateRobertson::getDefaultName()

AutoIt:
    $oCalibrateRobertson.getDefaultName() -> retval
```

## cv::MergeExposures

### cv::MergeExposures::process

```cpp
void cv::MergeExposures::process( _InputArray  src,
                                  _OutputArray dst,
                                  _InputArray  times,
                                  _InputArray  response )

AutoIt:
    $oMergeExposures.process( $src, $times, $response[, $dst] ) -> $dst
```

### cv::MergeExposures::clear

```cpp
void cv::MergeExposures::clear()

AutoIt:
    $oMergeExposures.clear() -> None
```

### cv::MergeExposures::write

```cpp
void cv::MergeExposures::write( const cv::Ptr<cv::FileStorage>& fs,
                                const std::string&              name = String() )

AutoIt:
    $oMergeExposures.write( $fs[, $name] ) -> None
```

### cv::MergeExposures::read

```cpp
void cv::MergeExposures::read( const cv::FileNode& fn )

AutoIt:
    $oMergeExposures.read( $fn ) -> None
```

### cv::MergeExposures::empty

```cpp
bool cv::MergeExposures::empty()

AutoIt:
    $oMergeExposures.empty() -> retval
```

### cv::MergeExposures::save

```cpp
void cv::MergeExposures::save( const std::string& filename )

AutoIt:
    $oMergeExposures.save( $filename ) -> None
```

### cv::MergeExposures::getDefaultName

```cpp
std::string cv::MergeExposures::getDefaultName()

AutoIt:
    $oMergeExposures.getDefaultName() -> retval
```

## cv::MergeDebevec

### cv::MergeDebevec::process

```cpp
void cv::MergeDebevec::process( _InputArray  src,
                                _OutputArray dst,
                                _InputArray  times,
                                _InputArray  response )

AutoIt:
    $oMergeDebevec.process( $src, $times, $response[, $dst] ) -> $dst
```

```cpp
void cv::MergeDebevec::process( _InputArray  src,
                                _OutputArray dst,
                                _InputArray  times )

AutoIt:
    $oMergeDebevec.process( $src, $times[, $dst] ) -> $dst
```

### cv::MergeDebevec::clear

```cpp
void cv::MergeDebevec::clear()

AutoIt:
    $oMergeDebevec.clear() -> None
```

### cv::MergeDebevec::write

```cpp
void cv::MergeDebevec::write( const cv::Ptr<cv::FileStorage>& fs,
                              const std::string&              name = String() )

AutoIt:
    $oMergeDebevec.write( $fs[, $name] ) -> None
```

### cv::MergeDebevec::read

```cpp
void cv::MergeDebevec::read( const cv::FileNode& fn )

AutoIt:
    $oMergeDebevec.read( $fn ) -> None
```

### cv::MergeDebevec::empty

```cpp
bool cv::MergeDebevec::empty()

AutoIt:
    $oMergeDebevec.empty() -> retval
```

### cv::MergeDebevec::save

```cpp
void cv::MergeDebevec::save( const std::string& filename )

AutoIt:
    $oMergeDebevec.save( $filename ) -> None
```

### cv::MergeDebevec::getDefaultName

```cpp
std::string cv::MergeDebevec::getDefaultName()

AutoIt:
    $oMergeDebevec.getDefaultName() -> retval
```

## cv::MergeMertens

### cv::MergeMertens::process

```cpp
void cv::MergeMertens::process( _InputArray  src,
                                _OutputArray dst,
                                _InputArray  times,
                                _InputArray  response )

AutoIt:
    $oMergeMertens.process( $src, $times, $response[, $dst] ) -> $dst
```

```cpp
void cv::MergeMertens::process( _InputArray  src,
                                _OutputArray dst )

AutoIt:
    $oMergeMertens.process( $src[, $dst] ) -> $dst
```

### cv::MergeMertens::getContrastWeight

```cpp
float cv::MergeMertens::getContrastWeight()

AutoIt:
    $oMergeMertens.getContrastWeight() -> retval
```

### cv::MergeMertens::setContrastWeight

```cpp
void cv::MergeMertens::setContrastWeight( float contrast_weiht )

AutoIt:
    $oMergeMertens.setContrastWeight( $contrast_weiht ) -> None
```

### cv::MergeMertens::getSaturationWeight

```cpp
float cv::MergeMertens::getSaturationWeight()

AutoIt:
    $oMergeMertens.getSaturationWeight() -> retval
```

### cv::MergeMertens::setSaturationWeight

```cpp
void cv::MergeMertens::setSaturationWeight( float saturation_weight )

AutoIt:
    $oMergeMertens.setSaturationWeight( $saturation_weight ) -> None
```

### cv::MergeMertens::getExposureWeight

```cpp
float cv::MergeMertens::getExposureWeight()

AutoIt:
    $oMergeMertens.getExposureWeight() -> retval
```

### cv::MergeMertens::setExposureWeight

```cpp
void cv::MergeMertens::setExposureWeight( float exposure_weight )

AutoIt:
    $oMergeMertens.setExposureWeight( $exposure_weight ) -> None
```

### cv::MergeMertens::clear

```cpp
void cv::MergeMertens::clear()

AutoIt:
    $oMergeMertens.clear() -> None
```

### cv::MergeMertens::write

```cpp
void cv::MergeMertens::write( const cv::Ptr<cv::FileStorage>& fs,
                              const std::string&              name = String() )

AutoIt:
    $oMergeMertens.write( $fs[, $name] ) -> None
```

### cv::MergeMertens::read

```cpp
void cv::MergeMertens::read( const cv::FileNode& fn )

AutoIt:
    $oMergeMertens.read( $fn ) -> None
```

### cv::MergeMertens::empty

```cpp
bool cv::MergeMertens::empty()

AutoIt:
    $oMergeMertens.empty() -> retval
```

### cv::MergeMertens::save

```cpp
void cv::MergeMertens::save( const std::string& filename )

AutoIt:
    $oMergeMertens.save( $filename ) -> None
```

### cv::MergeMertens::getDefaultName

```cpp
std::string cv::MergeMertens::getDefaultName()

AutoIt:
    $oMergeMertens.getDefaultName() -> retval
```

## cv::MergeRobertson

### cv::MergeRobertson::process

```cpp
void cv::MergeRobertson::process( _InputArray  src,
                                  _OutputArray dst,
                                  _InputArray  times,
                                  _InputArray  response )

AutoIt:
    $oMergeRobertson.process( $src, $times, $response[, $dst] ) -> $dst
```

```cpp
void cv::MergeRobertson::process( _InputArray  src,
                                  _OutputArray dst,
                                  _InputArray  times )

AutoIt:
    $oMergeRobertson.process( $src, $times[, $dst] ) -> $dst
```

### cv::MergeRobertson::clear

```cpp
void cv::MergeRobertson::clear()

AutoIt:
    $oMergeRobertson.clear() -> None
```

### cv::MergeRobertson::write

```cpp
void cv::MergeRobertson::write( const cv::Ptr<cv::FileStorage>& fs,
                                const std::string&              name = String() )

AutoIt:
    $oMergeRobertson.write( $fs[, $name] ) -> None
```

### cv::MergeRobertson::read

```cpp
void cv::MergeRobertson::read( const cv::FileNode& fn )

AutoIt:
    $oMergeRobertson.read( $fn ) -> None
```

### cv::MergeRobertson::empty

```cpp
bool cv::MergeRobertson::empty()

AutoIt:
    $oMergeRobertson.empty() -> retval
```

### cv::MergeRobertson::save

```cpp
void cv::MergeRobertson::save( const std::string& filename )

AutoIt:
    $oMergeRobertson.save( $filename ) -> None
```

### cv::MergeRobertson::getDefaultName

```cpp
std::string cv::MergeRobertson::getDefaultName()

AutoIt:
    $oMergeRobertson.getDefaultName() -> retval
```

## cv::dnn

### cv::dnn::getAvailableTargets

```cpp
std::vector<int> cv::dnn::getAvailableTargets( int be )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").getAvailableTargets( $be ) -> retval
```

### cv::dnn::readNetFromDarknet

```cpp
cv::dnn::Net cv::dnn::readNetFromDarknet( const std::string& cfgFile,
                                          const std::string& darknetModel = String() )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").readNetFromDarknet( $cfgFile[, $darknetModel] ) -> retval
```

```cpp
cv::dnn::Net cv::dnn::readNetFromDarknet( const std::vector<uchar>& bufferCfg,
                                          const std::vector<uchar>& bufferModel = std::vector<uchar>() )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").readNetFromDarknet( $bufferCfg[, $bufferModel] ) -> retval
```

### cv::dnn::readNetFromCaffe

```cpp
cv::dnn::Net cv::dnn::readNetFromCaffe( const std::string& prototxt,
                                        const std::string& caffeModel = String() )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").readNetFromCaffe( $prototxt[, $caffeModel] ) -> retval
```

```cpp
cv::dnn::Net cv::dnn::readNetFromCaffe( const std::vector<uchar>& bufferProto,
                                        const std::vector<uchar>& bufferModel = std::vector<uchar>() )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").readNetFromCaffe( $bufferProto[, $bufferModel] ) -> retval
```

### cv::dnn::readNetFromTensorflow

```cpp
cv::dnn::Net cv::dnn::readNetFromTensorflow( const std::string& model,
                                             const std::string& config = String() )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").readNetFromTensorflow( $model[, $config] ) -> retval
```

```cpp
cv::dnn::Net cv::dnn::readNetFromTensorflow( const std::vector<uchar>& bufferModel,
                                             const std::vector<uchar>& bufferConfig = std::vector<uchar>() )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").readNetFromTensorflow( $bufferModel[, $bufferConfig] ) -> retval
```

### cv::dnn::readNetFromTorch

```cpp
cv::dnn::Net cv::dnn::readNetFromTorch( const std::string& model,
                                        bool               isBinary = true,
                                        bool               evaluate = true )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").readNetFromTorch( $model[, $isBinary[, $evaluate]] ) -> retval
```

### cv::dnn::readNet

```cpp
cv::dnn::Net cv::dnn::readNet( const std::string& model,
                               const std::string& config = "",
                               const std::string& framework = "" )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").readNet( $model[, $config[, $framework]] ) -> retval
```

```cpp
cv::dnn::Net cv::dnn::readNet( const std::string&        framework,
                               const std::vector<uchar>& bufferModel,
                               const std::vector<uchar>& bufferConfig = std::vector<uchar>() )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").readNet( $framework, $bufferModel[, $bufferConfig] ) -> retval
```

### cv::dnn::readTorchBlob

```cpp
cv::Mat cv::dnn::readTorchBlob( const std::string& filename,
                                bool               isBinary = true )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").readTorchBlob( $filename[, $isBinary] ) -> retval
```

### cv::dnn::readNetFromModelOptimizer

```cpp
cv::dnn::Net cv::dnn::readNetFromModelOptimizer( const std::string& xml,
                                                 const std::string& bin )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").readNetFromModelOptimizer( $xml, $bin ) -> retval
```

```cpp
cv::dnn::Net cv::dnn::readNetFromModelOptimizer( const std::vector<uchar>& bufferModelConfig,
                                                 const std::vector<uchar>& bufferWeights )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").readNetFromModelOptimizer( $bufferModelConfig, $bufferWeights ) -> retval
```

### cv::dnn::readNetFromONNX

```cpp
cv::dnn::Net cv::dnn::readNetFromONNX( const std::string& onnxFile )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").readNetFromONNX( $onnxFile ) -> retval
```

```cpp
cv::dnn::Net cv::dnn::readNetFromONNX( const std::vector<uchar>& buffer )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").readNetFromONNX( $buffer ) -> retval
```

### cv::dnn::readTensorFromONNX

```cpp
cv::Mat cv::dnn::readTensorFromONNX( const std::string& path )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").readTensorFromONNX( $path ) -> retval
```

### cv::dnn::blobFromImage

```cpp
cv::Mat cv::dnn::blobFromImage( _InputArray       image,
                                double            scalefactor = 1.0,
                                const cv::Size&   size = Size(),
                                const cv::Scalar& mean = Scalar(),
                                bool              swapRB = false,
                                bool              crop = false,
                                int               ddepth = CV_32F )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").blobFromImage( $image[, $scalefactor[, $size[, $mean[, $swapRB[, $crop[, $ddepth]]]]]] ) -> retval
```

### cv::dnn::blobFromImages

```cpp
cv::Mat cv::dnn::blobFromImages( _InputArray       images,
                                 double            scalefactor = 1.0,
                                 cv::Size          size = Size(),
                                 const cv::Scalar& mean = Scalar(),
                                 bool              swapRB = false,
                                 bool              crop = false,
                                 int               ddepth = CV_32F )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").blobFromImages( $images[, $scalefactor[, $size[, $mean[, $swapRB[, $crop[, $ddepth]]]]]] ) -> retval
```

### cv::dnn::imagesFromBlob

```cpp
void cv::dnn::imagesFromBlob( const cv::Mat& blob_,
                              _OutputArray   images_ )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").imagesFromBlob( $blob_[, $images_] ) -> $images_
```

### cv::dnn::shrinkCaffeModel

```cpp
void cv::dnn::shrinkCaffeModel( const std::string&              src,
                                const std::string&              dst,
                                const std::vector<std::string>& layersTypes = std::vector<String>() )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").shrinkCaffeModel( $src, $dst[, $layersTypes] ) -> None
```

### cv::dnn::writeTextGraph

```cpp
void cv::dnn::writeTextGraph( const std::string& model,
                              const std::string& output )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").writeTextGraph( $model, $output ) -> None
```

### cv::dnn::NMSBoxes

```cpp
void cv::dnn::NMSBoxes( const std::vector<cv::Rect2d>& bboxes,
                        const std::vector<float>&      scores,
                        const float                    score_threshold,
                        const float                    nms_threshold,
                        std::vector<int>&              indices,
                        const float                    eta = 1.f,
                        const int                      top_k = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").NMSBoxes( $bboxes, $scores, $score_threshold, $nms_threshold[, $eta[, $top_k[, $indices]]] ) -> $indices
```

### cv::dnn::NMSBoxesRotated

```cpp
void cv::dnn::NMSBoxesRotated( const std::vector<cv::RotatedRect>& bboxes,
                               const std::vector<float>&           scores,
                               const float                         score_threshold,
                               const float                         nms_threshold,
                               std::vector<int>&                   indices,
                               const float                         eta = 1.f,
                               const int                           top_k = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").NMSBoxesRotated( $bboxes, $scores, $score_threshold, $nms_threshold[, $eta[, $top_k[, $indices]]] ) -> $indices
```

### cv::dnn::softNMSBoxes

```cpp
void cv::dnn::softNMSBoxes( const std::vector<cv::Rect>& bboxes,
                            const std::vector<float>&    scores,
                            std::vector<float>&          updated_scores,
                            const float                  score_threshold,
                            const float                  nms_threshold,
                            std::vector<int>&            indices,
                            size_t                       top_k = 0,
                            const float                  sigma = 0.5,
                            int                          method = SoftNMSMethod::SOFTNMS_GAUSSIAN )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn").softNMSBoxes( $bboxes, $scores, $score_threshold, $nms_threshold[, $top_k[, $sigma[, $method[, $updated_scores[, $indices]]]]] ) -> $updated_scores, $indices
```

## cv::dnn::DictValue

### cv::dnn::DictValue::create

```cpp
static cv::dnn::DictValue cv::dnn::DictValue::create()

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.DictValue").create() -> <cv.dnn.DictValue object>
```

```cpp
static cv::dnn::DictValue cv::dnn::DictValue::create( int i )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.DictValue").create( $i ) -> <cv.dnn.DictValue object>
```

```cpp
static cv::dnn::DictValue cv::dnn::DictValue::create( double p )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.DictValue").create( $p ) -> <cv.dnn.DictValue object>
```

```cpp
static cv::dnn::DictValue cv::dnn::DictValue::create( const std::string& s )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.DictValue").create( $s ) -> <cv.dnn.DictValue object>
```

### cv::dnn::DictValue::isInt

```cpp
bool cv::dnn::DictValue::isInt()

AutoIt:
    $oDictValue.isInt() -> retval
```

### cv::dnn::DictValue::isString

```cpp
bool cv::dnn::DictValue::isString()

AutoIt:
    $oDictValue.isString() -> retval
```

### cv::dnn::DictValue::isReal

```cpp
bool cv::dnn::DictValue::isReal()

AutoIt:
    $oDictValue.isReal() -> retval
```

### cv::dnn::DictValue::getIntValue

```cpp
int cv::dnn::DictValue::getIntValue( int idx = -1 )

AutoIt:
    $oDictValue.getIntValue( [$idx] ) -> retval
```

### cv::dnn::DictValue::getRealValue

```cpp
double cv::dnn::DictValue::getRealValue( int idx = -1 )

AutoIt:
    $oDictValue.getRealValue( [$idx] ) -> retval
```

### cv::dnn::DictValue::getStringValue

```cpp
std::string cv::dnn::DictValue::getStringValue( int idx = -1 )

AutoIt:
    $oDictValue.getStringValue( [$idx] ) -> retval
```

## cv::dnn::Layer

### cv::dnn::Layer::finalize

```cpp
void cv::dnn::Layer::finalize( _InputArray  inputs,
                               _OutputArray outputs )

AutoIt:
    $oLayer.finalize( $inputs[, $outputs] ) -> $outputs
```

### cv::dnn::Layer::run

```cpp
void cv::dnn::Layer::run( const std::vector<cv::Mat>& inputs,
                          std::vector<cv::Mat>&       outputs,
                          std::vector<cv::Mat>&       internals )

AutoIt:
    $oLayer.run( $inputs, $internals[, $outputs] ) -> $outputs, $internals
```

### cv::dnn::Layer::outputNameToIndex

```cpp
int cv::dnn::Layer::outputNameToIndex( const std::string& outputName )

AutoIt:
    $oLayer.outputNameToIndex( $outputName ) -> retval
```

### cv::dnn::Layer::clear

```cpp
void cv::dnn::Layer::clear()

AutoIt:
    $oLayer.clear() -> None
```

### cv::dnn::Layer::write

```cpp
void cv::dnn::Layer::write( const cv::Ptr<cv::FileStorage>& fs,
                            const std::string&              name = String() )

AutoIt:
    $oLayer.write( $fs[, $name] ) -> None
```

### cv::dnn::Layer::read

```cpp
void cv::dnn::Layer::read( const cv::FileNode& fn )

AutoIt:
    $oLayer.read( $fn ) -> None
```

### cv::dnn::Layer::empty

```cpp
bool cv::dnn::Layer::empty()

AutoIt:
    $oLayer.empty() -> retval
```

### cv::dnn::Layer::save

```cpp
void cv::dnn::Layer::save( const std::string& filename )

AutoIt:
    $oLayer.save( $filename ) -> None
```

### cv::dnn::Layer::getDefaultName

```cpp
std::string cv::dnn::Layer::getDefaultName()

AutoIt:
    $oLayer.getDefaultName() -> retval
```

## cv::dnn::Net

### cv::dnn::Net::create

```cpp
static cv::dnn::Net cv::dnn::Net::create()

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.Net").create() -> <cv.dnn.Net object>
```

### cv::dnn::Net::readFromModelOptimizer

```cpp
static cv::dnn::Net cv::dnn::Net::readFromModelOptimizer( const std::string& xml,
                                                          const std::string& bin )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.Net").readFromModelOptimizer( $xml, $bin ) -> retval
```

```cpp
static cv::dnn::Net cv::dnn::Net::readFromModelOptimizer( const std::vector<uchar>& bufferModelConfig,
                                                          const std::vector<uchar>& bufferWeights )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.Net").readFromModelOptimizer( $bufferModelConfig, $bufferWeights ) -> retval
```

### cv::dnn::Net::empty

```cpp
bool cv::dnn::Net::empty()

AutoIt:
    $oNet.empty() -> retval
```

### cv::dnn::Net::dump

```cpp
std::string cv::dnn::Net::dump()

AutoIt:
    $oNet.dump() -> retval
```

### cv::dnn::Net::dumpToFile

```cpp
void cv::dnn::Net::dumpToFile( const std::string& path )

AutoIt:
    $oNet.dumpToFile( $path ) -> None
```

### cv::dnn::Net::getLayerId

```cpp
int cv::dnn::Net::getLayerId( const std::string& layer )

AutoIt:
    $oNet.getLayerId( $layer ) -> retval
```

### cv::dnn::Net::getLayerNames

```cpp
std::vector<std::string> cv::dnn::Net::getLayerNames()

AutoIt:
    $oNet.getLayerNames() -> retval
```

### cv::dnn::Net::getLayer

```cpp
cv::Ptr<cv::dnn::Layer> cv::dnn::Net::getLayer( cv::dnn::DictValue layerId )

AutoIt:
    $oNet.getLayer( $layerId ) -> retval
```

### cv::dnn::Net::connect

```cpp
void cv::dnn::Net::connect( std::string outPin,
                            std::string inpPin )

AutoIt:
    $oNet.connect( $outPin, $inpPin ) -> None
```

### cv::dnn::Net::setInputsNames

```cpp
void cv::dnn::Net::setInputsNames( const std::vector<std::string>& inputBlobNames )

AutoIt:
    $oNet.setInputsNames( $inputBlobNames ) -> None
```

### cv::dnn::Net::setInputShape

```cpp
void cv::dnn::Net::setInputShape( const std::string&      inputName,
                                  const std::vector<int>& shape )

AutoIt:
    $oNet.setInputShape( $inputName, $shape ) -> None
```

### cv::dnn::Net::forward

```cpp
cv::Mat cv::dnn::Net::forward( const std::string& outputName = String() )

AutoIt:
    $oNet.forward( [$outputName] ) -> retval
```

```cpp
void cv::dnn::Net::forward( _OutputArray       outputBlobs,
                            const std::string& outputName = String() )

AutoIt:
    $oNet.forward( [$outputBlobs[, $outputName]] ) -> $outputBlobs
```

```cpp
void cv::dnn::Net::forward( _OutputArray                    outputBlobs,
                            const std::vector<std::string>& outBlobNames )

AutoIt:
    $oNet.forward( $outBlobNames[, $outputBlobs] ) -> $outputBlobs
```

### cv::dnn::Net::forwardAsync

```cpp
cv::AsyncArray cv::dnn::Net::forwardAsync( const std::string& outputName = String() )

AutoIt:
    $oNet.forwardAsync( [$outputName] ) -> retval
```

### cv::dnn::Net::forwardAndRetrieve

```cpp
void cv::dnn::Net::forwardAndRetrieve( std::vector<std::vector<cv::Mat>>& outputBlobs,
                                       const std::vector<std::string>&    outBlobNames )

AutoIt:
    $oNet.forwardAndRetrieve( $outBlobNames[, $outputBlobs] ) -> $outputBlobs
```

### cv::dnn::Net::quantize

```cpp
cv::dnn::Net cv::dnn::Net::quantize( _InputArray calibData,
                                     int         inputsDtype,
                                     int         outputsDtype )

AutoIt:
    $oNet.quantize( $calibData, $inputsDtype, $outputsDtype ) -> retval
```

### cv::dnn::Net::getInputDetails

```cpp
void cv::dnn::Net::getInputDetails( std::vector<float>& scales,
                                    std::vector<int>&   zeropoints )

AutoIt:
    $oNet.getInputDetails( [$scales[, $zeropoints]] ) -> $scales, $zeropoints
```

### cv::dnn::Net::getOutputDetails

```cpp
void cv::dnn::Net::getOutputDetails( std::vector<float>& scales,
                                     std::vector<int>&   zeropoints )

AutoIt:
    $oNet.getOutputDetails( [$scales[, $zeropoints]] ) -> $scales, $zeropoints
```

### cv::dnn::Net::setHalideScheduler

```cpp
void cv::dnn::Net::setHalideScheduler( const std::string& scheduler )

AutoIt:
    $oNet.setHalideScheduler( $scheduler ) -> None
```

### cv::dnn::Net::setPreferableBackend

```cpp
void cv::dnn::Net::setPreferableBackend( int backendId )

AutoIt:
    $oNet.setPreferableBackend( $backendId ) -> None
```

### cv::dnn::Net::setPreferableTarget

```cpp
void cv::dnn::Net::setPreferableTarget( int targetId )

AutoIt:
    $oNet.setPreferableTarget( $targetId ) -> None
```

### cv::dnn::Net::setInput

```cpp
void cv::dnn::Net::setInput( _InputArray        blob,
                             const std::string& name = "",
                             double             scalefactor = 1.0,
                             const cv::Scalar&  mean = Scalar() )

AutoIt:
    $oNet.setInput( $blob[, $name[, $scalefactor[, $mean]]] ) -> None
```

### cv::dnn::Net::setParam

```cpp
void cv::dnn::Net::setParam( cv::dnn::DictValue layer,
                             int                numParam,
                             const cv::Mat&     blob )

AutoIt:
    $oNet.setParam( $layer, $numParam, $blob ) -> None
```

### cv::dnn::Net::getParam

```cpp
cv::Mat cv::dnn::Net::getParam( cv::dnn::DictValue layer,
                                int                numParam = 0 )

AutoIt:
    $oNet.getParam( $layer[, $numParam] ) -> retval
```

### cv::dnn::Net::getUnconnectedOutLayers

```cpp
std::vector<int> cv::dnn::Net::getUnconnectedOutLayers()

AutoIt:
    $oNet.getUnconnectedOutLayers() -> retval
```

### cv::dnn::Net::getUnconnectedOutLayersNames

```cpp
std::vector<std::string> cv::dnn::Net::getUnconnectedOutLayersNames()

AutoIt:
    $oNet.getUnconnectedOutLayersNames() -> retval
```

### cv::dnn::Net::getLayersShapes

```cpp
void cv::dnn::Net::getLayersShapes( const std::vector<std::vector<int>>&        netInputShapes,
                                    std::vector<int>&                           layersIds,
                                    std::vector<std::vector<std::vector<int>>>& inLayersShapes,
                                    std::vector<std::vector<std::vector<int>>>& outLayersShapes )

AutoIt:
    $oNet.getLayersShapes( $netInputShapes[, $layersIds[, $inLayersShapes[, $outLayersShapes]]] ) -> $layersIds, $inLayersShapes, $outLayersShapes
```

```cpp
void cv::dnn::Net::getLayersShapes( const std::vector<int>&                     netInputShape,
                                    std::vector<int>&                           layersIds,
                                    std::vector<std::vector<std::vector<int>>>& inLayersShapes,
                                    std::vector<std::vector<std::vector<int>>>& outLayersShapes )

AutoIt:
    $oNet.getLayersShapes( $netInputShape[, $layersIds[, $inLayersShapes[, $outLayersShapes]]] ) -> $layersIds, $inLayersShapes, $outLayersShapes
```

### cv::dnn::Net::getFLOPS

```cpp
int64 cv::dnn::Net::getFLOPS( const std::vector<std::vector<int>>& netInputShapes )

AutoIt:
    $oNet.getFLOPS( $netInputShapes ) -> retval
```

```cpp
int64 cv::dnn::Net::getFLOPS( const std::vector<int>& netInputShape )

AutoIt:
    $oNet.getFLOPS( $netInputShape ) -> retval
```

```cpp
int64 cv::dnn::Net::getFLOPS( const int                            layerId,
                              const std::vector<std::vector<int>>& netInputShapes )

AutoIt:
    $oNet.getFLOPS( $layerId, $netInputShapes ) -> retval
```

```cpp
int64 cv::dnn::Net::getFLOPS( const int               layerId,
                              const std::vector<int>& netInputShape )

AutoIt:
    $oNet.getFLOPS( $layerId, $netInputShape ) -> retval
```

### cv::dnn::Net::getLayerTypes

```cpp
void cv::dnn::Net::getLayerTypes( std::vector<std::string>& layersTypes )

AutoIt:
    $oNet.getLayerTypes( [$layersTypes] ) -> $layersTypes
```

### cv::dnn::Net::getLayersCount

```cpp
int cv::dnn::Net::getLayersCount( const std::string& layerType )

AutoIt:
    $oNet.getLayersCount( $layerType ) -> retval
```

### cv::dnn::Net::getMemoryConsumption

```cpp
void cv::dnn::Net::getMemoryConsumption( const std::vector<int>& netInputShape,
                                         size_t&                 weights,
                                         size_t&                 blobs )

AutoIt:
    $oNet.getMemoryConsumption( $netInputShape[, $weights[, $blobs]] ) -> $weights, $blobs
```

```cpp
void cv::dnn::Net::getMemoryConsumption( const int                            layerId,
                                         const std::vector<std::vector<int>>& netInputShapes,
                                         size_t&                              weights,
                                         size_t&                              blobs )

AutoIt:
    $oNet.getMemoryConsumption( $layerId, $netInputShapes[, $weights[, $blobs]] ) -> $weights, $blobs
```

```cpp
void cv::dnn::Net::getMemoryConsumption( const int               layerId,
                                         const std::vector<int>& netInputShape,
                                         size_t&                 weights,
                                         size_t&                 blobs )

AutoIt:
    $oNet.getMemoryConsumption( $layerId, $netInputShape[, $weights[, $blobs]] ) -> $weights, $blobs
```

### cv::dnn::Net::enableFusion

```cpp
void cv::dnn::Net::enableFusion( bool fusion )

AutoIt:
    $oNet.enableFusion( $fusion ) -> None
```

### cv::dnn::Net::getPerfProfile

```cpp
int64 cv::dnn::Net::getPerfProfile( std::vector<double>& timings )

AutoIt:
    $oNet.getPerfProfile( [$timings] ) -> retval, $timings
```

## cv::dnn::Model

### cv::dnn::Model::create

```cpp
static cv::dnn::Model cv::dnn::Model::create( const std::string& model,
                                              const std::string& config = "" )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.Model").create( $model[, $config] ) -> <cv.dnn.Model object>
```

```cpp
static cv::dnn::Model cv::dnn::Model::create( const cv::dnn::Net& network )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.Model").create( $network ) -> <cv.dnn.Model object>
```

### cv::dnn::Model::setInputSize

```cpp
cv::dnn::Model cv::dnn::Model::setInputSize( const cv::Size& size )

AutoIt:
    $oModel.setInputSize( $size ) -> retval
```

```cpp
cv::dnn::Model cv::dnn::Model::setInputSize( int width,
                                             int height )

AutoIt:
    $oModel.setInputSize( $width, $height ) -> retval
```

### cv::dnn::Model::setInputMean

```cpp
cv::dnn::Model cv::dnn::Model::setInputMean( const cv::Scalar& mean )

AutoIt:
    $oModel.setInputMean( $mean ) -> retval
```

### cv::dnn::Model::setInputScale

```cpp
cv::dnn::Model cv::dnn::Model::setInputScale( double scale )

AutoIt:
    $oModel.setInputScale( $scale ) -> retval
```

### cv::dnn::Model::setInputCrop

```cpp
cv::dnn::Model cv::dnn::Model::setInputCrop( bool crop )

AutoIt:
    $oModel.setInputCrop( $crop ) -> retval
```

### cv::dnn::Model::setInputSwapRB

```cpp
cv::dnn::Model cv::dnn::Model::setInputSwapRB( bool swapRB )

AutoIt:
    $oModel.setInputSwapRB( $swapRB ) -> retval
```

### cv::dnn::Model::setInputParams

```cpp
void cv::dnn::Model::setInputParams( double            scale = 1.0,
                                     const cv::Size&   size = Size(),
                                     const cv::Scalar& mean = Scalar(),
                                     bool              swapRB = false,
                                     bool              crop = false )

AutoIt:
    $oModel.setInputParams( [$scale[, $size[, $mean[, $swapRB[, $crop]]]]] ) -> None
```

### cv::dnn::Model::predict

```cpp
void cv::dnn::Model::predict( _InputArray  frame,
                              _OutputArray outs )

AutoIt:
    $oModel.predict( $frame[, $outs] ) -> $outs
```

### cv::dnn::Model::setPreferableBackend

```cpp
cv::dnn::Model cv::dnn::Model::setPreferableBackend( int backendId )

AutoIt:
    $oModel.setPreferableBackend( $backendId ) -> retval
```

### cv::dnn::Model::setPreferableTarget

```cpp
cv::dnn::Model cv::dnn::Model::setPreferableTarget( int targetId )

AutoIt:
    $oModel.setPreferableTarget( $targetId ) -> retval
```

## cv::dnn::ClassificationModel

### cv::dnn::ClassificationModel::create

```cpp
static cv::dnn::ClassificationModel cv::dnn::ClassificationModel::create( const std::string& model,
                                                                          const std::string& config = "" )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.ClassificationModel").create( $model[, $config] ) -> <cv.dnn.ClassificationModel object>
```

```cpp
static cv::dnn::ClassificationModel cv::dnn::ClassificationModel::create( const cv::dnn::Net& network )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.ClassificationModel").create( $network ) -> <cv.dnn.ClassificationModel object>
```

### cv::dnn::ClassificationModel::classify

```cpp
void cv::dnn::ClassificationModel::classify( _InputArray frame,
                                             int&        classId,
                                             float&      conf )

AutoIt:
    $oClassificationModel.classify( $frame[, $classId[, $conf]] ) -> $classId, $conf
```

### cv::dnn::ClassificationModel::setInputSize

```cpp
cv::dnn::Model cv::dnn::ClassificationModel::setInputSize( const cv::Size& size )

AutoIt:
    $oClassificationModel.setInputSize( $size ) -> retval
```

```cpp
cv::dnn::Model cv::dnn::ClassificationModel::setInputSize( int width,
                                                           int height )

AutoIt:
    $oClassificationModel.setInputSize( $width, $height ) -> retval
```

### cv::dnn::ClassificationModel::setInputMean

```cpp
cv::dnn::Model cv::dnn::ClassificationModel::setInputMean( const cv::Scalar& mean )

AutoIt:
    $oClassificationModel.setInputMean( $mean ) -> retval
```

### cv::dnn::ClassificationModel::setInputScale

```cpp
cv::dnn::Model cv::dnn::ClassificationModel::setInputScale( double scale )

AutoIt:
    $oClassificationModel.setInputScale( $scale ) -> retval
```

### cv::dnn::ClassificationModel::setInputCrop

```cpp
cv::dnn::Model cv::dnn::ClassificationModel::setInputCrop( bool crop )

AutoIt:
    $oClassificationModel.setInputCrop( $crop ) -> retval
```

### cv::dnn::ClassificationModel::setInputSwapRB

```cpp
cv::dnn::Model cv::dnn::ClassificationModel::setInputSwapRB( bool swapRB )

AutoIt:
    $oClassificationModel.setInputSwapRB( $swapRB ) -> retval
```

### cv::dnn::ClassificationModel::setInputParams

```cpp
void cv::dnn::ClassificationModel::setInputParams( double            scale = 1.0,
                                                   const cv::Size&   size = Size(),
                                                   const cv::Scalar& mean = Scalar(),
                                                   bool              swapRB = false,
                                                   bool              crop = false )

AutoIt:
    $oClassificationModel.setInputParams( [$scale[, $size[, $mean[, $swapRB[, $crop]]]]] ) -> None
```

### cv::dnn::ClassificationModel::predict

```cpp
void cv::dnn::ClassificationModel::predict( _InputArray  frame,
                                            _OutputArray outs )

AutoIt:
    $oClassificationModel.predict( $frame[, $outs] ) -> $outs
```

### cv::dnn::ClassificationModel::setPreferableBackend

```cpp
cv::dnn::Model cv::dnn::ClassificationModel::setPreferableBackend( int backendId )

AutoIt:
    $oClassificationModel.setPreferableBackend( $backendId ) -> retval
```

### cv::dnn::ClassificationModel::setPreferableTarget

```cpp
cv::dnn::Model cv::dnn::ClassificationModel::setPreferableTarget( int targetId )

AutoIt:
    $oClassificationModel.setPreferableTarget( $targetId ) -> retval
```

## cv::dnn::KeypointsModel

### cv::dnn::KeypointsModel::create

```cpp
static cv::dnn::KeypointsModel cv::dnn::KeypointsModel::create( const std::string& model,
                                                                const std::string& config = "" )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.KeypointsModel").create( $model[, $config] ) -> <cv.dnn.KeypointsModel object>
```

```cpp
static cv::dnn::KeypointsModel cv::dnn::KeypointsModel::create( const cv::dnn::Net& network )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.KeypointsModel").create( $network ) -> <cv.dnn.KeypointsModel object>
```

### cv::dnn::KeypointsModel::estimate

```cpp
std::vector<cv::Point2f> cv::dnn::KeypointsModel::estimate( _InputArray frame,
                                                            float       thresh = 0.5 )

AutoIt:
    $oKeypointsModel.estimate( $frame[, $thresh] ) -> retval
```

### cv::dnn::KeypointsModel::setInputSize

```cpp
cv::dnn::Model cv::dnn::KeypointsModel::setInputSize( const cv::Size& size )

AutoIt:
    $oKeypointsModel.setInputSize( $size ) -> retval
```

```cpp
cv::dnn::Model cv::dnn::KeypointsModel::setInputSize( int width,
                                                      int height )

AutoIt:
    $oKeypointsModel.setInputSize( $width, $height ) -> retval
```

### cv::dnn::KeypointsModel::setInputMean

```cpp
cv::dnn::Model cv::dnn::KeypointsModel::setInputMean( const cv::Scalar& mean )

AutoIt:
    $oKeypointsModel.setInputMean( $mean ) -> retval
```

### cv::dnn::KeypointsModel::setInputScale

```cpp
cv::dnn::Model cv::dnn::KeypointsModel::setInputScale( double scale )

AutoIt:
    $oKeypointsModel.setInputScale( $scale ) -> retval
```

### cv::dnn::KeypointsModel::setInputCrop

```cpp
cv::dnn::Model cv::dnn::KeypointsModel::setInputCrop( bool crop )

AutoIt:
    $oKeypointsModel.setInputCrop( $crop ) -> retval
```

### cv::dnn::KeypointsModel::setInputSwapRB

```cpp
cv::dnn::Model cv::dnn::KeypointsModel::setInputSwapRB( bool swapRB )

AutoIt:
    $oKeypointsModel.setInputSwapRB( $swapRB ) -> retval
```

### cv::dnn::KeypointsModel::setInputParams

```cpp
void cv::dnn::KeypointsModel::setInputParams( double            scale = 1.0,
                                              const cv::Size&   size = Size(),
                                              const cv::Scalar& mean = Scalar(),
                                              bool              swapRB = false,
                                              bool              crop = false )

AutoIt:
    $oKeypointsModel.setInputParams( [$scale[, $size[, $mean[, $swapRB[, $crop]]]]] ) -> None
```

### cv::dnn::KeypointsModel::predict

```cpp
void cv::dnn::KeypointsModel::predict( _InputArray  frame,
                                       _OutputArray outs )

AutoIt:
    $oKeypointsModel.predict( $frame[, $outs] ) -> $outs
```

### cv::dnn::KeypointsModel::setPreferableBackend

```cpp
cv::dnn::Model cv::dnn::KeypointsModel::setPreferableBackend( int backendId )

AutoIt:
    $oKeypointsModel.setPreferableBackend( $backendId ) -> retval
```

### cv::dnn::KeypointsModel::setPreferableTarget

```cpp
cv::dnn::Model cv::dnn::KeypointsModel::setPreferableTarget( int targetId )

AutoIt:
    $oKeypointsModel.setPreferableTarget( $targetId ) -> retval
```

## cv::dnn::SegmentationModel

### cv::dnn::SegmentationModel::create

```cpp
static cv::dnn::SegmentationModel cv::dnn::SegmentationModel::create( const std::string& model,
                                                                      const std::string& config = "" )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.SegmentationModel").create( $model[, $config] ) -> <cv.dnn.SegmentationModel object>
```

```cpp
static cv::dnn::SegmentationModel cv::dnn::SegmentationModel::create( const cv::dnn::Net& network )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.SegmentationModel").create( $network ) -> <cv.dnn.SegmentationModel object>
```

### cv::dnn::SegmentationModel::segment

```cpp
void cv::dnn::SegmentationModel::segment( _InputArray  frame,
                                          _OutputArray mask )

AutoIt:
    $oSegmentationModel.segment( $frame[, $mask] ) -> $mask
```

### cv::dnn::SegmentationModel::setInputSize

```cpp
cv::dnn::Model cv::dnn::SegmentationModel::setInputSize( const cv::Size& size )

AutoIt:
    $oSegmentationModel.setInputSize( $size ) -> retval
```

```cpp
cv::dnn::Model cv::dnn::SegmentationModel::setInputSize( int width,
                                                         int height )

AutoIt:
    $oSegmentationModel.setInputSize( $width, $height ) -> retval
```

### cv::dnn::SegmentationModel::setInputMean

```cpp
cv::dnn::Model cv::dnn::SegmentationModel::setInputMean( const cv::Scalar& mean )

AutoIt:
    $oSegmentationModel.setInputMean( $mean ) -> retval
```

### cv::dnn::SegmentationModel::setInputScale

```cpp
cv::dnn::Model cv::dnn::SegmentationModel::setInputScale( double scale )

AutoIt:
    $oSegmentationModel.setInputScale( $scale ) -> retval
```

### cv::dnn::SegmentationModel::setInputCrop

```cpp
cv::dnn::Model cv::dnn::SegmentationModel::setInputCrop( bool crop )

AutoIt:
    $oSegmentationModel.setInputCrop( $crop ) -> retval
```

### cv::dnn::SegmentationModel::setInputSwapRB

```cpp
cv::dnn::Model cv::dnn::SegmentationModel::setInputSwapRB( bool swapRB )

AutoIt:
    $oSegmentationModel.setInputSwapRB( $swapRB ) -> retval
```

### cv::dnn::SegmentationModel::setInputParams

```cpp
void cv::dnn::SegmentationModel::setInputParams( double            scale = 1.0,
                                                 const cv::Size&   size = Size(),
                                                 const cv::Scalar& mean = Scalar(),
                                                 bool              swapRB = false,
                                                 bool              crop = false )

AutoIt:
    $oSegmentationModel.setInputParams( [$scale[, $size[, $mean[, $swapRB[, $crop]]]]] ) -> None
```

### cv::dnn::SegmentationModel::predict

```cpp
void cv::dnn::SegmentationModel::predict( _InputArray  frame,
                                          _OutputArray outs )

AutoIt:
    $oSegmentationModel.predict( $frame[, $outs] ) -> $outs
```

### cv::dnn::SegmentationModel::setPreferableBackend

```cpp
cv::dnn::Model cv::dnn::SegmentationModel::setPreferableBackend( int backendId )

AutoIt:
    $oSegmentationModel.setPreferableBackend( $backendId ) -> retval
```

### cv::dnn::SegmentationModel::setPreferableTarget

```cpp
cv::dnn::Model cv::dnn::SegmentationModel::setPreferableTarget( int targetId )

AutoIt:
    $oSegmentationModel.setPreferableTarget( $targetId ) -> retval
```

## cv::dnn::DetectionModel

### cv::dnn::DetectionModel::create

```cpp
static cv::dnn::DetectionModel cv::dnn::DetectionModel::create( const std::string& model,
                                                                const std::string& config = "" )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.DetectionModel").create( $model[, $config] ) -> <cv.dnn.DetectionModel object>
```

```cpp
static cv::dnn::DetectionModel cv::dnn::DetectionModel::create( const cv::dnn::Net& network )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.DetectionModel").create( $network ) -> <cv.dnn.DetectionModel object>
```

### cv::dnn::DetectionModel::setNmsAcrossClasses

```cpp
cv::dnn::DetectionModel cv::dnn::DetectionModel::setNmsAcrossClasses( bool value )

AutoIt:
    $oDetectionModel.setNmsAcrossClasses( $value ) -> retval
```

### cv::dnn::DetectionModel::getNmsAcrossClasses

```cpp
bool cv::dnn::DetectionModel::getNmsAcrossClasses()

AutoIt:
    $oDetectionModel.getNmsAcrossClasses() -> retval
```

### cv::dnn::DetectionModel::detect

```cpp
void cv::dnn::DetectionModel::detect( _InputArray            frame,
                                      std::vector<int>&      classIds,
                                      std::vector<float>&    confidences,
                                      std::vector<cv::Rect>& boxes,
                                      float                  confThreshold = 0.5f,
                                      float                  nmsThreshold = 0.0f )

AutoIt:
    $oDetectionModel.detect( $frame[, $confThreshold[, $nmsThreshold[, $classIds[, $confidences[, $boxes]]]]] ) -> $classIds, $confidences, $boxes
```

### cv::dnn::DetectionModel::setInputSize

```cpp
cv::dnn::Model cv::dnn::DetectionModel::setInputSize( const cv::Size& size )

AutoIt:
    $oDetectionModel.setInputSize( $size ) -> retval
```

```cpp
cv::dnn::Model cv::dnn::DetectionModel::setInputSize( int width,
                                                      int height )

AutoIt:
    $oDetectionModel.setInputSize( $width, $height ) -> retval
```

### cv::dnn::DetectionModel::setInputMean

```cpp
cv::dnn::Model cv::dnn::DetectionModel::setInputMean( const cv::Scalar& mean )

AutoIt:
    $oDetectionModel.setInputMean( $mean ) -> retval
```

### cv::dnn::DetectionModel::setInputScale

```cpp
cv::dnn::Model cv::dnn::DetectionModel::setInputScale( double scale )

AutoIt:
    $oDetectionModel.setInputScale( $scale ) -> retval
```

### cv::dnn::DetectionModel::setInputCrop

```cpp
cv::dnn::Model cv::dnn::DetectionModel::setInputCrop( bool crop )

AutoIt:
    $oDetectionModel.setInputCrop( $crop ) -> retval
```

### cv::dnn::DetectionModel::setInputSwapRB

```cpp
cv::dnn::Model cv::dnn::DetectionModel::setInputSwapRB( bool swapRB )

AutoIt:
    $oDetectionModel.setInputSwapRB( $swapRB ) -> retval
```

### cv::dnn::DetectionModel::setInputParams

```cpp
void cv::dnn::DetectionModel::setInputParams( double            scale = 1.0,
                                              const cv::Size&   size = Size(),
                                              const cv::Scalar& mean = Scalar(),
                                              bool              swapRB = false,
                                              bool              crop = false )

AutoIt:
    $oDetectionModel.setInputParams( [$scale[, $size[, $mean[, $swapRB[, $crop]]]]] ) -> None
```

### cv::dnn::DetectionModel::predict

```cpp
void cv::dnn::DetectionModel::predict( _InputArray  frame,
                                       _OutputArray outs )

AutoIt:
    $oDetectionModel.predict( $frame[, $outs] ) -> $outs
```

### cv::dnn::DetectionModel::setPreferableBackend

```cpp
cv::dnn::Model cv::dnn::DetectionModel::setPreferableBackend( int backendId )

AutoIt:
    $oDetectionModel.setPreferableBackend( $backendId ) -> retval
```

### cv::dnn::DetectionModel::setPreferableTarget

```cpp
cv::dnn::Model cv::dnn::DetectionModel::setPreferableTarget( int targetId )

AutoIt:
    $oDetectionModel.setPreferableTarget( $targetId ) -> retval
```

## cv::dnn::TextRecognitionModel

### cv::dnn::TextRecognitionModel::create

```cpp
static cv::dnn::TextRecognitionModel cv::dnn::TextRecognitionModel::create( const cv::dnn::Net& network )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.TextRecognitionModel").create( $network ) -> <cv.dnn.TextRecognitionModel object>
```

```cpp
static cv::dnn::TextRecognitionModel cv::dnn::TextRecognitionModel::create( const std::string& model,
                                                                            const std::string& config = "" )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.TextRecognitionModel").create( $model[, $config] ) -> <cv.dnn.TextRecognitionModel object>
```

### cv::dnn::TextRecognitionModel::setDecodeType

```cpp
cv::dnn::TextRecognitionModel cv::dnn::TextRecognitionModel::setDecodeType( const std::string& decodeType )

AutoIt:
    $oTextRecognitionModel.setDecodeType( $decodeType ) -> retval
```

### cv::dnn::TextRecognitionModel::getDecodeType

```cpp
std::string cv::dnn::TextRecognitionModel::getDecodeType()

AutoIt:
    $oTextRecognitionModel.getDecodeType() -> retval
```

### cv::dnn::TextRecognitionModel::setDecodeOptsCTCPrefixBeamSearch

```cpp
cv::dnn::TextRecognitionModel cv::dnn::TextRecognitionModel::setDecodeOptsCTCPrefixBeamSearch( int beamSize,
                                                                                               int vocPruneSize = 0 )

AutoIt:
    $oTextRecognitionModel.setDecodeOptsCTCPrefixBeamSearch( $beamSize[, $vocPruneSize] ) -> retval
```

### cv::dnn::TextRecognitionModel::setVocabulary

```cpp
cv::dnn::TextRecognitionModel cv::dnn::TextRecognitionModel::setVocabulary( const std::vector<std::string>& vocabulary )

AutoIt:
    $oTextRecognitionModel.setVocabulary( $vocabulary ) -> retval
```

### cv::dnn::TextRecognitionModel::getVocabulary

```cpp
std::vector<std::string> cv::dnn::TextRecognitionModel::getVocabulary()

AutoIt:
    $oTextRecognitionModel.getVocabulary() -> retval
```

### cv::dnn::TextRecognitionModel::recognize

```cpp
std::string cv::dnn::TextRecognitionModel::recognize( _InputArray frame )

AutoIt:
    $oTextRecognitionModel.recognize( $frame ) -> retval
```

```cpp
void cv::dnn::TextRecognitionModel::recognize( _InputArray               frame,
                                               _InputArray               roiRects,
                                               std::vector<std::string>& results )

AutoIt:
    $oTextRecognitionModel.recognize( $frame, $roiRects[, $results] ) -> $results
```

### cv::dnn::TextRecognitionModel::setInputSize

```cpp
cv::dnn::Model cv::dnn::TextRecognitionModel::setInputSize( const cv::Size& size )

AutoIt:
    $oTextRecognitionModel.setInputSize( $size ) -> retval
```

```cpp
cv::dnn::Model cv::dnn::TextRecognitionModel::setInputSize( int width,
                                                            int height )

AutoIt:
    $oTextRecognitionModel.setInputSize( $width, $height ) -> retval
```

### cv::dnn::TextRecognitionModel::setInputMean

```cpp
cv::dnn::Model cv::dnn::TextRecognitionModel::setInputMean( const cv::Scalar& mean )

AutoIt:
    $oTextRecognitionModel.setInputMean( $mean ) -> retval
```

### cv::dnn::TextRecognitionModel::setInputScale

```cpp
cv::dnn::Model cv::dnn::TextRecognitionModel::setInputScale( double scale )

AutoIt:
    $oTextRecognitionModel.setInputScale( $scale ) -> retval
```

### cv::dnn::TextRecognitionModel::setInputCrop

```cpp
cv::dnn::Model cv::dnn::TextRecognitionModel::setInputCrop( bool crop )

AutoIt:
    $oTextRecognitionModel.setInputCrop( $crop ) -> retval
```

### cv::dnn::TextRecognitionModel::setInputSwapRB

```cpp
cv::dnn::Model cv::dnn::TextRecognitionModel::setInputSwapRB( bool swapRB )

AutoIt:
    $oTextRecognitionModel.setInputSwapRB( $swapRB ) -> retval
```

### cv::dnn::TextRecognitionModel::setInputParams

```cpp
void cv::dnn::TextRecognitionModel::setInputParams( double            scale = 1.0,
                                                    const cv::Size&   size = Size(),
                                                    const cv::Scalar& mean = Scalar(),
                                                    bool              swapRB = false,
                                                    bool              crop = false )

AutoIt:
    $oTextRecognitionModel.setInputParams( [$scale[, $size[, $mean[, $swapRB[, $crop]]]]] ) -> None
```

### cv::dnn::TextRecognitionModel::predict

```cpp
void cv::dnn::TextRecognitionModel::predict( _InputArray  frame,
                                             _OutputArray outs )

AutoIt:
    $oTextRecognitionModel.predict( $frame[, $outs] ) -> $outs
```

### cv::dnn::TextRecognitionModel::setPreferableBackend

```cpp
cv::dnn::Model cv::dnn::TextRecognitionModel::setPreferableBackend( int backendId )

AutoIt:
    $oTextRecognitionModel.setPreferableBackend( $backendId ) -> retval
```

### cv::dnn::TextRecognitionModel::setPreferableTarget

```cpp
cv::dnn::Model cv::dnn::TextRecognitionModel::setPreferableTarget( int targetId )

AutoIt:
    $oTextRecognitionModel.setPreferableTarget( $targetId ) -> retval
```

## cv::dnn::TextDetectionModel

### cv::dnn::TextDetectionModel::detect

```cpp
void cv::dnn::TextDetectionModel::detect( _InputArray                          frame,
                                          std::vector<std::vector<cv::Point>>& detections,
                                          std::vector<float>&                  confidences )

AutoIt:
    $oTextDetectionModel.detect( $frame[, $detections[, $confidences]] ) -> $detections, $confidences
```

```cpp
void cv::dnn::TextDetectionModel::detect( _InputArray                          frame,
                                          std::vector<std::vector<cv::Point>>& detections )

AutoIt:
    $oTextDetectionModel.detect( $frame[, $detections] ) -> $detections
```

### cv::dnn::TextDetectionModel::detectTextRectangles

```cpp
void cv::dnn::TextDetectionModel::detectTextRectangles( _InputArray                   frame,
                                                        std::vector<cv::RotatedRect>& detections,
                                                        std::vector<float>&           confidences )

AutoIt:
    $oTextDetectionModel.detectTextRectangles( $frame[, $detections[, $confidences]] ) -> $detections, $confidences
```

```cpp
void cv::dnn::TextDetectionModel::detectTextRectangles( _InputArray                   frame,
                                                        std::vector<cv::RotatedRect>& detections )

AutoIt:
    $oTextDetectionModel.detectTextRectangles( $frame[, $detections] ) -> $detections
```

### cv::dnn::TextDetectionModel::setInputSize

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel::setInputSize( const cv::Size& size )

AutoIt:
    $oTextDetectionModel.setInputSize( $size ) -> retval
```

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel::setInputSize( int width,
                                                          int height )

AutoIt:
    $oTextDetectionModel.setInputSize( $width, $height ) -> retval
```

### cv::dnn::TextDetectionModel::setInputMean

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel::setInputMean( const cv::Scalar& mean )

AutoIt:
    $oTextDetectionModel.setInputMean( $mean ) -> retval
```

### cv::dnn::TextDetectionModel::setInputScale

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel::setInputScale( double scale )

AutoIt:
    $oTextDetectionModel.setInputScale( $scale ) -> retval
```

### cv::dnn::TextDetectionModel::setInputCrop

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel::setInputCrop( bool crop )

AutoIt:
    $oTextDetectionModel.setInputCrop( $crop ) -> retval
```

### cv::dnn::TextDetectionModel::setInputSwapRB

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel::setInputSwapRB( bool swapRB )

AutoIt:
    $oTextDetectionModel.setInputSwapRB( $swapRB ) -> retval
```

### cv::dnn::TextDetectionModel::setInputParams

```cpp
void cv::dnn::TextDetectionModel::setInputParams( double            scale = 1.0,
                                                  const cv::Size&   size = Size(),
                                                  const cv::Scalar& mean = Scalar(),
                                                  bool              swapRB = false,
                                                  bool              crop = false )

AutoIt:
    $oTextDetectionModel.setInputParams( [$scale[, $size[, $mean[, $swapRB[, $crop]]]]] ) -> None
```

### cv::dnn::TextDetectionModel::predict

```cpp
void cv::dnn::TextDetectionModel::predict( _InputArray  frame,
                                           _OutputArray outs )

AutoIt:
    $oTextDetectionModel.predict( $frame[, $outs] ) -> $outs
```

### cv::dnn::TextDetectionModel::setPreferableBackend

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel::setPreferableBackend( int backendId )

AutoIt:
    $oTextDetectionModel.setPreferableBackend( $backendId ) -> retval
```

### cv::dnn::TextDetectionModel::setPreferableTarget

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel::setPreferableTarget( int targetId )

AutoIt:
    $oTextDetectionModel.setPreferableTarget( $targetId ) -> retval
```

## cv::dnn::TextDetectionModel_EAST

### cv::dnn::TextDetectionModel_EAST::create

```cpp
static cv::dnn::TextDetectionModel_EAST cv::dnn::TextDetectionModel_EAST::create( const cv::dnn::Net& network )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.TextDetectionModel_EAST").create( $network ) -> <cv.dnn.TextDetectionModel_EAST object>
```

```cpp
static cv::dnn::TextDetectionModel_EAST cv::dnn::TextDetectionModel_EAST::create( const std::string& model,
                                                                                  const std::string& config = "" )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.TextDetectionModel_EAST").create( $model[, $config] ) -> <cv.dnn.TextDetectionModel_EAST object>
```

### cv::dnn::TextDetectionModel_EAST::setConfidenceThreshold

```cpp
cv::dnn::TextDetectionModel_EAST cv::dnn::TextDetectionModel_EAST::setConfidenceThreshold( float confThreshold )

AutoIt:
    $oTextDetectionModel_EAST.setConfidenceThreshold( $confThreshold ) -> retval
```

### cv::dnn::TextDetectionModel_EAST::getConfidenceThreshold

```cpp
float cv::dnn::TextDetectionModel_EAST::getConfidenceThreshold()

AutoIt:
    $oTextDetectionModel_EAST.getConfidenceThreshold() -> retval
```

### cv::dnn::TextDetectionModel_EAST::setNMSThreshold

```cpp
cv::dnn::TextDetectionModel_EAST cv::dnn::TextDetectionModel_EAST::setNMSThreshold( float nmsThreshold )

AutoIt:
    $oTextDetectionModel_EAST.setNMSThreshold( $nmsThreshold ) -> retval
```

### cv::dnn::TextDetectionModel_EAST::getNMSThreshold

```cpp
float cv::dnn::TextDetectionModel_EAST::getNMSThreshold()

AutoIt:
    $oTextDetectionModel_EAST.getNMSThreshold() -> retval
```

### cv::dnn::TextDetectionModel_EAST::detect

```cpp
void cv::dnn::TextDetectionModel_EAST::detect( _InputArray                          frame,
                                               std::vector<std::vector<cv::Point>>& detections,
                                               std::vector<float>&                  confidences )

AutoIt:
    $oTextDetectionModel_EAST.detect( $frame[, $detections[, $confidences]] ) -> $detections, $confidences
```

```cpp
void cv::dnn::TextDetectionModel_EAST::detect( _InputArray                          frame,
                                               std::vector<std::vector<cv::Point>>& detections )

AutoIt:
    $oTextDetectionModel_EAST.detect( $frame[, $detections] ) -> $detections
```

### cv::dnn::TextDetectionModel_EAST::detectTextRectangles

```cpp
void cv::dnn::TextDetectionModel_EAST::detectTextRectangles( _InputArray                   frame,
                                                             std::vector<cv::RotatedRect>& detections,
                                                             std::vector<float>&           confidences )

AutoIt:
    $oTextDetectionModel_EAST.detectTextRectangles( $frame[, $detections[, $confidences]] ) -> $detections, $confidences
```

```cpp
void cv::dnn::TextDetectionModel_EAST::detectTextRectangles( _InputArray                   frame,
                                                             std::vector<cv::RotatedRect>& detections )

AutoIt:
    $oTextDetectionModel_EAST.detectTextRectangles( $frame[, $detections] ) -> $detections
```

### cv::dnn::TextDetectionModel_EAST::setInputSize

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_EAST::setInputSize( const cv::Size& size )

AutoIt:
    $oTextDetectionModel_EAST.setInputSize( $size ) -> retval
```

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_EAST::setInputSize( int width,
                                                               int height )

AutoIt:
    $oTextDetectionModel_EAST.setInputSize( $width, $height ) -> retval
```

### cv::dnn::TextDetectionModel_EAST::setInputMean

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_EAST::setInputMean( const cv::Scalar& mean )

AutoIt:
    $oTextDetectionModel_EAST.setInputMean( $mean ) -> retval
```

### cv::dnn::TextDetectionModel_EAST::setInputScale

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_EAST::setInputScale( double scale )

AutoIt:
    $oTextDetectionModel_EAST.setInputScale( $scale ) -> retval
```

### cv::dnn::TextDetectionModel_EAST::setInputCrop

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_EAST::setInputCrop( bool crop )

AutoIt:
    $oTextDetectionModel_EAST.setInputCrop( $crop ) -> retval
```

### cv::dnn::TextDetectionModel_EAST::setInputSwapRB

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_EAST::setInputSwapRB( bool swapRB )

AutoIt:
    $oTextDetectionModel_EAST.setInputSwapRB( $swapRB ) -> retval
```

### cv::dnn::TextDetectionModel_EAST::setInputParams

```cpp
void cv::dnn::TextDetectionModel_EAST::setInputParams( double            scale = 1.0,
                                                       const cv::Size&   size = Size(),
                                                       const cv::Scalar& mean = Scalar(),
                                                       bool              swapRB = false,
                                                       bool              crop = false )

AutoIt:
    $oTextDetectionModel_EAST.setInputParams( [$scale[, $size[, $mean[, $swapRB[, $crop]]]]] ) -> None
```

### cv::dnn::TextDetectionModel_EAST::predict

```cpp
void cv::dnn::TextDetectionModel_EAST::predict( _InputArray  frame,
                                                _OutputArray outs )

AutoIt:
    $oTextDetectionModel_EAST.predict( $frame[, $outs] ) -> $outs
```

### cv::dnn::TextDetectionModel_EAST::setPreferableBackend

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_EAST::setPreferableBackend( int backendId )

AutoIt:
    $oTextDetectionModel_EAST.setPreferableBackend( $backendId ) -> retval
```

### cv::dnn::TextDetectionModel_EAST::setPreferableTarget

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_EAST::setPreferableTarget( int targetId )

AutoIt:
    $oTextDetectionModel_EAST.setPreferableTarget( $targetId ) -> retval
```

## cv::dnn::TextDetectionModel_DB

### cv::dnn::TextDetectionModel_DB::create

```cpp
static cv::dnn::TextDetectionModel_DB cv::dnn::TextDetectionModel_DB::create( const cv::dnn::Net& network )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.TextDetectionModel_DB").create( $network ) -> <cv.dnn.TextDetectionModel_DB object>
```

```cpp
static cv::dnn::TextDetectionModel_DB cv::dnn::TextDetectionModel_DB::create( const std::string& model,
                                                                              const std::string& config = "" )

AutoIt:
    _OpenCV_ObjCreate("cv.dnn.TextDetectionModel_DB").create( $model[, $config] ) -> <cv.dnn.TextDetectionModel_DB object>
```

### cv::dnn::TextDetectionModel_DB::setBinaryThreshold

```cpp
cv::dnn::TextDetectionModel_DB cv::dnn::TextDetectionModel_DB::setBinaryThreshold( float binaryThreshold )

AutoIt:
    $oTextDetectionModel_DB.setBinaryThreshold( $binaryThreshold ) -> retval
```

### cv::dnn::TextDetectionModel_DB::getBinaryThreshold

```cpp
float cv::dnn::TextDetectionModel_DB::getBinaryThreshold()

AutoIt:
    $oTextDetectionModel_DB.getBinaryThreshold() -> retval
```

### cv::dnn::TextDetectionModel_DB::setPolygonThreshold

```cpp
cv::dnn::TextDetectionModel_DB cv::dnn::TextDetectionModel_DB::setPolygonThreshold( float polygonThreshold )

AutoIt:
    $oTextDetectionModel_DB.setPolygonThreshold( $polygonThreshold ) -> retval
```

### cv::dnn::TextDetectionModel_DB::getPolygonThreshold

```cpp
float cv::dnn::TextDetectionModel_DB::getPolygonThreshold()

AutoIt:
    $oTextDetectionModel_DB.getPolygonThreshold() -> retval
```

### cv::dnn::TextDetectionModel_DB::setUnclipRatio

```cpp
cv::dnn::TextDetectionModel_DB cv::dnn::TextDetectionModel_DB::setUnclipRatio( double unclipRatio )

AutoIt:
    $oTextDetectionModel_DB.setUnclipRatio( $unclipRatio ) -> retval
```

### cv::dnn::TextDetectionModel_DB::getUnclipRatio

```cpp
double cv::dnn::TextDetectionModel_DB::getUnclipRatio()

AutoIt:
    $oTextDetectionModel_DB.getUnclipRatio() -> retval
```

### cv::dnn::TextDetectionModel_DB::setMaxCandidates

```cpp
cv::dnn::TextDetectionModel_DB cv::dnn::TextDetectionModel_DB::setMaxCandidates( int maxCandidates )

AutoIt:
    $oTextDetectionModel_DB.setMaxCandidates( $maxCandidates ) -> retval
```

### cv::dnn::TextDetectionModel_DB::getMaxCandidates

```cpp
int cv::dnn::TextDetectionModel_DB::getMaxCandidates()

AutoIt:
    $oTextDetectionModel_DB.getMaxCandidates() -> retval
```

### cv::dnn::TextDetectionModel_DB::detect

```cpp
void cv::dnn::TextDetectionModel_DB::detect( _InputArray                          frame,
                                             std::vector<std::vector<cv::Point>>& detections,
                                             std::vector<float>&                  confidences )

AutoIt:
    $oTextDetectionModel_DB.detect( $frame[, $detections[, $confidences]] ) -> $detections, $confidences
```

```cpp
void cv::dnn::TextDetectionModel_DB::detect( _InputArray                          frame,
                                             std::vector<std::vector<cv::Point>>& detections )

AutoIt:
    $oTextDetectionModel_DB.detect( $frame[, $detections] ) -> $detections
```

### cv::dnn::TextDetectionModel_DB::detectTextRectangles

```cpp
void cv::dnn::TextDetectionModel_DB::detectTextRectangles( _InputArray                   frame,
                                                           std::vector<cv::RotatedRect>& detections,
                                                           std::vector<float>&           confidences )

AutoIt:
    $oTextDetectionModel_DB.detectTextRectangles( $frame[, $detections[, $confidences]] ) -> $detections, $confidences
```

```cpp
void cv::dnn::TextDetectionModel_DB::detectTextRectangles( _InputArray                   frame,
                                                           std::vector<cv::RotatedRect>& detections )

AutoIt:
    $oTextDetectionModel_DB.detectTextRectangles( $frame[, $detections] ) -> $detections
```

### cv::dnn::TextDetectionModel_DB::setInputSize

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_DB::setInputSize( const cv::Size& size )

AutoIt:
    $oTextDetectionModel_DB.setInputSize( $size ) -> retval
```

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_DB::setInputSize( int width,
                                                             int height )

AutoIt:
    $oTextDetectionModel_DB.setInputSize( $width, $height ) -> retval
```

### cv::dnn::TextDetectionModel_DB::setInputMean

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_DB::setInputMean( const cv::Scalar& mean )

AutoIt:
    $oTextDetectionModel_DB.setInputMean( $mean ) -> retval
```

### cv::dnn::TextDetectionModel_DB::setInputScale

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_DB::setInputScale( double scale )

AutoIt:
    $oTextDetectionModel_DB.setInputScale( $scale ) -> retval
```

### cv::dnn::TextDetectionModel_DB::setInputCrop

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_DB::setInputCrop( bool crop )

AutoIt:
    $oTextDetectionModel_DB.setInputCrop( $crop ) -> retval
```

### cv::dnn::TextDetectionModel_DB::setInputSwapRB

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_DB::setInputSwapRB( bool swapRB )

AutoIt:
    $oTextDetectionModel_DB.setInputSwapRB( $swapRB ) -> retval
```

### cv::dnn::TextDetectionModel_DB::setInputParams

```cpp
void cv::dnn::TextDetectionModel_DB::setInputParams( double            scale = 1.0,
                                                     const cv::Size&   size = Size(),
                                                     const cv::Scalar& mean = Scalar(),
                                                     bool              swapRB = false,
                                                     bool              crop = false )

AutoIt:
    $oTextDetectionModel_DB.setInputParams( [$scale[, $size[, $mean[, $swapRB[, $crop]]]]] ) -> None
```

### cv::dnn::TextDetectionModel_DB::predict

```cpp
void cv::dnn::TextDetectionModel_DB::predict( _InputArray  frame,
                                              _OutputArray outs )

AutoIt:
    $oTextDetectionModel_DB.predict( $frame[, $outs] ) -> $outs
```

### cv::dnn::TextDetectionModel_DB::setPreferableBackend

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_DB::setPreferableBackend( int backendId )

AutoIt:
    $oTextDetectionModel_DB.setPreferableBackend( $backendId ) -> retval
```

### cv::dnn::TextDetectionModel_DB::setPreferableTarget

```cpp
cv::dnn::Model cv::dnn::TextDetectionModel_DB::setPreferableTarget( int targetId )

AutoIt:
    $oTextDetectionModel_DB.setPreferableTarget( $targetId ) -> retval
```

## cv::Feature2D

### cv::Feature2D::detect

```cpp
void cv::Feature2D::detect( _InputArray                image,
                            std::vector<cv::KeyPoint>& keypoints,
                            _InputArray                mask = noArray() )

AutoIt:
    $oFeature2D.detect( $image[, $mask[, $keypoints]] ) -> $keypoints
```

```cpp
void cv::Feature2D::detect( _InputArray                             images,
                            std::vector<std::vector<cv::KeyPoint>>& keypoints,
                            _InputArray                             masks = noArray() )

AutoIt:
    $oFeature2D.detect( $images[, $masks[, $keypoints]] ) -> $keypoints
```

### cv::Feature2D::compute

```cpp
void cv::Feature2D::compute( _InputArray                image,
                             std::vector<cv::KeyPoint>& keypoints,
                             _OutputArray               descriptors )

AutoIt:
    $oFeature2D.compute( $image, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

```cpp
void cv::Feature2D::compute( _InputArray                             images,
                             std::vector<std::vector<cv::KeyPoint>>& keypoints,
                             _OutputArray                            descriptors )

AutoIt:
    $oFeature2D.compute( $images, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

### cv::Feature2D::detectAndCompute

```cpp
void cv::Feature2D::detectAndCompute( _InputArray                image,
                                      _InputArray                mask,
                                      std::vector<cv::KeyPoint>& keypoints,
                                      _OutputArray               descriptors,
                                      bool                       useProvidedKeypoints = false )

AutoIt:
    $oFeature2D.detectAndCompute( $image, $mask[, $descriptors[, $useProvidedKeypoints[, $keypoints]]] ) -> $keypoints, $descriptors
```

### cv::Feature2D::descriptorSize

```cpp
int cv::Feature2D::descriptorSize()

AutoIt:
    $oFeature2D.descriptorSize() -> retval
```

### cv::Feature2D::descriptorType

```cpp
int cv::Feature2D::descriptorType()

AutoIt:
    $oFeature2D.descriptorType() -> retval
```

### cv::Feature2D::defaultNorm

```cpp
int cv::Feature2D::defaultNorm()

AutoIt:
    $oFeature2D.defaultNorm() -> retval
```

### cv::Feature2D::write

```cpp
void cv::Feature2D::write( const std::string& fileName )

AutoIt:
    $oFeature2D.write( $fileName ) -> None
```

```cpp
void cv::Feature2D::write( const cv::Ptr<cv::FileStorage>& fs,
                           const std::string&              name = String() )

AutoIt:
    $oFeature2D.write( $fs[, $name] ) -> None
```

### cv::Feature2D::read

```cpp
void cv::Feature2D::read( const std::string& fileName )

AutoIt:
    $oFeature2D.read( $fileName ) -> None
```

```cpp
void cv::Feature2D::read( const cv::FileNode& arg1 )

AutoIt:
    $oFeature2D.read( $arg1 ) -> None
```

### cv::Feature2D::empty

```cpp
bool cv::Feature2D::empty()

AutoIt:
    $oFeature2D.empty() -> retval
```

### cv::Feature2D::getDefaultName

```cpp
std::string cv::Feature2D::getDefaultName()

AutoIt:
    $oFeature2D.getDefaultName() -> retval
```

### cv::Feature2D::clear

```cpp
void cv::Feature2D::clear()

AutoIt:
    $oFeature2D.clear() -> None
```

### cv::Feature2D::save

```cpp
void cv::Feature2D::save( const std::string& filename )

AutoIt:
    $oFeature2D.save( $filename ) -> None
```

## cv::AffineFeature

### cv::AffineFeature::create

```cpp
static cv::Ptr<cv::AffineFeature> cv::AffineFeature::create( const cv::Ptr<cv::Feature2D>& backend,
                                                             int                           maxTilt = 5,
                                                             int                           minTilt = 0,
                                                             float                         tiltStep = 1.4142135623730951f,
                                                             float                         rotateStepBase = 72 )

AutoIt:
    _OpenCV_ObjCreate("cv.AffineFeature").create( $backend[, $maxTilt[, $minTilt[, $tiltStep[, $rotateStepBase]]]] ) -> retval
```

### cv::AffineFeature::setViewParams

```cpp
void cv::AffineFeature::setViewParams( const std::vector<float>& tilts,
                                       const std::vector<float>& rolls )

AutoIt:
    $oAffineFeature.setViewParams( $tilts, $rolls ) -> None
```

### cv::AffineFeature::getViewParams

```cpp
void cv::AffineFeature::getViewParams( std::vector<float>& tilts,
                                       std::vector<float>& rolls )

AutoIt:
    $oAffineFeature.getViewParams( $tilts, $rolls ) -> None
```

### cv::AffineFeature::getDefaultName

```cpp
std::string cv::AffineFeature::getDefaultName()

AutoIt:
    $oAffineFeature.getDefaultName() -> retval
```

### cv::AffineFeature::detect

```cpp
void cv::AffineFeature::detect( _InputArray                image,
                                std::vector<cv::KeyPoint>& keypoints,
                                _InputArray                mask = noArray() )

AutoIt:
    $oAffineFeature.detect( $image[, $mask[, $keypoints]] ) -> $keypoints
```

```cpp
void cv::AffineFeature::detect( _InputArray                             images,
                                std::vector<std::vector<cv::KeyPoint>>& keypoints,
                                _InputArray                             masks = noArray() )

AutoIt:
    $oAffineFeature.detect( $images[, $masks[, $keypoints]] ) -> $keypoints
```

### cv::AffineFeature::compute

```cpp
void cv::AffineFeature::compute( _InputArray                image,
                                 std::vector<cv::KeyPoint>& keypoints,
                                 _OutputArray               descriptors )

AutoIt:
    $oAffineFeature.compute( $image, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

```cpp
void cv::AffineFeature::compute( _InputArray                             images,
                                 std::vector<std::vector<cv::KeyPoint>>& keypoints,
                                 _OutputArray                            descriptors )

AutoIt:
    $oAffineFeature.compute( $images, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

### cv::AffineFeature::detectAndCompute

```cpp
void cv::AffineFeature::detectAndCompute( _InputArray                image,
                                          _InputArray                mask,
                                          std::vector<cv::KeyPoint>& keypoints,
                                          _OutputArray               descriptors,
                                          bool                       useProvidedKeypoints = false )

AutoIt:
    $oAffineFeature.detectAndCompute( $image, $mask[, $descriptors[, $useProvidedKeypoints[, $keypoints]]] ) -> $keypoints, $descriptors
```

### cv::AffineFeature::descriptorSize

```cpp
int cv::AffineFeature::descriptorSize()

AutoIt:
    $oAffineFeature.descriptorSize() -> retval
```

### cv::AffineFeature::descriptorType

```cpp
int cv::AffineFeature::descriptorType()

AutoIt:
    $oAffineFeature.descriptorType() -> retval
```

### cv::AffineFeature::defaultNorm

```cpp
int cv::AffineFeature::defaultNorm()

AutoIt:
    $oAffineFeature.defaultNorm() -> retval
```

### cv::AffineFeature::write

```cpp
void cv::AffineFeature::write( const std::string& fileName )

AutoIt:
    $oAffineFeature.write( $fileName ) -> None
```

```cpp
void cv::AffineFeature::write( const cv::Ptr<cv::FileStorage>& fs,
                               const std::string&              name = String() )

AutoIt:
    $oAffineFeature.write( $fs[, $name] ) -> None
```

### cv::AffineFeature::read

```cpp
void cv::AffineFeature::read( const std::string& fileName )

AutoIt:
    $oAffineFeature.read( $fileName ) -> None
```

```cpp
void cv::AffineFeature::read( const cv::FileNode& arg1 )

AutoIt:
    $oAffineFeature.read( $arg1 ) -> None
```

### cv::AffineFeature::empty

```cpp
bool cv::AffineFeature::empty()

AutoIt:
    $oAffineFeature.empty() -> retval
```

### cv::AffineFeature::clear

```cpp
void cv::AffineFeature::clear()

AutoIt:
    $oAffineFeature.clear() -> None
```

### cv::AffineFeature::save

```cpp
void cv::AffineFeature::save( const std::string& filename )

AutoIt:
    $oAffineFeature.save( $filename ) -> None
```

## cv::SIFT

### cv::SIFT::create

```cpp
static cv::Ptr<cv::SIFT> cv::SIFT::create( int    nfeatures = 0,
                                           int    nOctaveLayers = 3,
                                           double contrastThreshold = 0.04,
                                           double edgeThreshold = 10,
                                           double sigma = 1.6 )

AutoIt:
    _OpenCV_ObjCreate("cv.SIFT").create( [$nfeatures[, $nOctaveLayers[, $contrastThreshold[, $edgeThreshold[, $sigma]]]]] ) -> retval
```

```cpp
static cv::Ptr<cv::SIFT> cv::SIFT::create( int    nfeatures,
                                           int    nOctaveLayers,
                                           double contrastThreshold,
                                           double edgeThreshold,
                                           double sigma,
                                           int    descriptorType )

AutoIt:
    _OpenCV_ObjCreate("cv.SIFT").create( $nfeatures, $nOctaveLayers, $contrastThreshold, $edgeThreshold, $sigma, $descriptorType ) -> retval
```

### cv::SIFT::getDefaultName

```cpp
std::string cv::SIFT::getDefaultName()

AutoIt:
    $oSIFT.getDefaultName() -> retval
```

### cv::SIFT::detect

```cpp
void cv::SIFT::detect( _InputArray                image,
                       std::vector<cv::KeyPoint>& keypoints,
                       _InputArray                mask = noArray() )

AutoIt:
    $oSIFT.detect( $image[, $mask[, $keypoints]] ) -> $keypoints
```

```cpp
void cv::SIFT::detect( _InputArray                             images,
                       std::vector<std::vector<cv::KeyPoint>>& keypoints,
                       _InputArray                             masks = noArray() )

AutoIt:
    $oSIFT.detect( $images[, $masks[, $keypoints]] ) -> $keypoints
```

### cv::SIFT::compute

```cpp
void cv::SIFT::compute( _InputArray                image,
                        std::vector<cv::KeyPoint>& keypoints,
                        _OutputArray               descriptors )

AutoIt:
    $oSIFT.compute( $image, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

```cpp
void cv::SIFT::compute( _InputArray                             images,
                        std::vector<std::vector<cv::KeyPoint>>& keypoints,
                        _OutputArray                            descriptors )

AutoIt:
    $oSIFT.compute( $images, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

### cv::SIFT::detectAndCompute

```cpp
void cv::SIFT::detectAndCompute( _InputArray                image,
                                 _InputArray                mask,
                                 std::vector<cv::KeyPoint>& keypoints,
                                 _OutputArray               descriptors,
                                 bool                       useProvidedKeypoints = false )

AutoIt:
    $oSIFT.detectAndCompute( $image, $mask[, $descriptors[, $useProvidedKeypoints[, $keypoints]]] ) -> $keypoints, $descriptors
```

### cv::SIFT::descriptorSize

```cpp
int cv::SIFT::descriptorSize()

AutoIt:
    $oSIFT.descriptorSize() -> retval
```

### cv::SIFT::descriptorType

```cpp
int cv::SIFT::descriptorType()

AutoIt:
    $oSIFT.descriptorType() -> retval
```

### cv::SIFT::defaultNorm

```cpp
int cv::SIFT::defaultNorm()

AutoIt:
    $oSIFT.defaultNorm() -> retval
```

### cv::SIFT::write

```cpp
void cv::SIFT::write( const std::string& fileName )

AutoIt:
    $oSIFT.write( $fileName ) -> None
```

```cpp
void cv::SIFT::write( const cv::Ptr<cv::FileStorage>& fs,
                      const std::string&              name = String() )

AutoIt:
    $oSIFT.write( $fs[, $name] ) -> None
```

### cv::SIFT::read

```cpp
void cv::SIFT::read( const std::string& fileName )

AutoIt:
    $oSIFT.read( $fileName ) -> None
```

```cpp
void cv::SIFT::read( const cv::FileNode& arg1 )

AutoIt:
    $oSIFT.read( $arg1 ) -> None
```

### cv::SIFT::empty

```cpp
bool cv::SIFT::empty()

AutoIt:
    $oSIFT.empty() -> retval
```

### cv::SIFT::clear

```cpp
void cv::SIFT::clear()

AutoIt:
    $oSIFT.clear() -> None
```

### cv::SIFT::save

```cpp
void cv::SIFT::save( const std::string& filename )

AutoIt:
    $oSIFT.save( $filename ) -> None
```

## cv::BRISK

### cv::BRISK::create

```cpp
static cv::Ptr<cv::BRISK> cv::BRISK::create( int   thresh = 30,
                                             int   octaves = 3,
                                             float patternScale = 1.0f )

AutoIt:
    _OpenCV_ObjCreate("cv.BRISK").create( [$thresh[, $octaves[, $patternScale]]] ) -> retval
```

```cpp
static cv::Ptr<cv::BRISK> cv::BRISK::create( const std::vector<float>& radiusList,
                                             const std::vector<int>&   numberList,
                                             float                     dMax = 5.85f,
                                             float                     dMin = 8.2f,
                                             const std::vector<int>&   indexChange = std::vector<int>() )

AutoIt:
    _OpenCV_ObjCreate("cv.BRISK").create( $radiusList, $numberList[, $dMax[, $dMin[, $indexChange]]] ) -> retval
```

```cpp
static cv::Ptr<cv::BRISK> cv::BRISK::create( int                       thresh,
                                             int                       octaves,
                                             const std::vector<float>& radiusList,
                                             const std::vector<int>&   numberList,
                                             float                     dMax = 5.85f,
                                             float                     dMin = 8.2f,
                                             const std::vector<int>&   indexChange = std::vector<int>() )

AutoIt:
    _OpenCV_ObjCreate("cv.BRISK").create( $thresh, $octaves, $radiusList, $numberList[, $dMax[, $dMin[, $indexChange]]] ) -> retval
```

### cv::BRISK::getDefaultName

```cpp
std::string cv::BRISK::getDefaultName()

AutoIt:
    $oBRISK.getDefaultName() -> retval
```

### cv::BRISK::setThreshold

```cpp
void cv::BRISK::setThreshold( int threshold )

AutoIt:
    $oBRISK.setThreshold( $threshold ) -> None
```

### cv::BRISK::getThreshold

```cpp
int cv::BRISK::getThreshold()

AutoIt:
    $oBRISK.getThreshold() -> retval
```

### cv::BRISK::setOctaves

```cpp
void cv::BRISK::setOctaves( int octaves )

AutoIt:
    $oBRISK.setOctaves( $octaves ) -> None
```

### cv::BRISK::getOctaves

```cpp
int cv::BRISK::getOctaves()

AutoIt:
    $oBRISK.getOctaves() -> retval
```

### cv::BRISK::detect

```cpp
void cv::BRISK::detect( _InputArray                image,
                        std::vector<cv::KeyPoint>& keypoints,
                        _InputArray                mask = noArray() )

AutoIt:
    $oBRISK.detect( $image[, $mask[, $keypoints]] ) -> $keypoints
```

```cpp
void cv::BRISK::detect( _InputArray                             images,
                        std::vector<std::vector<cv::KeyPoint>>& keypoints,
                        _InputArray                             masks = noArray() )

AutoIt:
    $oBRISK.detect( $images[, $masks[, $keypoints]] ) -> $keypoints
```

### cv::BRISK::compute

```cpp
void cv::BRISK::compute( _InputArray                image,
                         std::vector<cv::KeyPoint>& keypoints,
                         _OutputArray               descriptors )

AutoIt:
    $oBRISK.compute( $image, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

```cpp
void cv::BRISK::compute( _InputArray                             images,
                         std::vector<std::vector<cv::KeyPoint>>& keypoints,
                         _OutputArray                            descriptors )

AutoIt:
    $oBRISK.compute( $images, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

### cv::BRISK::detectAndCompute

```cpp
void cv::BRISK::detectAndCompute( _InputArray                image,
                                  _InputArray                mask,
                                  std::vector<cv::KeyPoint>& keypoints,
                                  _OutputArray               descriptors,
                                  bool                       useProvidedKeypoints = false )

AutoIt:
    $oBRISK.detectAndCompute( $image, $mask[, $descriptors[, $useProvidedKeypoints[, $keypoints]]] ) -> $keypoints, $descriptors
```

### cv::BRISK::descriptorSize

```cpp
int cv::BRISK::descriptorSize()

AutoIt:
    $oBRISK.descriptorSize() -> retval
```

### cv::BRISK::descriptorType

```cpp
int cv::BRISK::descriptorType()

AutoIt:
    $oBRISK.descriptorType() -> retval
```

### cv::BRISK::defaultNorm

```cpp
int cv::BRISK::defaultNorm()

AutoIt:
    $oBRISK.defaultNorm() -> retval
```

### cv::BRISK::write

```cpp
void cv::BRISK::write( const std::string& fileName )

AutoIt:
    $oBRISK.write( $fileName ) -> None
```

```cpp
void cv::BRISK::write( const cv::Ptr<cv::FileStorage>& fs,
                       const std::string&              name = String() )

AutoIt:
    $oBRISK.write( $fs[, $name] ) -> None
```

### cv::BRISK::read

```cpp
void cv::BRISK::read( const std::string& fileName )

AutoIt:
    $oBRISK.read( $fileName ) -> None
```

```cpp
void cv::BRISK::read( const cv::FileNode& arg1 )

AutoIt:
    $oBRISK.read( $arg1 ) -> None
```

### cv::BRISK::empty

```cpp
bool cv::BRISK::empty()

AutoIt:
    $oBRISK.empty() -> retval
```

### cv::BRISK::clear

```cpp
void cv::BRISK::clear()

AutoIt:
    $oBRISK.clear() -> None
```

### cv::BRISK::save

```cpp
void cv::BRISK::save( const std::string& filename )

AutoIt:
    $oBRISK.save( $filename ) -> None
```

## cv::ORB

### cv::ORB::create

```cpp
static cv::Ptr<cv::ORB> cv::ORB::create( int   nfeatures = 500,
                                         float scaleFactor = 1.2f,
                                         int   nlevels = 8,
                                         int   edgeThreshold = 31,
                                         int   firstLevel = 0,
                                         int   WTA_K = 2,
                                         int   scoreType = ORB::HARRIS_SCORE,
                                         int   patchSize = 31,
                                         int   fastThreshold = 20 )

AutoIt:
    _OpenCV_ObjCreate("cv.ORB").create( [$nfeatures[, $scaleFactor[, $nlevels[, $edgeThreshold[, $firstLevel[, $WTA_K[, $scoreType[, $patchSize[, $fastThreshold]]]]]]]]] ) -> retval
```

### cv::ORB::setMaxFeatures

```cpp
void cv::ORB::setMaxFeatures( int maxFeatures )

AutoIt:
    $oORB.setMaxFeatures( $maxFeatures ) -> None
```

### cv::ORB::getMaxFeatures

```cpp
int cv::ORB::getMaxFeatures()

AutoIt:
    $oORB.getMaxFeatures() -> retval
```

### cv::ORB::setScaleFactor

```cpp
void cv::ORB::setScaleFactor( double scaleFactor )

AutoIt:
    $oORB.setScaleFactor( $scaleFactor ) -> None
```

### cv::ORB::getScaleFactor

```cpp
double cv::ORB::getScaleFactor()

AutoIt:
    $oORB.getScaleFactor() -> retval
```

### cv::ORB::setNLevels

```cpp
void cv::ORB::setNLevels( int nlevels )

AutoIt:
    $oORB.setNLevels( $nlevels ) -> None
```

### cv::ORB::getNLevels

```cpp
int cv::ORB::getNLevels()

AutoIt:
    $oORB.getNLevels() -> retval
```

### cv::ORB::setEdgeThreshold

```cpp
void cv::ORB::setEdgeThreshold( int edgeThreshold )

AutoIt:
    $oORB.setEdgeThreshold( $edgeThreshold ) -> None
```

### cv::ORB::getEdgeThreshold

```cpp
int cv::ORB::getEdgeThreshold()

AutoIt:
    $oORB.getEdgeThreshold() -> retval
```

### cv::ORB::setFirstLevel

```cpp
void cv::ORB::setFirstLevel( int firstLevel )

AutoIt:
    $oORB.setFirstLevel( $firstLevel ) -> None
```

### cv::ORB::getFirstLevel

```cpp
int cv::ORB::getFirstLevel()

AutoIt:
    $oORB.getFirstLevel() -> retval
```

### cv::ORB::setWTA_K

```cpp
void cv::ORB::setWTA_K( int wta_k )

AutoIt:
    $oORB.setWTA_K( $wta_k ) -> None
```

### cv::ORB::getWTA_K

```cpp
int cv::ORB::getWTA_K()

AutoIt:
    $oORB.getWTA_K() -> retval
```

### cv::ORB::setScoreType

```cpp
void cv::ORB::setScoreType( int scoreType )

AutoIt:
    $oORB.setScoreType( $scoreType ) -> None
```

### cv::ORB::getScoreType

```cpp
int cv::ORB::getScoreType()

AutoIt:
    $oORB.getScoreType() -> retval
```

### cv::ORB::setPatchSize

```cpp
void cv::ORB::setPatchSize( int patchSize )

AutoIt:
    $oORB.setPatchSize( $patchSize ) -> None
```

### cv::ORB::getPatchSize

```cpp
int cv::ORB::getPatchSize()

AutoIt:
    $oORB.getPatchSize() -> retval
```

### cv::ORB::setFastThreshold

```cpp
void cv::ORB::setFastThreshold( int fastThreshold )

AutoIt:
    $oORB.setFastThreshold( $fastThreshold ) -> None
```

### cv::ORB::getFastThreshold

```cpp
int cv::ORB::getFastThreshold()

AutoIt:
    $oORB.getFastThreshold() -> retval
```

### cv::ORB::getDefaultName

```cpp
std::string cv::ORB::getDefaultName()

AutoIt:
    $oORB.getDefaultName() -> retval
```

### cv::ORB::detect

```cpp
void cv::ORB::detect( _InputArray                image,
                      std::vector<cv::KeyPoint>& keypoints,
                      _InputArray                mask = noArray() )

AutoIt:
    $oORB.detect( $image[, $mask[, $keypoints]] ) -> $keypoints
```

```cpp
void cv::ORB::detect( _InputArray                             images,
                      std::vector<std::vector<cv::KeyPoint>>& keypoints,
                      _InputArray                             masks = noArray() )

AutoIt:
    $oORB.detect( $images[, $masks[, $keypoints]] ) -> $keypoints
```

### cv::ORB::compute

```cpp
void cv::ORB::compute( _InputArray                image,
                       std::vector<cv::KeyPoint>& keypoints,
                       _OutputArray               descriptors )

AutoIt:
    $oORB.compute( $image, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

```cpp
void cv::ORB::compute( _InputArray                             images,
                       std::vector<std::vector<cv::KeyPoint>>& keypoints,
                       _OutputArray                            descriptors )

AutoIt:
    $oORB.compute( $images, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

### cv::ORB::detectAndCompute

```cpp
void cv::ORB::detectAndCompute( _InputArray                image,
                                _InputArray                mask,
                                std::vector<cv::KeyPoint>& keypoints,
                                _OutputArray               descriptors,
                                bool                       useProvidedKeypoints = false )

AutoIt:
    $oORB.detectAndCompute( $image, $mask[, $descriptors[, $useProvidedKeypoints[, $keypoints]]] ) -> $keypoints, $descriptors
```

### cv::ORB::descriptorSize

```cpp
int cv::ORB::descriptorSize()

AutoIt:
    $oORB.descriptorSize() -> retval
```

### cv::ORB::descriptorType

```cpp
int cv::ORB::descriptorType()

AutoIt:
    $oORB.descriptorType() -> retval
```

### cv::ORB::defaultNorm

```cpp
int cv::ORB::defaultNorm()

AutoIt:
    $oORB.defaultNorm() -> retval
```

### cv::ORB::write

```cpp
void cv::ORB::write( const std::string& fileName )

AutoIt:
    $oORB.write( $fileName ) -> None
```

```cpp
void cv::ORB::write( const cv::Ptr<cv::FileStorage>& fs,
                     const std::string&              name = String() )

AutoIt:
    $oORB.write( $fs[, $name] ) -> None
```

### cv::ORB::read

```cpp
void cv::ORB::read( const std::string& fileName )

AutoIt:
    $oORB.read( $fileName ) -> None
```

```cpp
void cv::ORB::read( const cv::FileNode& arg1 )

AutoIt:
    $oORB.read( $arg1 ) -> None
```

### cv::ORB::empty

```cpp
bool cv::ORB::empty()

AutoIt:
    $oORB.empty() -> retval
```

### cv::ORB::clear

```cpp
void cv::ORB::clear()

AutoIt:
    $oORB.clear() -> None
```

### cv::ORB::save

```cpp
void cv::ORB::save( const std::string& filename )

AutoIt:
    $oORB.save( $filename ) -> None
```

## cv::MSER

### cv::MSER::create

```cpp
static cv::Ptr<cv::MSER> cv::MSER::create( int    delta = 5,
                                           int    min_area = 60,
                                           int    max_area = 14400,
                                           double max_variation = 0.25,
                                           double min_diversity = .2,
                                           int    max_evolution = 200,
                                           double area_threshold = 1.01,
                                           double min_margin = 0.003,
                                           int    edge_blur_size = 5 )

AutoIt:
    _OpenCV_ObjCreate("cv.MSER").create( [$delta[, $min_area[, $max_area[, $max_variation[, $min_diversity[, $max_evolution[, $area_threshold[, $min_margin[, $edge_blur_size]]]]]]]]] ) -> retval
```

### cv::MSER::detectRegions

```cpp
void cv::MSER::detectRegions( _InputArray                          image,
                              std::vector<std::vector<cv::Point>>& msers,
                              std::vector<cv::Rect>&               bboxes )

AutoIt:
    $oMSER.detectRegions( $image[, $msers[, $bboxes]] ) -> $msers, $bboxes
```

### cv::MSER::setDelta

```cpp
void cv::MSER::setDelta( int delta )

AutoIt:
    $oMSER.setDelta( $delta ) -> None
```

### cv::MSER::getDelta

```cpp
int cv::MSER::getDelta()

AutoIt:
    $oMSER.getDelta() -> retval
```

### cv::MSER::setMinArea

```cpp
void cv::MSER::setMinArea( int minArea )

AutoIt:
    $oMSER.setMinArea( $minArea ) -> None
```

### cv::MSER::getMinArea

```cpp
int cv::MSER::getMinArea()

AutoIt:
    $oMSER.getMinArea() -> retval
```

### cv::MSER::setMaxArea

```cpp
void cv::MSER::setMaxArea( int maxArea )

AutoIt:
    $oMSER.setMaxArea( $maxArea ) -> None
```

### cv::MSER::getMaxArea

```cpp
int cv::MSER::getMaxArea()

AutoIt:
    $oMSER.getMaxArea() -> retval
```

### cv::MSER::setPass2Only

```cpp
void cv::MSER::setPass2Only( bool f )

AutoIt:
    $oMSER.setPass2Only( $f ) -> None
```

### cv::MSER::getPass2Only

```cpp
bool cv::MSER::getPass2Only()

AutoIt:
    $oMSER.getPass2Only() -> retval
```

### cv::MSER::getDefaultName

```cpp
std::string cv::MSER::getDefaultName()

AutoIt:
    $oMSER.getDefaultName() -> retval
```

### cv::MSER::detect

```cpp
void cv::MSER::detect( _InputArray                image,
                       std::vector<cv::KeyPoint>& keypoints,
                       _InputArray                mask = noArray() )

AutoIt:
    $oMSER.detect( $image[, $mask[, $keypoints]] ) -> $keypoints
```

```cpp
void cv::MSER::detect( _InputArray                             images,
                       std::vector<std::vector<cv::KeyPoint>>& keypoints,
                       _InputArray                             masks = noArray() )

AutoIt:
    $oMSER.detect( $images[, $masks[, $keypoints]] ) -> $keypoints
```

### cv::MSER::compute

```cpp
void cv::MSER::compute( _InputArray                image,
                        std::vector<cv::KeyPoint>& keypoints,
                        _OutputArray               descriptors )

AutoIt:
    $oMSER.compute( $image, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

```cpp
void cv::MSER::compute( _InputArray                             images,
                        std::vector<std::vector<cv::KeyPoint>>& keypoints,
                        _OutputArray                            descriptors )

AutoIt:
    $oMSER.compute( $images, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

### cv::MSER::detectAndCompute

```cpp
void cv::MSER::detectAndCompute( _InputArray                image,
                                 _InputArray                mask,
                                 std::vector<cv::KeyPoint>& keypoints,
                                 _OutputArray               descriptors,
                                 bool                       useProvidedKeypoints = false )

AutoIt:
    $oMSER.detectAndCompute( $image, $mask[, $descriptors[, $useProvidedKeypoints[, $keypoints]]] ) -> $keypoints, $descriptors
```

### cv::MSER::descriptorSize

```cpp
int cv::MSER::descriptorSize()

AutoIt:
    $oMSER.descriptorSize() -> retval
```

### cv::MSER::descriptorType

```cpp
int cv::MSER::descriptorType()

AutoIt:
    $oMSER.descriptorType() -> retval
```

### cv::MSER::defaultNorm

```cpp
int cv::MSER::defaultNorm()

AutoIt:
    $oMSER.defaultNorm() -> retval
```

### cv::MSER::write

```cpp
void cv::MSER::write( const std::string& fileName )

AutoIt:
    $oMSER.write( $fileName ) -> None
```

```cpp
void cv::MSER::write( const cv::Ptr<cv::FileStorage>& fs,
                      const std::string&              name = String() )

AutoIt:
    $oMSER.write( $fs[, $name] ) -> None
```

### cv::MSER::read

```cpp
void cv::MSER::read( const std::string& fileName )

AutoIt:
    $oMSER.read( $fileName ) -> None
```

```cpp
void cv::MSER::read( const cv::FileNode& arg1 )

AutoIt:
    $oMSER.read( $arg1 ) -> None
```

### cv::MSER::empty

```cpp
bool cv::MSER::empty()

AutoIt:
    $oMSER.empty() -> retval
```

### cv::MSER::clear

```cpp
void cv::MSER::clear()

AutoIt:
    $oMSER.clear() -> None
```

### cv::MSER::save

```cpp
void cv::MSER::save( const std::string& filename )

AutoIt:
    $oMSER.save( $filename ) -> None
```

## cv::FastFeatureDetector

### cv::FastFeatureDetector::create

```cpp
static cv::Ptr<cv::FastFeatureDetector> cv::FastFeatureDetector::create( int  threshold = 10,
                                                                         bool nonmaxSuppression = true,
                                                                         int  type = FastFeatureDetector::TYPE_9_16 )

AutoIt:
    _OpenCV_ObjCreate("cv.FastFeatureDetector").create( [$threshold[, $nonmaxSuppression[, $type]]] ) -> retval
```

### cv::FastFeatureDetector::setThreshold

```cpp
void cv::FastFeatureDetector::setThreshold( int threshold )

AutoIt:
    $oFastFeatureDetector.setThreshold( $threshold ) -> None
```

### cv::FastFeatureDetector::getThreshold

```cpp
int cv::FastFeatureDetector::getThreshold()

AutoIt:
    $oFastFeatureDetector.getThreshold() -> retval
```

### cv::FastFeatureDetector::setNonmaxSuppression

```cpp
void cv::FastFeatureDetector::setNonmaxSuppression( bool f )

AutoIt:
    $oFastFeatureDetector.setNonmaxSuppression( $f ) -> None
```

### cv::FastFeatureDetector::getNonmaxSuppression

```cpp
bool cv::FastFeatureDetector::getNonmaxSuppression()

AutoIt:
    $oFastFeatureDetector.getNonmaxSuppression() -> retval
```

### cv::FastFeatureDetector::setType

```cpp
void cv::FastFeatureDetector::setType( int type )

AutoIt:
    $oFastFeatureDetector.setType( $type ) -> None
```

### cv::FastFeatureDetector::getType

```cpp
int cv::FastFeatureDetector::getType()

AutoIt:
    $oFastFeatureDetector.getType() -> retval
```

### cv::FastFeatureDetector::getDefaultName

```cpp
std::string cv::FastFeatureDetector::getDefaultName()

AutoIt:
    $oFastFeatureDetector.getDefaultName() -> retval
```

### cv::FastFeatureDetector::detect

```cpp
void cv::FastFeatureDetector::detect( _InputArray                image,
                                      std::vector<cv::KeyPoint>& keypoints,
                                      _InputArray                mask = noArray() )

AutoIt:
    $oFastFeatureDetector.detect( $image[, $mask[, $keypoints]] ) -> $keypoints
```

```cpp
void cv::FastFeatureDetector::detect( _InputArray                             images,
                                      std::vector<std::vector<cv::KeyPoint>>& keypoints,
                                      _InputArray                             masks = noArray() )

AutoIt:
    $oFastFeatureDetector.detect( $images[, $masks[, $keypoints]] ) -> $keypoints
```

### cv::FastFeatureDetector::compute

```cpp
void cv::FastFeatureDetector::compute( _InputArray                image,
                                       std::vector<cv::KeyPoint>& keypoints,
                                       _OutputArray               descriptors )

AutoIt:
    $oFastFeatureDetector.compute( $image, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

```cpp
void cv::FastFeatureDetector::compute( _InputArray                             images,
                                       std::vector<std::vector<cv::KeyPoint>>& keypoints,
                                       _OutputArray                            descriptors )

AutoIt:
    $oFastFeatureDetector.compute( $images, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

### cv::FastFeatureDetector::detectAndCompute

```cpp
void cv::FastFeatureDetector::detectAndCompute( _InputArray                image,
                                                _InputArray                mask,
                                                std::vector<cv::KeyPoint>& keypoints,
                                                _OutputArray               descriptors,
                                                bool                       useProvidedKeypoints = false )

AutoIt:
    $oFastFeatureDetector.detectAndCompute( $image, $mask[, $descriptors[, $useProvidedKeypoints[, $keypoints]]] ) -> $keypoints, $descriptors
```

### cv::FastFeatureDetector::descriptorSize

```cpp
int cv::FastFeatureDetector::descriptorSize()

AutoIt:
    $oFastFeatureDetector.descriptorSize() -> retval
```

### cv::FastFeatureDetector::descriptorType

```cpp
int cv::FastFeatureDetector::descriptorType()

AutoIt:
    $oFastFeatureDetector.descriptorType() -> retval
```

### cv::FastFeatureDetector::defaultNorm

```cpp
int cv::FastFeatureDetector::defaultNorm()

AutoIt:
    $oFastFeatureDetector.defaultNorm() -> retval
```

### cv::FastFeatureDetector::write

```cpp
void cv::FastFeatureDetector::write( const std::string& fileName )

AutoIt:
    $oFastFeatureDetector.write( $fileName ) -> None
```

```cpp
void cv::FastFeatureDetector::write( const cv::Ptr<cv::FileStorage>& fs,
                                     const std::string&              name = String() )

AutoIt:
    $oFastFeatureDetector.write( $fs[, $name] ) -> None
```

### cv::FastFeatureDetector::read

```cpp
void cv::FastFeatureDetector::read( const std::string& fileName )

AutoIt:
    $oFastFeatureDetector.read( $fileName ) -> None
```

```cpp
void cv::FastFeatureDetector::read( const cv::FileNode& arg1 )

AutoIt:
    $oFastFeatureDetector.read( $arg1 ) -> None
```

### cv::FastFeatureDetector::empty

```cpp
bool cv::FastFeatureDetector::empty()

AutoIt:
    $oFastFeatureDetector.empty() -> retval
```

### cv::FastFeatureDetector::clear

```cpp
void cv::FastFeatureDetector::clear()

AutoIt:
    $oFastFeatureDetector.clear() -> None
```

### cv::FastFeatureDetector::save

```cpp
void cv::FastFeatureDetector::save( const std::string& filename )

AutoIt:
    $oFastFeatureDetector.save( $filename ) -> None
```

## cv::AgastFeatureDetector

### cv::AgastFeatureDetector::create

```cpp
static cv::Ptr<cv::AgastFeatureDetector> cv::AgastFeatureDetector::create( int  threshold = 10,
                                                                           bool nonmaxSuppression = true,
                                                                           int  type = AgastFeatureDetector::OAST_9_16 )

AutoIt:
    _OpenCV_ObjCreate("cv.AgastFeatureDetector").create( [$threshold[, $nonmaxSuppression[, $type]]] ) -> retval
```

### cv::AgastFeatureDetector::setThreshold

```cpp
void cv::AgastFeatureDetector::setThreshold( int threshold )

AutoIt:
    $oAgastFeatureDetector.setThreshold( $threshold ) -> None
```

### cv::AgastFeatureDetector::getThreshold

```cpp
int cv::AgastFeatureDetector::getThreshold()

AutoIt:
    $oAgastFeatureDetector.getThreshold() -> retval
```

### cv::AgastFeatureDetector::setNonmaxSuppression

```cpp
void cv::AgastFeatureDetector::setNonmaxSuppression( bool f )

AutoIt:
    $oAgastFeatureDetector.setNonmaxSuppression( $f ) -> None
```

### cv::AgastFeatureDetector::getNonmaxSuppression

```cpp
bool cv::AgastFeatureDetector::getNonmaxSuppression()

AutoIt:
    $oAgastFeatureDetector.getNonmaxSuppression() -> retval
```

### cv::AgastFeatureDetector::setType

```cpp
void cv::AgastFeatureDetector::setType( int type )

AutoIt:
    $oAgastFeatureDetector.setType( $type ) -> None
```

### cv::AgastFeatureDetector::getType

```cpp
int cv::AgastFeatureDetector::getType()

AutoIt:
    $oAgastFeatureDetector.getType() -> retval
```

### cv::AgastFeatureDetector::getDefaultName

```cpp
std::string cv::AgastFeatureDetector::getDefaultName()

AutoIt:
    $oAgastFeatureDetector.getDefaultName() -> retval
```

### cv::AgastFeatureDetector::detect

```cpp
void cv::AgastFeatureDetector::detect( _InputArray                image,
                                       std::vector<cv::KeyPoint>& keypoints,
                                       _InputArray                mask = noArray() )

AutoIt:
    $oAgastFeatureDetector.detect( $image[, $mask[, $keypoints]] ) -> $keypoints
```

```cpp
void cv::AgastFeatureDetector::detect( _InputArray                             images,
                                       std::vector<std::vector<cv::KeyPoint>>& keypoints,
                                       _InputArray                             masks = noArray() )

AutoIt:
    $oAgastFeatureDetector.detect( $images[, $masks[, $keypoints]] ) -> $keypoints
```

### cv::AgastFeatureDetector::compute

```cpp
void cv::AgastFeatureDetector::compute( _InputArray                image,
                                        std::vector<cv::KeyPoint>& keypoints,
                                        _OutputArray               descriptors )

AutoIt:
    $oAgastFeatureDetector.compute( $image, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

```cpp
void cv::AgastFeatureDetector::compute( _InputArray                             images,
                                        std::vector<std::vector<cv::KeyPoint>>& keypoints,
                                        _OutputArray                            descriptors )

AutoIt:
    $oAgastFeatureDetector.compute( $images, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

### cv::AgastFeatureDetector::detectAndCompute

```cpp
void cv::AgastFeatureDetector::detectAndCompute( _InputArray                image,
                                                 _InputArray                mask,
                                                 std::vector<cv::KeyPoint>& keypoints,
                                                 _OutputArray               descriptors,
                                                 bool                       useProvidedKeypoints = false )

AutoIt:
    $oAgastFeatureDetector.detectAndCompute( $image, $mask[, $descriptors[, $useProvidedKeypoints[, $keypoints]]] ) -> $keypoints, $descriptors
```

### cv::AgastFeatureDetector::descriptorSize

```cpp
int cv::AgastFeatureDetector::descriptorSize()

AutoIt:
    $oAgastFeatureDetector.descriptorSize() -> retval
```

### cv::AgastFeatureDetector::descriptorType

```cpp
int cv::AgastFeatureDetector::descriptorType()

AutoIt:
    $oAgastFeatureDetector.descriptorType() -> retval
```

### cv::AgastFeatureDetector::defaultNorm

```cpp
int cv::AgastFeatureDetector::defaultNorm()

AutoIt:
    $oAgastFeatureDetector.defaultNorm() -> retval
```

### cv::AgastFeatureDetector::write

```cpp
void cv::AgastFeatureDetector::write( const std::string& fileName )

AutoIt:
    $oAgastFeatureDetector.write( $fileName ) -> None
```

```cpp
void cv::AgastFeatureDetector::write( const cv::Ptr<cv::FileStorage>& fs,
                                      const std::string&              name = String() )

AutoIt:
    $oAgastFeatureDetector.write( $fs[, $name] ) -> None
```

### cv::AgastFeatureDetector::read

```cpp
void cv::AgastFeatureDetector::read( const std::string& fileName )

AutoIt:
    $oAgastFeatureDetector.read( $fileName ) -> None
```

```cpp
void cv::AgastFeatureDetector::read( const cv::FileNode& arg1 )

AutoIt:
    $oAgastFeatureDetector.read( $arg1 ) -> None
```

### cv::AgastFeatureDetector::empty

```cpp
bool cv::AgastFeatureDetector::empty()

AutoIt:
    $oAgastFeatureDetector.empty() -> retval
```

### cv::AgastFeatureDetector::clear

```cpp
void cv::AgastFeatureDetector::clear()

AutoIt:
    $oAgastFeatureDetector.clear() -> None
```

### cv::AgastFeatureDetector::save

```cpp
void cv::AgastFeatureDetector::save( const std::string& filename )

AutoIt:
    $oAgastFeatureDetector.save( $filename ) -> None
```

## cv::GFTTDetector

### cv::GFTTDetector::create

```cpp
static cv::Ptr<cv::GFTTDetector> cv::GFTTDetector::create( int    maxCorners = 1000,
                                                           double qualityLevel = 0.01,
                                                           double minDistance = 1,
                                                           int    blockSize = 3,
                                                           bool   useHarrisDetector = false,
                                                           double k = 0.04 )

AutoIt:
    _OpenCV_ObjCreate("cv.GFTTDetector").create( [$maxCorners[, $qualityLevel[, $minDistance[, $blockSize[, $useHarrisDetector[, $k]]]]]] ) -> retval
```

```cpp
static cv::Ptr<cv::GFTTDetector> cv::GFTTDetector::create( int    maxCorners,
                                                           double qualityLevel,
                                                           double minDistance,
                                                           int    blockSize,
                                                           int    gradiantSize,
                                                           bool   useHarrisDetector = false,
                                                           double k = 0.04 )

AutoIt:
    _OpenCV_ObjCreate("cv.GFTTDetector").create( $maxCorners, $qualityLevel, $minDistance, $blockSize, $gradiantSize[, $useHarrisDetector[, $k]] ) -> retval
```

### cv::GFTTDetector::setMaxFeatures

```cpp
void cv::GFTTDetector::setMaxFeatures( int maxFeatures )

AutoIt:
    $oGFTTDetector.setMaxFeatures( $maxFeatures ) -> None
```

### cv::GFTTDetector::getMaxFeatures

```cpp
int cv::GFTTDetector::getMaxFeatures()

AutoIt:
    $oGFTTDetector.getMaxFeatures() -> retval
```

### cv::GFTTDetector::setQualityLevel

```cpp
void cv::GFTTDetector::setQualityLevel( double qlevel )

AutoIt:
    $oGFTTDetector.setQualityLevel( $qlevel ) -> None
```

### cv::GFTTDetector::getQualityLevel

```cpp
double cv::GFTTDetector::getQualityLevel()

AutoIt:
    $oGFTTDetector.getQualityLevel() -> retval
```

### cv::GFTTDetector::setMinDistance

```cpp
void cv::GFTTDetector::setMinDistance( double minDistance )

AutoIt:
    $oGFTTDetector.setMinDistance( $minDistance ) -> None
```

### cv::GFTTDetector::getMinDistance

```cpp
double cv::GFTTDetector::getMinDistance()

AutoIt:
    $oGFTTDetector.getMinDistance() -> retval
```

### cv::GFTTDetector::setBlockSize

```cpp
void cv::GFTTDetector::setBlockSize( int blockSize )

AutoIt:
    $oGFTTDetector.setBlockSize( $blockSize ) -> None
```

### cv::GFTTDetector::getBlockSize

```cpp
int cv::GFTTDetector::getBlockSize()

AutoIt:
    $oGFTTDetector.getBlockSize() -> retval
```

### cv::GFTTDetector::setHarrisDetector

```cpp
void cv::GFTTDetector::setHarrisDetector( bool val )

AutoIt:
    $oGFTTDetector.setHarrisDetector( $val ) -> None
```

### cv::GFTTDetector::getHarrisDetector

```cpp
bool cv::GFTTDetector::getHarrisDetector()

AutoIt:
    $oGFTTDetector.getHarrisDetector() -> retval
```

### cv::GFTTDetector::setK

```cpp
void cv::GFTTDetector::setK( double k )

AutoIt:
    $oGFTTDetector.setK( $k ) -> None
```

### cv::GFTTDetector::getK

```cpp
double cv::GFTTDetector::getK()

AutoIt:
    $oGFTTDetector.getK() -> retval
```

### cv::GFTTDetector::getDefaultName

```cpp
std::string cv::GFTTDetector::getDefaultName()

AutoIt:
    $oGFTTDetector.getDefaultName() -> retval
```

### cv::GFTTDetector::detect

```cpp
void cv::GFTTDetector::detect( _InputArray                image,
                               std::vector<cv::KeyPoint>& keypoints,
                               _InputArray                mask = noArray() )

AutoIt:
    $oGFTTDetector.detect( $image[, $mask[, $keypoints]] ) -> $keypoints
```

```cpp
void cv::GFTTDetector::detect( _InputArray                             images,
                               std::vector<std::vector<cv::KeyPoint>>& keypoints,
                               _InputArray                             masks = noArray() )

AutoIt:
    $oGFTTDetector.detect( $images[, $masks[, $keypoints]] ) -> $keypoints
```

### cv::GFTTDetector::compute

```cpp
void cv::GFTTDetector::compute( _InputArray                image,
                                std::vector<cv::KeyPoint>& keypoints,
                                _OutputArray               descriptors )

AutoIt:
    $oGFTTDetector.compute( $image, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

```cpp
void cv::GFTTDetector::compute( _InputArray                             images,
                                std::vector<std::vector<cv::KeyPoint>>& keypoints,
                                _OutputArray                            descriptors )

AutoIt:
    $oGFTTDetector.compute( $images, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

### cv::GFTTDetector::detectAndCompute

```cpp
void cv::GFTTDetector::detectAndCompute( _InputArray                image,
                                         _InputArray                mask,
                                         std::vector<cv::KeyPoint>& keypoints,
                                         _OutputArray               descriptors,
                                         bool                       useProvidedKeypoints = false )

AutoIt:
    $oGFTTDetector.detectAndCompute( $image, $mask[, $descriptors[, $useProvidedKeypoints[, $keypoints]]] ) -> $keypoints, $descriptors
```

### cv::GFTTDetector::descriptorSize

```cpp
int cv::GFTTDetector::descriptorSize()

AutoIt:
    $oGFTTDetector.descriptorSize() -> retval
```

### cv::GFTTDetector::descriptorType

```cpp
int cv::GFTTDetector::descriptorType()

AutoIt:
    $oGFTTDetector.descriptorType() -> retval
```

### cv::GFTTDetector::defaultNorm

```cpp
int cv::GFTTDetector::defaultNorm()

AutoIt:
    $oGFTTDetector.defaultNorm() -> retval
```

### cv::GFTTDetector::write

```cpp
void cv::GFTTDetector::write( const std::string& fileName )

AutoIt:
    $oGFTTDetector.write( $fileName ) -> None
```

```cpp
void cv::GFTTDetector::write( const cv::Ptr<cv::FileStorage>& fs,
                              const std::string&              name = String() )

AutoIt:
    $oGFTTDetector.write( $fs[, $name] ) -> None
```

### cv::GFTTDetector::read

```cpp
void cv::GFTTDetector::read( const std::string& fileName )

AutoIt:
    $oGFTTDetector.read( $fileName ) -> None
```

```cpp
void cv::GFTTDetector::read( const cv::FileNode& arg1 )

AutoIt:
    $oGFTTDetector.read( $arg1 ) -> None
```

### cv::GFTTDetector::empty

```cpp
bool cv::GFTTDetector::empty()

AutoIt:
    $oGFTTDetector.empty() -> retval
```

### cv::GFTTDetector::clear

```cpp
void cv::GFTTDetector::clear()

AutoIt:
    $oGFTTDetector.clear() -> None
```

### cv::GFTTDetector::save

```cpp
void cv::GFTTDetector::save( const std::string& filename )

AutoIt:
    $oGFTTDetector.save( $filename ) -> None
```

## cv::SimpleBlobDetector

### cv::SimpleBlobDetector::create

```cpp
static cv::Ptr<cv::SimpleBlobDetector> cv::SimpleBlobDetector::create( const cv::SimpleBlobDetector::Params& parameters = SimpleBlobDetector::Params() )

AutoIt:
    _OpenCV_ObjCreate("cv.SimpleBlobDetector").create( [$parameters] ) -> retval
```

### cv::SimpleBlobDetector::getDefaultName

```cpp
std::string cv::SimpleBlobDetector::getDefaultName()

AutoIt:
    $oSimpleBlobDetector.getDefaultName() -> retval
```

### cv::SimpleBlobDetector::detect

```cpp
void cv::SimpleBlobDetector::detect( _InputArray                image,
                                     std::vector<cv::KeyPoint>& keypoints,
                                     _InputArray                mask = noArray() )

AutoIt:
    $oSimpleBlobDetector.detect( $image[, $mask[, $keypoints]] ) -> $keypoints
```

```cpp
void cv::SimpleBlobDetector::detect( _InputArray                             images,
                                     std::vector<std::vector<cv::KeyPoint>>& keypoints,
                                     _InputArray                             masks = noArray() )

AutoIt:
    $oSimpleBlobDetector.detect( $images[, $masks[, $keypoints]] ) -> $keypoints
```

### cv::SimpleBlobDetector::compute

```cpp
void cv::SimpleBlobDetector::compute( _InputArray                image,
                                      std::vector<cv::KeyPoint>& keypoints,
                                      _OutputArray               descriptors )

AutoIt:
    $oSimpleBlobDetector.compute( $image, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

```cpp
void cv::SimpleBlobDetector::compute( _InputArray                             images,
                                      std::vector<std::vector<cv::KeyPoint>>& keypoints,
                                      _OutputArray                            descriptors )

AutoIt:
    $oSimpleBlobDetector.compute( $images, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

### cv::SimpleBlobDetector::detectAndCompute

```cpp
void cv::SimpleBlobDetector::detectAndCompute( _InputArray                image,
                                               _InputArray                mask,
                                               std::vector<cv::KeyPoint>& keypoints,
                                               _OutputArray               descriptors,
                                               bool                       useProvidedKeypoints = false )

AutoIt:
    $oSimpleBlobDetector.detectAndCompute( $image, $mask[, $descriptors[, $useProvidedKeypoints[, $keypoints]]] ) -> $keypoints, $descriptors
```

### cv::SimpleBlobDetector::descriptorSize

```cpp
int cv::SimpleBlobDetector::descriptorSize()

AutoIt:
    $oSimpleBlobDetector.descriptorSize() -> retval
```

### cv::SimpleBlobDetector::descriptorType

```cpp
int cv::SimpleBlobDetector::descriptorType()

AutoIt:
    $oSimpleBlobDetector.descriptorType() -> retval
```

### cv::SimpleBlobDetector::defaultNorm

```cpp
int cv::SimpleBlobDetector::defaultNorm()

AutoIt:
    $oSimpleBlobDetector.defaultNorm() -> retval
```

### cv::SimpleBlobDetector::write

```cpp
void cv::SimpleBlobDetector::write( const std::string& fileName )

AutoIt:
    $oSimpleBlobDetector.write( $fileName ) -> None
```

```cpp
void cv::SimpleBlobDetector::write( const cv::Ptr<cv::FileStorage>& fs,
                                    const std::string&              name = String() )

AutoIt:
    $oSimpleBlobDetector.write( $fs[, $name] ) -> None
```

### cv::SimpleBlobDetector::read

```cpp
void cv::SimpleBlobDetector::read( const std::string& fileName )

AutoIt:
    $oSimpleBlobDetector.read( $fileName ) -> None
```

```cpp
void cv::SimpleBlobDetector::read( const cv::FileNode& arg1 )

AutoIt:
    $oSimpleBlobDetector.read( $arg1 ) -> None
```

### cv::SimpleBlobDetector::empty

```cpp
bool cv::SimpleBlobDetector::empty()

AutoIt:
    $oSimpleBlobDetector.empty() -> retval
```

### cv::SimpleBlobDetector::clear

```cpp
void cv::SimpleBlobDetector::clear()

AutoIt:
    $oSimpleBlobDetector.clear() -> None
```

### cv::SimpleBlobDetector::save

```cpp
void cv::SimpleBlobDetector::save( const std::string& filename )

AutoIt:
    $oSimpleBlobDetector.save( $filename ) -> None
```

## cv::SimpleBlobDetector::Params

### cv::SimpleBlobDetector::Params::create

```cpp
static cv::SimpleBlobDetector::Params cv::SimpleBlobDetector::Params::create()

AutoIt:
    _OpenCV_ObjCreate("cv.SimpleBlobDetector.Params").create() -> <cv.SimpleBlobDetector.Params object>
```

```cpp
static cv::SimpleBlobDetector::Params cv::SimpleBlobDetector::Params::create()

AutoIt:
    _OpenCV_ObjCreate("cv.SimpleBlobDetector.Params").create() -> <cv.SimpleBlobDetector.Params object>
```

## cv::KAZE

### cv::KAZE::create

```cpp
static cv::Ptr<cv::KAZE> cv::KAZE::create( bool  extended = false,
                                           bool  upright = false,
                                           float threshold = 0.001f,
                                           int   nOctaves = 4,
                                           int   nOctaveLayers = 4,
                                           int   diffusivity = KAZE::DIFF_PM_G2 )

AutoIt:
    _OpenCV_ObjCreate("cv.KAZE").create( [$extended[, $upright[, $threshold[, $nOctaves[, $nOctaveLayers[, $diffusivity]]]]]] ) -> retval
```

### cv::KAZE::setExtended

```cpp
void cv::KAZE::setExtended( bool extended )

AutoIt:
    $oKAZE.setExtended( $extended ) -> None
```

### cv::KAZE::getExtended

```cpp
bool cv::KAZE::getExtended()

AutoIt:
    $oKAZE.getExtended() -> retval
```

### cv::KAZE::setUpright

```cpp
void cv::KAZE::setUpright( bool upright )

AutoIt:
    $oKAZE.setUpright( $upright ) -> None
```

### cv::KAZE::getUpright

```cpp
bool cv::KAZE::getUpright()

AutoIt:
    $oKAZE.getUpright() -> retval
```

### cv::KAZE::setThreshold

```cpp
void cv::KAZE::setThreshold( double threshold )

AutoIt:
    $oKAZE.setThreshold( $threshold ) -> None
```

### cv::KAZE::getThreshold

```cpp
double cv::KAZE::getThreshold()

AutoIt:
    $oKAZE.getThreshold() -> retval
```

### cv::KAZE::setNOctaves

```cpp
void cv::KAZE::setNOctaves( int octaves )

AutoIt:
    $oKAZE.setNOctaves( $octaves ) -> None
```

### cv::KAZE::getNOctaves

```cpp
int cv::KAZE::getNOctaves()

AutoIt:
    $oKAZE.getNOctaves() -> retval
```

### cv::KAZE::setNOctaveLayers

```cpp
void cv::KAZE::setNOctaveLayers( int octaveLayers )

AutoIt:
    $oKAZE.setNOctaveLayers( $octaveLayers ) -> None
```

### cv::KAZE::getNOctaveLayers

```cpp
int cv::KAZE::getNOctaveLayers()

AutoIt:
    $oKAZE.getNOctaveLayers() -> retval
```

### cv::KAZE::setDiffusivity

```cpp
void cv::KAZE::setDiffusivity( int diff )

AutoIt:
    $oKAZE.setDiffusivity( $diff ) -> None
```

### cv::KAZE::getDiffusivity

```cpp
int cv::KAZE::getDiffusivity()

AutoIt:
    $oKAZE.getDiffusivity() -> retval
```

### cv::KAZE::getDefaultName

```cpp
std::string cv::KAZE::getDefaultName()

AutoIt:
    $oKAZE.getDefaultName() -> retval
```

### cv::KAZE::detect

```cpp
void cv::KAZE::detect( _InputArray                image,
                       std::vector<cv::KeyPoint>& keypoints,
                       _InputArray                mask = noArray() )

AutoIt:
    $oKAZE.detect( $image[, $mask[, $keypoints]] ) -> $keypoints
```

```cpp
void cv::KAZE::detect( _InputArray                             images,
                       std::vector<std::vector<cv::KeyPoint>>& keypoints,
                       _InputArray                             masks = noArray() )

AutoIt:
    $oKAZE.detect( $images[, $masks[, $keypoints]] ) -> $keypoints
```

### cv::KAZE::compute

```cpp
void cv::KAZE::compute( _InputArray                image,
                        std::vector<cv::KeyPoint>& keypoints,
                        _OutputArray               descriptors )

AutoIt:
    $oKAZE.compute( $image, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

```cpp
void cv::KAZE::compute( _InputArray                             images,
                        std::vector<std::vector<cv::KeyPoint>>& keypoints,
                        _OutputArray                            descriptors )

AutoIt:
    $oKAZE.compute( $images, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

### cv::KAZE::detectAndCompute

```cpp
void cv::KAZE::detectAndCompute( _InputArray                image,
                                 _InputArray                mask,
                                 std::vector<cv::KeyPoint>& keypoints,
                                 _OutputArray               descriptors,
                                 bool                       useProvidedKeypoints = false )

AutoIt:
    $oKAZE.detectAndCompute( $image, $mask[, $descriptors[, $useProvidedKeypoints[, $keypoints]]] ) -> $keypoints, $descriptors
```

### cv::KAZE::descriptorSize

```cpp
int cv::KAZE::descriptorSize()

AutoIt:
    $oKAZE.descriptorSize() -> retval
```

### cv::KAZE::descriptorType

```cpp
int cv::KAZE::descriptorType()

AutoIt:
    $oKAZE.descriptorType() -> retval
```

### cv::KAZE::defaultNorm

```cpp
int cv::KAZE::defaultNorm()

AutoIt:
    $oKAZE.defaultNorm() -> retval
```

### cv::KAZE::write

```cpp
void cv::KAZE::write( const std::string& fileName )

AutoIt:
    $oKAZE.write( $fileName ) -> None
```

```cpp
void cv::KAZE::write( const cv::Ptr<cv::FileStorage>& fs,
                      const std::string&              name = String() )

AutoIt:
    $oKAZE.write( $fs[, $name] ) -> None
```

### cv::KAZE::read

```cpp
void cv::KAZE::read( const std::string& fileName )

AutoIt:
    $oKAZE.read( $fileName ) -> None
```

```cpp
void cv::KAZE::read( const cv::FileNode& arg1 )

AutoIt:
    $oKAZE.read( $arg1 ) -> None
```

### cv::KAZE::empty

```cpp
bool cv::KAZE::empty()

AutoIt:
    $oKAZE.empty() -> retval
```

### cv::KAZE::clear

```cpp
void cv::KAZE::clear()

AutoIt:
    $oKAZE.clear() -> None
```

### cv::KAZE::save

```cpp
void cv::KAZE::save( const std::string& filename )

AutoIt:
    $oKAZE.save( $filename ) -> None
```

## cv::AKAZE

### cv::AKAZE::create

```cpp
static cv::Ptr<cv::AKAZE> cv::AKAZE::create( int   descriptor_type = AKAZE::DESCRIPTOR_MLDB,
                                             int   descriptor_size = 0,
                                             int   descriptor_channels = 3,
                                             float threshold = 0.001f,
                                             int   nOctaves = 4,
                                             int   nOctaveLayers = 4,
                                             int   diffusivity = KAZE::DIFF_PM_G2 )

AutoIt:
    _OpenCV_ObjCreate("cv.AKAZE").create( [$descriptor_type[, $descriptor_size[, $descriptor_channels[, $threshold[, $nOctaves[, $nOctaveLayers[, $diffusivity]]]]]]] ) -> retval
```

### cv::AKAZE::setDescriptorType

```cpp
void cv::AKAZE::setDescriptorType( int dtype )

AutoIt:
    $oAKAZE.setDescriptorType( $dtype ) -> None
```

### cv::AKAZE::getDescriptorType

```cpp
int cv::AKAZE::getDescriptorType()

AutoIt:
    $oAKAZE.getDescriptorType() -> retval
```

### cv::AKAZE::setDescriptorSize

```cpp
void cv::AKAZE::setDescriptorSize( int dsize )

AutoIt:
    $oAKAZE.setDescriptorSize( $dsize ) -> None
```

### cv::AKAZE::getDescriptorSize

```cpp
int cv::AKAZE::getDescriptorSize()

AutoIt:
    $oAKAZE.getDescriptorSize() -> retval
```

### cv::AKAZE::setDescriptorChannels

```cpp
void cv::AKAZE::setDescriptorChannels( int dch )

AutoIt:
    $oAKAZE.setDescriptorChannels( $dch ) -> None
```

### cv::AKAZE::getDescriptorChannels

```cpp
int cv::AKAZE::getDescriptorChannels()

AutoIt:
    $oAKAZE.getDescriptorChannels() -> retval
```

### cv::AKAZE::setThreshold

```cpp
void cv::AKAZE::setThreshold( double threshold )

AutoIt:
    $oAKAZE.setThreshold( $threshold ) -> None
```

### cv::AKAZE::getThreshold

```cpp
double cv::AKAZE::getThreshold()

AutoIt:
    $oAKAZE.getThreshold() -> retval
```

### cv::AKAZE::setNOctaves

```cpp
void cv::AKAZE::setNOctaves( int octaves )

AutoIt:
    $oAKAZE.setNOctaves( $octaves ) -> None
```

### cv::AKAZE::getNOctaves

```cpp
int cv::AKAZE::getNOctaves()

AutoIt:
    $oAKAZE.getNOctaves() -> retval
```

### cv::AKAZE::setNOctaveLayers

```cpp
void cv::AKAZE::setNOctaveLayers( int octaveLayers )

AutoIt:
    $oAKAZE.setNOctaveLayers( $octaveLayers ) -> None
```

### cv::AKAZE::getNOctaveLayers

```cpp
int cv::AKAZE::getNOctaveLayers()

AutoIt:
    $oAKAZE.getNOctaveLayers() -> retval
```

### cv::AKAZE::setDiffusivity

```cpp
void cv::AKAZE::setDiffusivity( int diff )

AutoIt:
    $oAKAZE.setDiffusivity( $diff ) -> None
```

### cv::AKAZE::getDiffusivity

```cpp
int cv::AKAZE::getDiffusivity()

AutoIt:
    $oAKAZE.getDiffusivity() -> retval
```

### cv::AKAZE::getDefaultName

```cpp
std::string cv::AKAZE::getDefaultName()

AutoIt:
    $oAKAZE.getDefaultName() -> retval
```

### cv::AKAZE::detect

```cpp
void cv::AKAZE::detect( _InputArray                image,
                        std::vector<cv::KeyPoint>& keypoints,
                        _InputArray                mask = noArray() )

AutoIt:
    $oAKAZE.detect( $image[, $mask[, $keypoints]] ) -> $keypoints
```

```cpp
void cv::AKAZE::detect( _InputArray                             images,
                        std::vector<std::vector<cv::KeyPoint>>& keypoints,
                        _InputArray                             masks = noArray() )

AutoIt:
    $oAKAZE.detect( $images[, $masks[, $keypoints]] ) -> $keypoints
```

### cv::AKAZE::compute

```cpp
void cv::AKAZE::compute( _InputArray                image,
                         std::vector<cv::KeyPoint>& keypoints,
                         _OutputArray               descriptors )

AutoIt:
    $oAKAZE.compute( $image, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

```cpp
void cv::AKAZE::compute( _InputArray                             images,
                         std::vector<std::vector<cv::KeyPoint>>& keypoints,
                         _OutputArray                            descriptors )

AutoIt:
    $oAKAZE.compute( $images, $keypoints[, $descriptors] ) -> $keypoints, $descriptors
```

### cv::AKAZE::detectAndCompute

```cpp
void cv::AKAZE::detectAndCompute( _InputArray                image,
                                  _InputArray                mask,
                                  std::vector<cv::KeyPoint>& keypoints,
                                  _OutputArray               descriptors,
                                  bool                       useProvidedKeypoints = false )

AutoIt:
    $oAKAZE.detectAndCompute( $image, $mask[, $descriptors[, $useProvidedKeypoints[, $keypoints]]] ) -> $keypoints, $descriptors
```

### cv::AKAZE::descriptorSize

```cpp
int cv::AKAZE::descriptorSize()

AutoIt:
    $oAKAZE.descriptorSize() -> retval
```

### cv::AKAZE::descriptorType

```cpp
int cv::AKAZE::descriptorType()

AutoIt:
    $oAKAZE.descriptorType() -> retval
```

### cv::AKAZE::defaultNorm

```cpp
int cv::AKAZE::defaultNorm()

AutoIt:
    $oAKAZE.defaultNorm() -> retval
```

### cv::AKAZE::write

```cpp
void cv::AKAZE::write( const std::string& fileName )

AutoIt:
    $oAKAZE.write( $fileName ) -> None
```

```cpp
void cv::AKAZE::write( const cv::Ptr<cv::FileStorage>& fs,
                       const std::string&              name = String() )

AutoIt:
    $oAKAZE.write( $fs[, $name] ) -> None
```

### cv::AKAZE::read

```cpp
void cv::AKAZE::read( const std::string& fileName )

AutoIt:
    $oAKAZE.read( $fileName ) -> None
```

```cpp
void cv::AKAZE::read( const cv::FileNode& arg1 )

AutoIt:
    $oAKAZE.read( $arg1 ) -> None
```

### cv::AKAZE::empty

```cpp
bool cv::AKAZE::empty()

AutoIt:
    $oAKAZE.empty() -> retval
```

### cv::AKAZE::clear

```cpp
void cv::AKAZE::clear()

AutoIt:
    $oAKAZE.clear() -> None
```

### cv::AKAZE::save

```cpp
void cv::AKAZE::save( const std::string& filename )

AutoIt:
    $oAKAZE.save( $filename ) -> None
```

## cv::DescriptorMatcher

### cv::DescriptorMatcher::add

```cpp
void cv::DescriptorMatcher::add( _InputArray descriptors )

AutoIt:
    $oDescriptorMatcher.add( $descriptors ) -> None
```

### cv::DescriptorMatcher::getTrainDescriptors

```cpp
std::vector<cv::Mat> cv::DescriptorMatcher::getTrainDescriptors()

AutoIt:
    $oDescriptorMatcher.getTrainDescriptors() -> retval
```

### cv::DescriptorMatcher::clear

```cpp
void cv::DescriptorMatcher::clear()

AutoIt:
    $oDescriptorMatcher.clear() -> None
```

### cv::DescriptorMatcher::empty

```cpp
bool cv::DescriptorMatcher::empty()

AutoIt:
    $oDescriptorMatcher.empty() -> retval
```

### cv::DescriptorMatcher::isMaskSupported

```cpp
bool cv::DescriptorMatcher::isMaskSupported()

AutoIt:
    $oDescriptorMatcher.isMaskSupported() -> retval
```

### cv::DescriptorMatcher::train

```cpp
void cv::DescriptorMatcher::train()

AutoIt:
    $oDescriptorMatcher.train() -> None
```

### cv::DescriptorMatcher::match

```cpp
void cv::DescriptorMatcher::match( _InputArray              queryDescriptors,
                                   _InputArray              trainDescriptors,
                                   std::vector<cv::DMatch>& matches,
                                   _InputArray              mask = noArray() )

AutoIt:
    $oDescriptorMatcher.match( $queryDescriptors, $trainDescriptors[, $mask[, $matches]] ) -> $matches
```

```cpp
void cv::DescriptorMatcher::match( _InputArray              queryDescriptors,
                                   std::vector<cv::DMatch>& matches,
                                   _InputArray              masks = noArray() )

AutoIt:
    $oDescriptorMatcher.match( $queryDescriptors[, $masks[, $matches]] ) -> $matches
```

### cv::DescriptorMatcher::knnMatch

```cpp
void cv::DescriptorMatcher::knnMatch( _InputArray                           queryDescriptors,
                                      _InputArray                           trainDescriptors,
                                      std::vector<std::vector<cv::DMatch>>& matches,
                                      int                                   k,
                                      _InputArray                           mask = noArray(),
                                      bool                                  compactResult = false )

AutoIt:
    $oDescriptorMatcher.knnMatch( $queryDescriptors, $trainDescriptors, $k[, $mask[, $compactResult[, $matches]]] ) -> $matches
```

```cpp
void cv::DescriptorMatcher::knnMatch( _InputArray                           queryDescriptors,
                                      std::vector<std::vector<cv::DMatch>>& matches,
                                      int                                   k,
                                      _InputArray                           masks = noArray(),
                                      bool                                  compactResult = false )

AutoIt:
    $oDescriptorMatcher.knnMatch( $queryDescriptors, $k[, $masks[, $compactResult[, $matches]]] ) -> $matches
```

### cv::DescriptorMatcher::radiusMatch

```cpp
void cv::DescriptorMatcher::radiusMatch( _InputArray                           queryDescriptors,
                                         _InputArray                           trainDescriptors,
                                         std::vector<std::vector<cv::DMatch>>& matches,
                                         float                                 maxDistance,
                                         _InputArray                           mask = noArray(),
                                         bool                                  compactResult = false )

AutoIt:
    $oDescriptorMatcher.radiusMatch( $queryDescriptors, $trainDescriptors, $maxDistance[, $mask[, $compactResult[, $matches]]] ) -> $matches
```

```cpp
void cv::DescriptorMatcher::radiusMatch( _InputArray                           queryDescriptors,
                                         std::vector<std::vector<cv::DMatch>>& matches,
                                         float                                 maxDistance,
                                         _InputArray                           masks = noArray(),
                                         bool                                  compactResult = false )

AutoIt:
    $oDescriptorMatcher.radiusMatch( $queryDescriptors, $maxDistance[, $masks[, $compactResult[, $matches]]] ) -> $matches
```

### cv::DescriptorMatcher::write

```cpp
void cv::DescriptorMatcher::write( const std::string& fileName )

AutoIt:
    $oDescriptorMatcher.write( $fileName ) -> None
```

```cpp
void cv::DescriptorMatcher::write( const cv::Ptr<cv::FileStorage>& fs,
                                   const std::string&              name = String() )

AutoIt:
    $oDescriptorMatcher.write( $fs[, $name] ) -> None
```

### cv::DescriptorMatcher::read

```cpp
void cv::DescriptorMatcher::read( const std::string& fileName )

AutoIt:
    $oDescriptorMatcher.read( $fileName ) -> None
```

```cpp
void cv::DescriptorMatcher::read( const cv::FileNode& arg1 )

AutoIt:
    $oDescriptorMatcher.read( $arg1 ) -> None
```

### cv::DescriptorMatcher::clone

```cpp
cv::Ptr<cv::DescriptorMatcher> cv::DescriptorMatcher::clone( bool emptyTrainData = false )

AutoIt:
    $oDescriptorMatcher.clone( [$emptyTrainData] ) -> retval
```

### cv::DescriptorMatcher::create

```cpp
static cv::Ptr<cv::DescriptorMatcher> cv::DescriptorMatcher::create( const std::string& descriptorMatcherType )

AutoIt:
    _OpenCV_ObjCreate("cv.DescriptorMatcher").create( $descriptorMatcherType ) -> retval
```

```cpp
static cv::Ptr<cv::DescriptorMatcher> cv::DescriptorMatcher::create( const int& matcherType )

AutoIt:
    _OpenCV_ObjCreate("cv.DescriptorMatcher").create( $matcherType ) -> retval
```

### cv::DescriptorMatcher::save

```cpp
void cv::DescriptorMatcher::save( const std::string& filename )

AutoIt:
    $oDescriptorMatcher.save( $filename ) -> None
```

### cv::DescriptorMatcher::getDefaultName

```cpp
std::string cv::DescriptorMatcher::getDefaultName()

AutoIt:
    $oDescriptorMatcher.getDefaultName() -> retval
```

## cv::BFMatcher

### cv::BFMatcher::create

```cpp
static cv::BFMatcher cv::BFMatcher::create( int  normType = NORM_L2,
                                            bool crossCheck = false )

AutoIt:
    _OpenCV_ObjCreate("cv.BFMatcher").create( [$normType[, $crossCheck]] ) -> <cv.BFMatcher object>
```

```cpp
static cv::Ptr<cv::BFMatcher> cv::BFMatcher::create( int  normType = NORM_L2,
                                                     bool crossCheck = false )

AutoIt:
    _OpenCV_ObjCreate("cv.BFMatcher").create( [$normType[, $crossCheck]] ) -> retval
```

### cv::BFMatcher::add

```cpp
void cv::BFMatcher::add( _InputArray descriptors )

AutoIt:
    $oBFMatcher.add( $descriptors ) -> None
```

### cv::BFMatcher::getTrainDescriptors

```cpp
std::vector<cv::Mat> cv::BFMatcher::getTrainDescriptors()

AutoIt:
    $oBFMatcher.getTrainDescriptors() -> retval
```

### cv::BFMatcher::clear

```cpp
void cv::BFMatcher::clear()

AutoIt:
    $oBFMatcher.clear() -> None
```

### cv::BFMatcher::empty

```cpp
bool cv::BFMatcher::empty()

AutoIt:
    $oBFMatcher.empty() -> retval
```

### cv::BFMatcher::isMaskSupported

```cpp
bool cv::BFMatcher::isMaskSupported()

AutoIt:
    $oBFMatcher.isMaskSupported() -> retval
```

### cv::BFMatcher::train

```cpp
void cv::BFMatcher::train()

AutoIt:
    $oBFMatcher.train() -> None
```

### cv::BFMatcher::match

```cpp
void cv::BFMatcher::match( _InputArray              queryDescriptors,
                           _InputArray              trainDescriptors,
                           std::vector<cv::DMatch>& matches,
                           _InputArray              mask = noArray() )

AutoIt:
    $oBFMatcher.match( $queryDescriptors, $trainDescriptors[, $mask[, $matches]] ) -> $matches
```

```cpp
void cv::BFMatcher::match( _InputArray              queryDescriptors,
                           std::vector<cv::DMatch>& matches,
                           _InputArray              masks = noArray() )

AutoIt:
    $oBFMatcher.match( $queryDescriptors[, $masks[, $matches]] ) -> $matches
```

### cv::BFMatcher::knnMatch

```cpp
void cv::BFMatcher::knnMatch( _InputArray                           queryDescriptors,
                              _InputArray                           trainDescriptors,
                              std::vector<std::vector<cv::DMatch>>& matches,
                              int                                   k,
                              _InputArray                           mask = noArray(),
                              bool                                  compactResult = false )

AutoIt:
    $oBFMatcher.knnMatch( $queryDescriptors, $trainDescriptors, $k[, $mask[, $compactResult[, $matches]]] ) -> $matches
```

```cpp
void cv::BFMatcher::knnMatch( _InputArray                           queryDescriptors,
                              std::vector<std::vector<cv::DMatch>>& matches,
                              int                                   k,
                              _InputArray                           masks = noArray(),
                              bool                                  compactResult = false )

AutoIt:
    $oBFMatcher.knnMatch( $queryDescriptors, $k[, $masks[, $compactResult[, $matches]]] ) -> $matches
```

### cv::BFMatcher::radiusMatch

```cpp
void cv::BFMatcher::radiusMatch( _InputArray                           queryDescriptors,
                                 _InputArray                           trainDescriptors,
                                 std::vector<std::vector<cv::DMatch>>& matches,
                                 float                                 maxDistance,
                                 _InputArray                           mask = noArray(),
                                 bool                                  compactResult = false )

AutoIt:
    $oBFMatcher.radiusMatch( $queryDescriptors, $trainDescriptors, $maxDistance[, $mask[, $compactResult[, $matches]]] ) -> $matches
```

```cpp
void cv::BFMatcher::radiusMatch( _InputArray                           queryDescriptors,
                                 std::vector<std::vector<cv::DMatch>>& matches,
                                 float                                 maxDistance,
                                 _InputArray                           masks = noArray(),
                                 bool                                  compactResult = false )

AutoIt:
    $oBFMatcher.radiusMatch( $queryDescriptors, $maxDistance[, $masks[, $compactResult[, $matches]]] ) -> $matches
```

### cv::BFMatcher::write

```cpp
void cv::BFMatcher::write( const std::string& fileName )

AutoIt:
    $oBFMatcher.write( $fileName ) -> None
```

```cpp
void cv::BFMatcher::write( const cv::Ptr<cv::FileStorage>& fs,
                           const std::string&              name = String() )

AutoIt:
    $oBFMatcher.write( $fs[, $name] ) -> None
```

### cv::BFMatcher::read

```cpp
void cv::BFMatcher::read( const std::string& fileName )

AutoIt:
    $oBFMatcher.read( $fileName ) -> None
```

```cpp
void cv::BFMatcher::read( const cv::FileNode& arg1 )

AutoIt:
    $oBFMatcher.read( $arg1 ) -> None
```

### cv::BFMatcher::clone

```cpp
cv::Ptr<cv::DescriptorMatcher> cv::BFMatcher::clone( bool emptyTrainData = false )

AutoIt:
    $oBFMatcher.clone( [$emptyTrainData] ) -> retval
```

### cv::BFMatcher::save

```cpp
void cv::BFMatcher::save( const std::string& filename )

AutoIt:
    $oBFMatcher.save( $filename ) -> None
```

### cv::BFMatcher::getDefaultName

```cpp
std::string cv::BFMatcher::getDefaultName()

AutoIt:
    $oBFMatcher.getDefaultName() -> retval
```

## cv::FlannBasedMatcher

### cv::FlannBasedMatcher::create

```cpp
static cv::FlannBasedMatcher cv::FlannBasedMatcher::create( const cv::Ptr<flann::IndexParams>&  indexParams = makePtr<flann::KDTreeIndexParams>(),
                                                            const cv::Ptr<flann::SearchParams>& searchParams = makePtr<flann::SearchParams>() )

AutoIt:
    _OpenCV_ObjCreate("cv.FlannBasedMatcher").create( [$indexParams[, $searchParams]] ) -> <cv.FlannBasedMatcher object>
```

```cpp
static cv::Ptr<cv::FlannBasedMatcher> cv::FlannBasedMatcher::create()

AutoIt:
    _OpenCV_ObjCreate("cv.FlannBasedMatcher").create() -> retval
```

### cv::FlannBasedMatcher::add

```cpp
void cv::FlannBasedMatcher::add( _InputArray descriptors )

AutoIt:
    $oFlannBasedMatcher.add( $descriptors ) -> None
```

### cv::FlannBasedMatcher::getTrainDescriptors

```cpp
std::vector<cv::Mat> cv::FlannBasedMatcher::getTrainDescriptors()

AutoIt:
    $oFlannBasedMatcher.getTrainDescriptors() -> retval
```

### cv::FlannBasedMatcher::clear

```cpp
void cv::FlannBasedMatcher::clear()

AutoIt:
    $oFlannBasedMatcher.clear() -> None
```

### cv::FlannBasedMatcher::empty

```cpp
bool cv::FlannBasedMatcher::empty()

AutoIt:
    $oFlannBasedMatcher.empty() -> retval
```

### cv::FlannBasedMatcher::isMaskSupported

```cpp
bool cv::FlannBasedMatcher::isMaskSupported()

AutoIt:
    $oFlannBasedMatcher.isMaskSupported() -> retval
```

### cv::FlannBasedMatcher::train

```cpp
void cv::FlannBasedMatcher::train()

AutoIt:
    $oFlannBasedMatcher.train() -> None
```

### cv::FlannBasedMatcher::match

```cpp
void cv::FlannBasedMatcher::match( _InputArray              queryDescriptors,
                                   _InputArray              trainDescriptors,
                                   std::vector<cv::DMatch>& matches,
                                   _InputArray              mask = noArray() )

AutoIt:
    $oFlannBasedMatcher.match( $queryDescriptors, $trainDescriptors[, $mask[, $matches]] ) -> $matches
```

```cpp
void cv::FlannBasedMatcher::match( _InputArray              queryDescriptors,
                                   std::vector<cv::DMatch>& matches,
                                   _InputArray              masks = noArray() )

AutoIt:
    $oFlannBasedMatcher.match( $queryDescriptors[, $masks[, $matches]] ) -> $matches
```

### cv::FlannBasedMatcher::knnMatch

```cpp
void cv::FlannBasedMatcher::knnMatch( _InputArray                           queryDescriptors,
                                      _InputArray                           trainDescriptors,
                                      std::vector<std::vector<cv::DMatch>>& matches,
                                      int                                   k,
                                      _InputArray                           mask = noArray(),
                                      bool                                  compactResult = false )

AutoIt:
    $oFlannBasedMatcher.knnMatch( $queryDescriptors, $trainDescriptors, $k[, $mask[, $compactResult[, $matches]]] ) -> $matches
```

```cpp
void cv::FlannBasedMatcher::knnMatch( _InputArray                           queryDescriptors,
                                      std::vector<std::vector<cv::DMatch>>& matches,
                                      int                                   k,
                                      _InputArray                           masks = noArray(),
                                      bool                                  compactResult = false )

AutoIt:
    $oFlannBasedMatcher.knnMatch( $queryDescriptors, $k[, $masks[, $compactResult[, $matches]]] ) -> $matches
```

### cv::FlannBasedMatcher::radiusMatch

```cpp
void cv::FlannBasedMatcher::radiusMatch( _InputArray                           queryDescriptors,
                                         _InputArray                           trainDescriptors,
                                         std::vector<std::vector<cv::DMatch>>& matches,
                                         float                                 maxDistance,
                                         _InputArray                           mask = noArray(),
                                         bool                                  compactResult = false )

AutoIt:
    $oFlannBasedMatcher.radiusMatch( $queryDescriptors, $trainDescriptors, $maxDistance[, $mask[, $compactResult[, $matches]]] ) -> $matches
```

```cpp
void cv::FlannBasedMatcher::radiusMatch( _InputArray                           queryDescriptors,
                                         std::vector<std::vector<cv::DMatch>>& matches,
                                         float                                 maxDistance,
                                         _InputArray                           masks = noArray(),
                                         bool                                  compactResult = false )

AutoIt:
    $oFlannBasedMatcher.radiusMatch( $queryDescriptors, $maxDistance[, $masks[, $compactResult[, $matches]]] ) -> $matches
```

### cv::FlannBasedMatcher::write

```cpp
void cv::FlannBasedMatcher::write( const std::string& fileName )

AutoIt:
    $oFlannBasedMatcher.write( $fileName ) -> None
```

```cpp
void cv::FlannBasedMatcher::write( const cv::Ptr<cv::FileStorage>& fs,
                                   const std::string&              name = String() )

AutoIt:
    $oFlannBasedMatcher.write( $fs[, $name] ) -> None
```

### cv::FlannBasedMatcher::read

```cpp
void cv::FlannBasedMatcher::read( const std::string& fileName )

AutoIt:
    $oFlannBasedMatcher.read( $fileName ) -> None
```

```cpp
void cv::FlannBasedMatcher::read( const cv::FileNode& arg1 )

AutoIt:
    $oFlannBasedMatcher.read( $arg1 ) -> None
```

### cv::FlannBasedMatcher::clone

```cpp
cv::Ptr<cv::DescriptorMatcher> cv::FlannBasedMatcher::clone( bool emptyTrainData = false )

AutoIt:
    $oFlannBasedMatcher.clone( [$emptyTrainData] ) -> retval
```

### cv::FlannBasedMatcher::save

```cpp
void cv::FlannBasedMatcher::save( const std::string& filename )

AutoIt:
    $oFlannBasedMatcher.save( $filename ) -> None
```

### cv::FlannBasedMatcher::getDefaultName

```cpp
std::string cv::FlannBasedMatcher::getDefaultName()

AutoIt:
    $oFlannBasedMatcher.getDefaultName() -> retval
```

## cv::BOWTrainer

### cv::BOWTrainer::add

```cpp
void cv::BOWTrainer::add( const cv::Mat& descriptors )

AutoIt:
    $oBOWTrainer.add( $descriptors ) -> None
```

### cv::BOWTrainer::getDescriptors

```cpp
std::vector<cv::Mat> cv::BOWTrainer::getDescriptors()

AutoIt:
    $oBOWTrainer.getDescriptors() -> retval
```

### cv::BOWTrainer::descriptorsCount

```cpp
int cv::BOWTrainer::descriptorsCount()

AutoIt:
    $oBOWTrainer.descriptorsCount() -> retval
```

### cv::BOWTrainer::clear

```cpp
void cv::BOWTrainer::clear()

AutoIt:
    $oBOWTrainer.clear() -> None
```

### cv::BOWTrainer::cluster

```cpp
cv::Mat cv::BOWTrainer::cluster()

AutoIt:
    $oBOWTrainer.cluster() -> retval
```

```cpp
cv::Mat cv::BOWTrainer::cluster( const cv::Mat& descriptors )

AutoIt:
    $oBOWTrainer.cluster( $descriptors ) -> retval
```

## cv::BOWKMeansTrainer

### cv::BOWKMeansTrainer::create

```cpp
static cv::BOWKMeansTrainer cv::BOWKMeansTrainer::create( int                     clusterCount,
                                                          const cv::TermCriteria& termcrit = TermCriteria(),
                                                          int                     attempts = 3,
                                                          int                     flags = KMEANS_PP_CENTERS )

AutoIt:
    _OpenCV_ObjCreate("cv.BOWKMeansTrainer").create( $clusterCount[, $termcrit[, $attempts[, $flags]]] ) -> <cv.BOWKMeansTrainer object>
```

### cv::BOWKMeansTrainer::cluster

```cpp
cv::Mat cv::BOWKMeansTrainer::cluster()

AutoIt:
    $oBOWKMeansTrainer.cluster() -> retval
```

```cpp
cv::Mat cv::BOWKMeansTrainer::cluster( const cv::Mat& descriptors )

AutoIt:
    $oBOWKMeansTrainer.cluster( $descriptors ) -> retval
```

### cv::BOWKMeansTrainer::add

```cpp
void cv::BOWKMeansTrainer::add( const cv::Mat& descriptors )

AutoIt:
    $oBOWKMeansTrainer.add( $descriptors ) -> None
```

### cv::BOWKMeansTrainer::getDescriptors

```cpp
std::vector<cv::Mat> cv::BOWKMeansTrainer::getDescriptors()

AutoIt:
    $oBOWKMeansTrainer.getDescriptors() -> retval
```

### cv::BOWKMeansTrainer::descriptorsCount

```cpp
int cv::BOWKMeansTrainer::descriptorsCount()

AutoIt:
    $oBOWKMeansTrainer.descriptorsCount() -> retval
```

### cv::BOWKMeansTrainer::clear

```cpp
void cv::BOWKMeansTrainer::clear()

AutoIt:
    $oBOWKMeansTrainer.clear() -> None
```

## cv::BOWImgDescriptorExtractor

### cv::BOWImgDescriptorExtractor::create

```cpp
static cv::BOWImgDescriptorExtractor cv::BOWImgDescriptorExtractor::create( const cv::Ptr<cv::Feature2D>&         dextractor,
                                                                            const cv::Ptr<cv::DescriptorMatcher>& dmatcher )

AutoIt:
    _OpenCV_ObjCreate("cv.BOWImgDescriptorExtractor").create( $dextractor, $dmatcher ) -> <cv.BOWImgDescriptorExtractor object>
```

### cv::BOWImgDescriptorExtractor::setVocabulary

```cpp
void cv::BOWImgDescriptorExtractor::setVocabulary( const cv::Mat& vocabulary )

AutoIt:
    $oBOWImgDescriptorExtractor.setVocabulary( $vocabulary ) -> None
```

### cv::BOWImgDescriptorExtractor::getVocabulary

```cpp
cv::Mat cv::BOWImgDescriptorExtractor::getVocabulary()

AutoIt:
    $oBOWImgDescriptorExtractor.getVocabulary() -> retval
```

### cv::BOWImgDescriptorExtractor::compute

```cpp
void cv::BOWImgDescriptorExtractor::compute( const cv::Mat&             image,
                                             std::vector<cv::KeyPoint>& keypoints,
                                             cv::Mat&                   imgDescriptor )

AutoIt:
    $oBOWImgDescriptorExtractor.compute( $image, $keypoints[, $imgDescriptor] ) -> $imgDescriptor
```

### cv::BOWImgDescriptorExtractor::descriptorSize

```cpp
int cv::BOWImgDescriptorExtractor::descriptorSize()

AutoIt:
    $oBOWImgDescriptorExtractor.descriptorSize() -> retval
```

### cv::BOWImgDescriptorExtractor::descriptorType

```cpp
int cv::BOWImgDescriptorExtractor::descriptorType()

AutoIt:
    $oBOWImgDescriptorExtractor.descriptorType() -> retval
```

## cv::VideoCapture

### cv::VideoCapture::create

```cpp
static cv::VideoCapture cv::VideoCapture::create()

AutoIt:
    _OpenCV_ObjCreate("cv.VideoCapture").create() -> <cv.VideoCapture object>
```

```cpp
static cv::VideoCapture cv::VideoCapture::create( const std::string& filename,
                                                  int                apiPreference = CAP_ANY )

AutoIt:
    _OpenCV_ObjCreate("cv.VideoCapture").create( $filename[, $apiPreference] ) -> <cv.VideoCapture object>
```

```cpp
static cv::VideoCapture cv::VideoCapture::create( const std::string&      filename,
                                                  int                     apiPreference,
                                                  const std::vector<int>& params )

AutoIt:
    _OpenCV_ObjCreate("cv.VideoCapture").create( $filename, $apiPreference, $params ) -> <cv.VideoCapture object>
```

```cpp
static cv::VideoCapture cv::VideoCapture::create( int index,
                                                  int apiPreference = CAP_ANY )

AutoIt:
    _OpenCV_ObjCreate("cv.VideoCapture").create( $index[, $apiPreference] ) -> <cv.VideoCapture object>
```

```cpp
static cv::VideoCapture cv::VideoCapture::create( int                     index,
                                                  int                     apiPreference,
                                                  const std::vector<int>& params )

AutoIt:
    _OpenCV_ObjCreate("cv.VideoCapture").create( $index, $apiPreference, $params ) -> <cv.VideoCapture object>
```

### cv::VideoCapture::open

```cpp
bool cv::VideoCapture::open( const std::string& filename,
                             int                apiPreference = CAP_ANY )

AutoIt:
    $oVideoCapture.open( $filename[, $apiPreference] ) -> retval
```

```cpp
bool cv::VideoCapture::open( const std::string&      filename,
                             int                     apiPreference,
                             const std::vector<int>& params )

AutoIt:
    $oVideoCapture.open( $filename, $apiPreference, $params ) -> retval
```

```cpp
bool cv::VideoCapture::open( int index,
                             int apiPreference = CAP_ANY )

AutoIt:
    $oVideoCapture.open( $index[, $apiPreference] ) -> retval
```

```cpp
bool cv::VideoCapture::open( int                     index,
                             int                     apiPreference,
                             const std::vector<int>& params )

AutoIt:
    $oVideoCapture.open( $index, $apiPreference, $params ) -> retval
```

### cv::VideoCapture::isOpened

```cpp
bool cv::VideoCapture::isOpened()

AutoIt:
    $oVideoCapture.isOpened() -> retval
```

### cv::VideoCapture::release

```cpp
void cv::VideoCapture::release()

AutoIt:
    $oVideoCapture.release() -> None
```

### cv::VideoCapture::grab

```cpp
bool cv::VideoCapture::grab()

AutoIt:
    $oVideoCapture.grab() -> retval
```

### cv::VideoCapture::retrieve

```cpp
bool cv::VideoCapture::retrieve( _OutputArray image,
                                 int          flag = 0 )

AutoIt:
    $oVideoCapture.retrieve( [$image[, $flag]] ) -> retval, $image
```

### cv::VideoCapture::read

```cpp
bool cv::VideoCapture::read( _OutputArray image )

AutoIt:
    $oVideoCapture.read( [$image] ) -> retval, $image
```

### cv::VideoCapture::set

```cpp
bool cv::VideoCapture::set( int    propId,
                            double value )

AutoIt:
    $oVideoCapture.set( $propId, $value ) -> retval
```

### cv::VideoCapture::get

```cpp
double cv::VideoCapture::get( int propId )

AutoIt:
    $oVideoCapture.get( $propId ) -> retval
```

### cv::VideoCapture::getBackendName

```cpp
std::string cv::VideoCapture::getBackendName()

AutoIt:
    $oVideoCapture.getBackendName() -> retval
```

### cv::VideoCapture::setExceptionMode

```cpp
void cv::VideoCapture::setExceptionMode( bool enable )

AutoIt:
    $oVideoCapture.setExceptionMode( $enable ) -> None
```

### cv::VideoCapture::getExceptionMode

```cpp
bool cv::VideoCapture::getExceptionMode()

AutoIt:
    $oVideoCapture.getExceptionMode() -> retval
```

## cv::VideoWriter

### cv::VideoWriter::create

```cpp
static cv::VideoWriter cv::VideoWriter::create()

AutoIt:
    _OpenCV_ObjCreate("cv.VideoWriter").create() -> <cv.VideoWriter object>
```

```cpp
static cv::VideoWriter cv::VideoWriter::create( const std::string& filename,
                                                int                fourcc,
                                                double             fps,
                                                cv::Size           frameSize,
                                                bool               isColor = true )

AutoIt:
    _OpenCV_ObjCreate("cv.VideoWriter").create( $filename, $fourcc, $fps, $frameSize[, $isColor] ) -> <cv.VideoWriter object>
```

```cpp
static cv::VideoWriter cv::VideoWriter::create( const std::string& filename,
                                                int                apiPreference,
                                                int                fourcc,
                                                double             fps,
                                                cv::Size           frameSize,
                                                bool               isColor = true )

AutoIt:
    _OpenCV_ObjCreate("cv.VideoWriter").create( $filename, $apiPreference, $fourcc, $fps, $frameSize[, $isColor] ) -> <cv.VideoWriter object>
```

```cpp
static cv::VideoWriter cv::VideoWriter::create( const std::string&      filename,
                                                int                     fourcc,
                                                double                  fps,
                                                const cv::Size&         frameSize,
                                                const std::vector<int>& params )

AutoIt:
    _OpenCV_ObjCreate("cv.VideoWriter").create( $filename, $fourcc, $fps, $frameSize, $params ) -> <cv.VideoWriter object>
```

```cpp
static cv::VideoWriter cv::VideoWriter::create( const std::string&      filename,
                                                int                     apiPreference,
                                                int                     fourcc,
                                                double                  fps,
                                                const cv::Size&         frameSize,
                                                const std::vector<int>& params )

AutoIt:
    _OpenCV_ObjCreate("cv.VideoWriter").create( $filename, $apiPreference, $fourcc, $fps, $frameSize, $params ) -> <cv.VideoWriter object>
```

### cv::VideoWriter::open

```cpp
bool cv::VideoWriter::open( const std::string& filename,
                            int                fourcc,
                            double             fps,
                            cv::Size           frameSize,
                            bool               isColor = true )

AutoIt:
    $oVideoWriter.open( $filename, $fourcc, $fps, $frameSize[, $isColor] ) -> retval
```

```cpp
bool cv::VideoWriter::open( const std::string& filename,
                            int                apiPreference,
                            int                fourcc,
                            double             fps,
                            cv::Size           frameSize,
                            bool               isColor = true )

AutoIt:
    $oVideoWriter.open( $filename, $apiPreference, $fourcc, $fps, $frameSize[, $isColor] ) -> retval
```

```cpp
bool cv::VideoWriter::open( const std::string&      filename,
                            int                     fourcc,
                            double                  fps,
                            const cv::Size&         frameSize,
                            const std::vector<int>& params )

AutoIt:
    $oVideoWriter.open( $filename, $fourcc, $fps, $frameSize, $params ) -> retval
```

```cpp
bool cv::VideoWriter::open( const std::string&      filename,
                            int                     apiPreference,
                            int                     fourcc,
                            double                  fps,
                            const cv::Size&         frameSize,
                            const std::vector<int>& params )

AutoIt:
    $oVideoWriter.open( $filename, $apiPreference, $fourcc, $fps, $frameSize, $params ) -> retval
```

### cv::VideoWriter::isOpened

```cpp
bool cv::VideoWriter::isOpened()

AutoIt:
    $oVideoWriter.isOpened() -> retval
```

### cv::VideoWriter::release

```cpp
void cv::VideoWriter::release()

AutoIt:
    $oVideoWriter.release() -> None
```

### cv::VideoWriter::write

```cpp
void cv::VideoWriter::write( _InputArray image )

AutoIt:
    $oVideoWriter.write( $image ) -> None
```

### cv::VideoWriter::set

```cpp
bool cv::VideoWriter::set( int    propId,
                           double value )

AutoIt:
    $oVideoWriter.set( $propId, $value ) -> retval
```

### cv::VideoWriter::get

```cpp
double cv::VideoWriter::get( int propId )

AutoIt:
    $oVideoWriter.get( $propId ) -> retval
```

### cv::VideoWriter::fourcc

```cpp
static int cv::VideoWriter::fourcc( char c1,
                                    char c2,
                                    char c3,
                                    char c4 )

AutoIt:
    _OpenCV_ObjCreate("cv.VideoWriter").fourcc( $c1, $c2, $c3, $c4 ) -> retval
```

### cv::VideoWriter::getBackendName

```cpp
std::string cv::VideoWriter::getBackendName()

AutoIt:
    $oVideoWriter.getBackendName() -> retval
```

## cv::videoio_registry

### cv::videoio_registry::getBackendName

```cpp
std::string cv::videoio_registry::getBackendName( int api )

AutoIt:
    _OpenCV_ObjCreate("cv.videoio_registry").getBackendName( $api ) -> retval
```

### cv::videoio_registry::getBackends

```cpp
std::vector<int> cv::videoio_registry::getBackends()

AutoIt:
    _OpenCV_ObjCreate("cv.videoio_registry").getBackends() -> retval
```

### cv::videoio_registry::getCameraBackends

```cpp
std::vector<int> cv::videoio_registry::getCameraBackends()

AutoIt:
    _OpenCV_ObjCreate("cv.videoio_registry").getCameraBackends() -> retval
```

### cv::videoio_registry::getStreamBackends

```cpp
std::vector<int> cv::videoio_registry::getStreamBackends()

AutoIt:
    _OpenCV_ObjCreate("cv.videoio_registry").getStreamBackends() -> retval
```

### cv::videoio_registry::getWriterBackends

```cpp
std::vector<int> cv::videoio_registry::getWriterBackends()

AutoIt:
    _OpenCV_ObjCreate("cv.videoio_registry").getWriterBackends() -> retval
```

### cv::videoio_registry::hasBackend

```cpp
bool cv::videoio_registry::hasBackend( int api )

AutoIt:
    _OpenCV_ObjCreate("cv.videoio_registry").hasBackend( $api ) -> retval
```

### cv::videoio_registry::isBackendBuiltIn

```cpp
bool cv::videoio_registry::isBackendBuiltIn( int api )

AutoIt:
    _OpenCV_ObjCreate("cv.videoio_registry").isBackendBuiltIn( $api ) -> retval
```

### cv::videoio_registry::getCameraBackendPluginVersion

```cpp
std::string cv::videoio_registry::getCameraBackendPluginVersion( int  api,
                                                                 int& version_ABI,
                                                                 int& version_API )

AutoIt:
    _OpenCV_ObjCreate("cv.videoio_registry").getCameraBackendPluginVersion( $api[, $version_ABI[, $version_API]] ) -> retval, $version_ABI, $version_API
```

### cv::videoio_registry::getStreamBackendPluginVersion

```cpp
std::string cv::videoio_registry::getStreamBackendPluginVersion( int  api,
                                                                 int& version_ABI,
                                                                 int& version_API )

AutoIt:
    _OpenCV_ObjCreate("cv.videoio_registry").getStreamBackendPluginVersion( $api[, $version_ABI[, $version_API]] ) -> retval, $version_ABI, $version_API
```

### cv::videoio_registry::getWriterBackendPluginVersion

```cpp
std::string cv::videoio_registry::getWriterBackendPluginVersion( int  api,
                                                                 int& version_ABI,
                                                                 int& version_API )

AutoIt:
    _OpenCV_ObjCreate("cv.videoio_registry").getWriterBackendPluginVersion( $api[, $version_ABI[, $version_API]] ) -> retval, $version_ABI, $version_API
```

## cv::UsacParams

### cv::UsacParams::create

```cpp
static cv::UsacParams cv::UsacParams::create()

AutoIt:
    _OpenCV_ObjCreate("cv.UsacParams").create() -> <cv.UsacParams object>
```

```cpp
static cv::UsacParams cv::UsacParams::create()

AutoIt:
    _OpenCV_ObjCreate("cv.UsacParams").create() -> <cv.UsacParams object>
```

## cv::CirclesGridFinderParameters

### cv::CirclesGridFinderParameters::create

```cpp
static cv::CirclesGridFinderParameters cv::CirclesGridFinderParameters::create()

AutoIt:
    _OpenCV_ObjCreate("cv.CirclesGridFinderParameters").create() -> <cv.CirclesGridFinderParameters object>
```

```cpp
static cv::CirclesGridFinderParameters cv::CirclesGridFinderParameters::create()

AutoIt:
    _OpenCV_ObjCreate("cv.CirclesGridFinderParameters").create() -> <cv.CirclesGridFinderParameters object>
```

## cv::StereoMatcher

### cv::StereoMatcher::compute

```cpp
void cv::StereoMatcher::compute( _InputArray  left,
                                 _InputArray  right,
                                 _OutputArray disparity )

AutoIt:
    $oStereoMatcher.compute( $left, $right[, $disparity] ) -> $disparity
```

### cv::StereoMatcher::getMinDisparity

```cpp
int cv::StereoMatcher::getMinDisparity()

AutoIt:
    $oStereoMatcher.getMinDisparity() -> retval
```

### cv::StereoMatcher::setMinDisparity

```cpp
void cv::StereoMatcher::setMinDisparity( int minDisparity )

AutoIt:
    $oStereoMatcher.setMinDisparity( $minDisparity ) -> None
```

### cv::StereoMatcher::getNumDisparities

```cpp
int cv::StereoMatcher::getNumDisparities()

AutoIt:
    $oStereoMatcher.getNumDisparities() -> retval
```

### cv::StereoMatcher::setNumDisparities

```cpp
void cv::StereoMatcher::setNumDisparities( int numDisparities )

AutoIt:
    $oStereoMatcher.setNumDisparities( $numDisparities ) -> None
```

### cv::StereoMatcher::getBlockSize

```cpp
int cv::StereoMatcher::getBlockSize()

AutoIt:
    $oStereoMatcher.getBlockSize() -> retval
```

### cv::StereoMatcher::setBlockSize

```cpp
void cv::StereoMatcher::setBlockSize( int blockSize )

AutoIt:
    $oStereoMatcher.setBlockSize( $blockSize ) -> None
```

### cv::StereoMatcher::getSpeckleWindowSize

```cpp
int cv::StereoMatcher::getSpeckleWindowSize()

AutoIt:
    $oStereoMatcher.getSpeckleWindowSize() -> retval
```

### cv::StereoMatcher::setSpeckleWindowSize

```cpp
void cv::StereoMatcher::setSpeckleWindowSize( int speckleWindowSize )

AutoIt:
    $oStereoMatcher.setSpeckleWindowSize( $speckleWindowSize ) -> None
```

### cv::StereoMatcher::getSpeckleRange

```cpp
int cv::StereoMatcher::getSpeckleRange()

AutoIt:
    $oStereoMatcher.getSpeckleRange() -> retval
```

### cv::StereoMatcher::setSpeckleRange

```cpp
void cv::StereoMatcher::setSpeckleRange( int speckleRange )

AutoIt:
    $oStereoMatcher.setSpeckleRange( $speckleRange ) -> None
```

### cv::StereoMatcher::getDisp12MaxDiff

```cpp
int cv::StereoMatcher::getDisp12MaxDiff()

AutoIt:
    $oStereoMatcher.getDisp12MaxDiff() -> retval
```

### cv::StereoMatcher::setDisp12MaxDiff

```cpp
void cv::StereoMatcher::setDisp12MaxDiff( int disp12MaxDiff )

AutoIt:
    $oStereoMatcher.setDisp12MaxDiff( $disp12MaxDiff ) -> None
```

### cv::StereoMatcher::clear

```cpp
void cv::StereoMatcher::clear()

AutoIt:
    $oStereoMatcher.clear() -> None
```

### cv::StereoMatcher::write

```cpp
void cv::StereoMatcher::write( const cv::Ptr<cv::FileStorage>& fs,
                               const std::string&              name = String() )

AutoIt:
    $oStereoMatcher.write( $fs[, $name] ) -> None
```

### cv::StereoMatcher::read

```cpp
void cv::StereoMatcher::read( const cv::FileNode& fn )

AutoIt:
    $oStereoMatcher.read( $fn ) -> None
```

### cv::StereoMatcher::empty

```cpp
bool cv::StereoMatcher::empty()

AutoIt:
    $oStereoMatcher.empty() -> retval
```

### cv::StereoMatcher::save

```cpp
void cv::StereoMatcher::save( const std::string& filename )

AutoIt:
    $oStereoMatcher.save( $filename ) -> None
```

### cv::StereoMatcher::getDefaultName

```cpp
std::string cv::StereoMatcher::getDefaultName()

AutoIt:
    $oStereoMatcher.getDefaultName() -> retval
```

## cv::StereoBM

### cv::StereoBM::getPreFilterType

```cpp
int cv::StereoBM::getPreFilterType()

AutoIt:
    $oStereoBM.getPreFilterType() -> retval
```

### cv::StereoBM::setPreFilterType

```cpp
void cv::StereoBM::setPreFilterType( int preFilterType )

AutoIt:
    $oStereoBM.setPreFilterType( $preFilterType ) -> None
```

### cv::StereoBM::getPreFilterSize

```cpp
int cv::StereoBM::getPreFilterSize()

AutoIt:
    $oStereoBM.getPreFilterSize() -> retval
```

### cv::StereoBM::setPreFilterSize

```cpp
void cv::StereoBM::setPreFilterSize( int preFilterSize )

AutoIt:
    $oStereoBM.setPreFilterSize( $preFilterSize ) -> None
```

### cv::StereoBM::getPreFilterCap

```cpp
int cv::StereoBM::getPreFilterCap()

AutoIt:
    $oStereoBM.getPreFilterCap() -> retval
```

### cv::StereoBM::setPreFilterCap

```cpp
void cv::StereoBM::setPreFilterCap( int preFilterCap )

AutoIt:
    $oStereoBM.setPreFilterCap( $preFilterCap ) -> None
```

### cv::StereoBM::getTextureThreshold

```cpp
int cv::StereoBM::getTextureThreshold()

AutoIt:
    $oStereoBM.getTextureThreshold() -> retval
```

### cv::StereoBM::setTextureThreshold

```cpp
void cv::StereoBM::setTextureThreshold( int textureThreshold )

AutoIt:
    $oStereoBM.setTextureThreshold( $textureThreshold ) -> None
```

### cv::StereoBM::getUniquenessRatio

```cpp
int cv::StereoBM::getUniquenessRatio()

AutoIt:
    $oStereoBM.getUniquenessRatio() -> retval
```

### cv::StereoBM::setUniquenessRatio

```cpp
void cv::StereoBM::setUniquenessRatio( int uniquenessRatio )

AutoIt:
    $oStereoBM.setUniquenessRatio( $uniquenessRatio ) -> None
```

### cv::StereoBM::getSmallerBlockSize

```cpp
int cv::StereoBM::getSmallerBlockSize()

AutoIt:
    $oStereoBM.getSmallerBlockSize() -> retval
```

### cv::StereoBM::setSmallerBlockSize

```cpp
void cv::StereoBM::setSmallerBlockSize( int blockSize )

AutoIt:
    $oStereoBM.setSmallerBlockSize( $blockSize ) -> None
```

### cv::StereoBM::getROI1

```cpp
cv::Rect cv::StereoBM::getROI1()

AutoIt:
    $oStereoBM.getROI1() -> retval
```

### cv::StereoBM::setROI1

```cpp
void cv::StereoBM::setROI1( cv::Rect roi1 )

AutoIt:
    $oStereoBM.setROI1( $roi1 ) -> None
```

### cv::StereoBM::getROI2

```cpp
cv::Rect cv::StereoBM::getROI2()

AutoIt:
    $oStereoBM.getROI2() -> retval
```

### cv::StereoBM::setROI2

```cpp
void cv::StereoBM::setROI2( cv::Rect roi2 )

AutoIt:
    $oStereoBM.setROI2( $roi2 ) -> None
```

### cv::StereoBM::create

```cpp
static cv::Ptr<cv::StereoBM> cv::StereoBM::create( int numDisparities = 0,
                                                   int blockSize = 21 )

AutoIt:
    _OpenCV_ObjCreate("cv.StereoBM").create( [$numDisparities[, $blockSize]] ) -> retval
```

### cv::StereoBM::compute

```cpp
void cv::StereoBM::compute( _InputArray  left,
                            _InputArray  right,
                            _OutputArray disparity )

AutoIt:
    $oStereoBM.compute( $left, $right[, $disparity] ) -> $disparity
```

### cv::StereoBM::getMinDisparity

```cpp
int cv::StereoBM::getMinDisparity()

AutoIt:
    $oStereoBM.getMinDisparity() -> retval
```

### cv::StereoBM::setMinDisparity

```cpp
void cv::StereoBM::setMinDisparity( int minDisparity )

AutoIt:
    $oStereoBM.setMinDisparity( $minDisparity ) -> None
```

### cv::StereoBM::getNumDisparities

```cpp
int cv::StereoBM::getNumDisparities()

AutoIt:
    $oStereoBM.getNumDisparities() -> retval
```

### cv::StereoBM::setNumDisparities

```cpp
void cv::StereoBM::setNumDisparities( int numDisparities )

AutoIt:
    $oStereoBM.setNumDisparities( $numDisparities ) -> None
```

### cv::StereoBM::getBlockSize

```cpp
int cv::StereoBM::getBlockSize()

AutoIt:
    $oStereoBM.getBlockSize() -> retval
```

### cv::StereoBM::setBlockSize

```cpp
void cv::StereoBM::setBlockSize( int blockSize )

AutoIt:
    $oStereoBM.setBlockSize( $blockSize ) -> None
```

### cv::StereoBM::getSpeckleWindowSize

```cpp
int cv::StereoBM::getSpeckleWindowSize()

AutoIt:
    $oStereoBM.getSpeckleWindowSize() -> retval
```

### cv::StereoBM::setSpeckleWindowSize

```cpp
void cv::StereoBM::setSpeckleWindowSize( int speckleWindowSize )

AutoIt:
    $oStereoBM.setSpeckleWindowSize( $speckleWindowSize ) -> None
```

### cv::StereoBM::getSpeckleRange

```cpp
int cv::StereoBM::getSpeckleRange()

AutoIt:
    $oStereoBM.getSpeckleRange() -> retval
```

### cv::StereoBM::setSpeckleRange

```cpp
void cv::StereoBM::setSpeckleRange( int speckleRange )

AutoIt:
    $oStereoBM.setSpeckleRange( $speckleRange ) -> None
```

### cv::StereoBM::getDisp12MaxDiff

```cpp
int cv::StereoBM::getDisp12MaxDiff()

AutoIt:
    $oStereoBM.getDisp12MaxDiff() -> retval
```

### cv::StereoBM::setDisp12MaxDiff

```cpp
void cv::StereoBM::setDisp12MaxDiff( int disp12MaxDiff )

AutoIt:
    $oStereoBM.setDisp12MaxDiff( $disp12MaxDiff ) -> None
```

### cv::StereoBM::clear

```cpp
void cv::StereoBM::clear()

AutoIt:
    $oStereoBM.clear() -> None
```

### cv::StereoBM::write

```cpp
void cv::StereoBM::write( const cv::Ptr<cv::FileStorage>& fs,
                          const std::string&              name = String() )

AutoIt:
    $oStereoBM.write( $fs[, $name] ) -> None
```

### cv::StereoBM::read

```cpp
void cv::StereoBM::read( const cv::FileNode& fn )

AutoIt:
    $oStereoBM.read( $fn ) -> None
```

### cv::StereoBM::empty

```cpp
bool cv::StereoBM::empty()

AutoIt:
    $oStereoBM.empty() -> retval
```

### cv::StereoBM::save

```cpp
void cv::StereoBM::save( const std::string& filename )

AutoIt:
    $oStereoBM.save( $filename ) -> None
```

### cv::StereoBM::getDefaultName

```cpp
std::string cv::StereoBM::getDefaultName()

AutoIt:
    $oStereoBM.getDefaultName() -> retval
```

## cv::StereoSGBM

### cv::StereoSGBM::getPreFilterCap

```cpp
int cv::StereoSGBM::getPreFilterCap()

AutoIt:
    $oStereoSGBM.getPreFilterCap() -> retval
```

### cv::StereoSGBM::setPreFilterCap

```cpp
void cv::StereoSGBM::setPreFilterCap( int preFilterCap )

AutoIt:
    $oStereoSGBM.setPreFilterCap( $preFilterCap ) -> None
```

### cv::StereoSGBM::getUniquenessRatio

```cpp
int cv::StereoSGBM::getUniquenessRatio()

AutoIt:
    $oStereoSGBM.getUniquenessRatio() -> retval
```

### cv::StereoSGBM::setUniquenessRatio

```cpp
void cv::StereoSGBM::setUniquenessRatio( int uniquenessRatio )

AutoIt:
    $oStereoSGBM.setUniquenessRatio( $uniquenessRatio ) -> None
```

### cv::StereoSGBM::getP1

```cpp
int cv::StereoSGBM::getP1()

AutoIt:
    $oStereoSGBM.getP1() -> retval
```

### cv::StereoSGBM::setP1

```cpp
void cv::StereoSGBM::setP1( int P1 )

AutoIt:
    $oStereoSGBM.setP1( $P1 ) -> None
```

### cv::StereoSGBM::getP2

```cpp
int cv::StereoSGBM::getP2()

AutoIt:
    $oStereoSGBM.getP2() -> retval
```

### cv::StereoSGBM::setP2

```cpp
void cv::StereoSGBM::setP2( int P2 )

AutoIt:
    $oStereoSGBM.setP2( $P2 ) -> None
```

### cv::StereoSGBM::getMode

```cpp
int cv::StereoSGBM::getMode()

AutoIt:
    $oStereoSGBM.getMode() -> retval
```

### cv::StereoSGBM::setMode

```cpp
void cv::StereoSGBM::setMode( int mode )

AutoIt:
    $oStereoSGBM.setMode( $mode ) -> None
```

### cv::StereoSGBM::create

```cpp
static cv::Ptr<cv::StereoSGBM> cv::StereoSGBM::create( int minDisparity = 0,
                                                       int numDisparities = 16,
                                                       int blockSize = 3,
                                                       int P1 = 0,
                                                       int P2 = 0,
                                                       int disp12MaxDiff = 0,
                                                       int preFilterCap = 0,
                                                       int uniquenessRatio = 0,
                                                       int speckleWindowSize = 0,
                                                       int speckleRange = 0,
                                                       int mode = StereoSGBM::MODE_SGBM )

AutoIt:
    _OpenCV_ObjCreate("cv.StereoSGBM").create( [$minDisparity[, $numDisparities[, $blockSize[, $P1[, $P2[, $disp12MaxDiff[, $preFilterCap[, $uniquenessRatio[, $speckleWindowSize[, $speckleRange[, $mode]]]]]]]]]]] ) -> retval
```

### cv::StereoSGBM::compute

```cpp
void cv::StereoSGBM::compute( _InputArray  left,
                              _InputArray  right,
                              _OutputArray disparity )

AutoIt:
    $oStereoSGBM.compute( $left, $right[, $disparity] ) -> $disparity
```

### cv::StereoSGBM::getMinDisparity

```cpp
int cv::StereoSGBM::getMinDisparity()

AutoIt:
    $oStereoSGBM.getMinDisparity() -> retval
```

### cv::StereoSGBM::setMinDisparity

```cpp
void cv::StereoSGBM::setMinDisparity( int minDisparity )

AutoIt:
    $oStereoSGBM.setMinDisparity( $minDisparity ) -> None
```

### cv::StereoSGBM::getNumDisparities

```cpp
int cv::StereoSGBM::getNumDisparities()

AutoIt:
    $oStereoSGBM.getNumDisparities() -> retval
```

### cv::StereoSGBM::setNumDisparities

```cpp
void cv::StereoSGBM::setNumDisparities( int numDisparities )

AutoIt:
    $oStereoSGBM.setNumDisparities( $numDisparities ) -> None
```

### cv::StereoSGBM::getBlockSize

```cpp
int cv::StereoSGBM::getBlockSize()

AutoIt:
    $oStereoSGBM.getBlockSize() -> retval
```

### cv::StereoSGBM::setBlockSize

```cpp
void cv::StereoSGBM::setBlockSize( int blockSize )

AutoIt:
    $oStereoSGBM.setBlockSize( $blockSize ) -> None
```

### cv::StereoSGBM::getSpeckleWindowSize

```cpp
int cv::StereoSGBM::getSpeckleWindowSize()

AutoIt:
    $oStereoSGBM.getSpeckleWindowSize() -> retval
```

### cv::StereoSGBM::setSpeckleWindowSize

```cpp
void cv::StereoSGBM::setSpeckleWindowSize( int speckleWindowSize )

AutoIt:
    $oStereoSGBM.setSpeckleWindowSize( $speckleWindowSize ) -> None
```

### cv::StereoSGBM::getSpeckleRange

```cpp
int cv::StereoSGBM::getSpeckleRange()

AutoIt:
    $oStereoSGBM.getSpeckleRange() -> retval
```

### cv::StereoSGBM::setSpeckleRange

```cpp
void cv::StereoSGBM::setSpeckleRange( int speckleRange )

AutoIt:
    $oStereoSGBM.setSpeckleRange( $speckleRange ) -> None
```

### cv::StereoSGBM::getDisp12MaxDiff

```cpp
int cv::StereoSGBM::getDisp12MaxDiff()

AutoIt:
    $oStereoSGBM.getDisp12MaxDiff() -> retval
```

### cv::StereoSGBM::setDisp12MaxDiff

```cpp
void cv::StereoSGBM::setDisp12MaxDiff( int disp12MaxDiff )

AutoIt:
    $oStereoSGBM.setDisp12MaxDiff( $disp12MaxDiff ) -> None
```

### cv::StereoSGBM::clear

```cpp
void cv::StereoSGBM::clear()

AutoIt:
    $oStereoSGBM.clear() -> None
```

### cv::StereoSGBM::write

```cpp
void cv::StereoSGBM::write( const cv::Ptr<cv::FileStorage>& fs,
                            const std::string&              name = String() )

AutoIt:
    $oStereoSGBM.write( $fs[, $name] ) -> None
```

### cv::StereoSGBM::read

```cpp
void cv::StereoSGBM::read( const cv::FileNode& fn )

AutoIt:
    $oStereoSGBM.read( $fn ) -> None
```

### cv::StereoSGBM::empty

```cpp
bool cv::StereoSGBM::empty()

AutoIt:
    $oStereoSGBM.empty() -> retval
```

### cv::StereoSGBM::save

```cpp
void cv::StereoSGBM::save( const std::string& filename )

AutoIt:
    $oStereoSGBM.save( $filename ) -> None
```

### cv::StereoSGBM::getDefaultName

```cpp
std::string cv::StereoSGBM::getDefaultName()

AutoIt:
    $oStereoSGBM.getDefaultName() -> retval
```

## cv::fisheye

### cv::fisheye::projectPoints

```cpp
void cv::fisheye::projectPoints( _InputArray  objectPoints,
                                 _OutputArray imagePoints,
                                 _InputArray  rvec,
                                 _InputArray  tvec,
                                 _InputArray  K,
                                 _InputArray  D,
                                 double       alpha = 0,
                                 _OutputArray jacobian = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv.fisheye").projectPoints( $objectPoints, $rvec, $tvec, $K, $D[, $imagePoints[, $alpha[, $jacobian]]] ) -> $imagePoints, $jacobian
```

### cv::fisheye::distortPoints

```cpp
void cv::fisheye::distortPoints( _InputArray  undistorted,
                                 _OutputArray distorted,
                                 _InputArray  K,
                                 _InputArray  D,
                                 double       alpha = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv.fisheye").distortPoints( $undistorted, $K, $D[, $distorted[, $alpha]] ) -> $distorted
```

### cv::fisheye::undistortPoints

```cpp
void cv::fisheye::undistortPoints( _InputArray  distorted,
                                   _OutputArray undistorted,
                                   _InputArray  K,
                                   _InputArray  D,
                                   _InputArray  R = noArray(),
                                   _InputArray  P = noArray() )

AutoIt:
    _OpenCV_ObjCreate("cv.fisheye").undistortPoints( $distorted, $K, $D[, $undistorted[, $R[, $P]]] ) -> $undistorted
```

### cv::fisheye::initUndistortRectifyMap

```cpp
void cv::fisheye::initUndistortRectifyMap( _InputArray     K,
                                           _InputArray     D,
                                           _InputArray     R,
                                           _InputArray     P,
                                           const cv::Size& size,
                                           int             m1type,
                                           _OutputArray    map1,
                                           _OutputArray    map2 )

AutoIt:
    _OpenCV_ObjCreate("cv.fisheye").initUndistortRectifyMap( $K, $D, $R, $P, $size, $m1type[, $map1[, $map2]] ) -> $map1, $map2
```

### cv::fisheye::undistortImage

```cpp
void cv::fisheye::undistortImage( _InputArray     distorted,
                                  _OutputArray    undistorted,
                                  _InputArray     K,
                                  _InputArray     D,
                                  _InputArray     Knew = cv::noArray(),
                                  const cv::Size& new_size = Size() )

AutoIt:
    _OpenCV_ObjCreate("cv.fisheye").undistortImage( $distorted, $K, $D[, $undistorted[, $Knew[, $new_size]]] ) -> $undistorted
```

### cv::fisheye::estimateNewCameraMatrixForUndistortRectify

```cpp
void cv::fisheye::estimateNewCameraMatrixForUndistortRectify( _InputArray     K,
                                                              _InputArray     D,
                                                              const cv::Size& image_size,
                                                              _InputArray     R,
                                                              _OutputArray    P,
                                                              double          balance = 0.0,
                                                              const cv::Size& new_size = Size(),
                                                              double          fov_scale = 1.0 )

AutoIt:
    _OpenCV_ObjCreate("cv.fisheye").estimateNewCameraMatrixForUndistortRectify( $K, $D, $image_size, $R[, $P[, $balance[, $new_size[, $fov_scale]]]] ) -> $P
```

### cv::fisheye::calibrate

```cpp
double cv::fisheye::calibrate( _InputArray       objectPoints,
                               _InputArray       imagePoints,
                               const cv::Size&   image_size,
                               _InputOutputArray K,
                               _InputOutputArray D,
                               _OutputArray      rvecs,
                               _OutputArray      tvecs,
                               int               flags = 0,
                               cv::TermCriteria  criteria = TermCriteria(TermCriteria::COUNT + TermCriteria::EPS, 100, DBL_EPSILON) )

AutoIt:
    _OpenCV_ObjCreate("cv.fisheye").calibrate( $objectPoints, $imagePoints, $image_size, $K, $D[, $rvecs[, $tvecs[, $flags[, $criteria]]]] ) -> retval, $K, $D, $rvecs, $tvecs
```

### cv::fisheye::stereoRectify

```cpp
void cv::fisheye::stereoRectify( _InputArray     K1,
                                 _InputArray     D1,
                                 _InputArray     K2,
                                 _InputArray     D2,
                                 const cv::Size& imageSize,
                                 _InputArray     R,
                                 _InputArray     tvec,
                                 _OutputArray    R1,
                                 _OutputArray    R2,
                                 _OutputArray    P1,
                                 _OutputArray    P2,
                                 _OutputArray    Q,
                                 int             flags,
                                 const cv::Size& newImageSize = Size(),
                                 double          balance = 0.0,
                                 double          fov_scale = 1.0 )

AutoIt:
    _OpenCV_ObjCreate("cv.fisheye").stereoRectify( $K1, $D1, $K2, $D2, $imageSize, $R, $tvec, $flags[, $R1[, $R2[, $P1[, $P2[, $Q[, $newImageSize[, $balance[, $fov_scale]]]]]]]] ) -> $R1, $R2, $P1, $P2, $Q
```

### cv::fisheye::stereoCalibrate

```cpp
double cv::fisheye::stereoCalibrate( _InputArray       objectPoints,
                                     _InputArray       imagePoints1,
                                     _InputArray       imagePoints2,
                                     _InputOutputArray K1,
                                     _InputOutputArray D1,
                                     _InputOutputArray K2,
                                     _InputOutputArray D2,
                                     cv::Size          imageSize,
                                     _OutputArray      R,
                                     _OutputArray      T,
                                     int               flags = fisheye::CALIB_FIX_INTRINSIC,
                                     cv::TermCriteria  criteria = TermCriteria(TermCriteria::COUNT + TermCriteria::EPS, 100, DBL_EPSILON) )

AutoIt:
    _OpenCV_ObjCreate("cv.fisheye").stereoCalibrate( $objectPoints, $imagePoints1, $imagePoints2, $K1, $D1, $K2, $D2, $imageSize[, $R[, $T[, $flags[, $criteria]]]] ) -> retval, $K1, $D1, $K2, $D2, $R, $T
```

## cv::BaseCascadeClassifier

### cv::BaseCascadeClassifier::clear

```cpp
void cv::BaseCascadeClassifier::clear()

AutoIt:
    $oBaseCascadeClassifier.clear() -> None
```

### cv::BaseCascadeClassifier::write

```cpp
void cv::BaseCascadeClassifier::write( const cv::Ptr<cv::FileStorage>& fs,
                                       const std::string&              name = String() )

AutoIt:
    $oBaseCascadeClassifier.write( $fs[, $name] ) -> None
```

### cv::BaseCascadeClassifier::read

```cpp
void cv::BaseCascadeClassifier::read( const cv::FileNode& fn )

AutoIt:
    $oBaseCascadeClassifier.read( $fn ) -> None
```

### cv::BaseCascadeClassifier::empty

```cpp
bool cv::BaseCascadeClassifier::empty()

AutoIt:
    $oBaseCascadeClassifier.empty() -> retval
```

### cv::BaseCascadeClassifier::save

```cpp
void cv::BaseCascadeClassifier::save( const std::string& filename )

AutoIt:
    $oBaseCascadeClassifier.save( $filename ) -> None
```

### cv::BaseCascadeClassifier::getDefaultName

```cpp
std::string cv::BaseCascadeClassifier::getDefaultName()

AutoIt:
    $oBaseCascadeClassifier.getDefaultName() -> retval
```

## cv::CascadeClassifier

### cv::CascadeClassifier::create

```cpp
static cv::CascadeClassifier cv::CascadeClassifier::create()

AutoIt:
    _OpenCV_ObjCreate("cv.CascadeClassifier").create() -> <cv.CascadeClassifier object>
```

```cpp
static cv::CascadeClassifier cv::CascadeClassifier::create( const std::string& filename )

AutoIt:
    _OpenCV_ObjCreate("cv.CascadeClassifier").create( $filename ) -> <cv.CascadeClassifier object>
```

### cv::CascadeClassifier::empty

```cpp
bool cv::CascadeClassifier::empty()

AutoIt:
    $oCascadeClassifier.empty() -> retval
```

### cv::CascadeClassifier::load

```cpp
bool cv::CascadeClassifier::load( const std::string& filename )

AutoIt:
    $oCascadeClassifier.load( $filename ) -> retval
```

### cv::CascadeClassifier::read

```cpp
bool cv::CascadeClassifier::read( const cv::FileNode& node )

AutoIt:
    $oCascadeClassifier.read( $node ) -> retval
```

### cv::CascadeClassifier::detectMultiScale

```cpp
void cv::CascadeClassifier::detectMultiScale( _InputArray            image,
                                              std::vector<cv::Rect>& objects,
                                              double                 scaleFactor = 1.1,
                                              int                    minNeighbors = 3,
                                              int                    flags = 0,
                                              cv::Size               minSize = Size(),
                                              cv::Size               maxSize = Size() )

AutoIt:
    $oCascadeClassifier.detectMultiScale( $image[, $scaleFactor[, $minNeighbors[, $flags[, $minSize[, $maxSize[, $objects]]]]]] ) -> $objects
```

### cv::CascadeClassifier::detectMultiScale2

```cpp
void cv::CascadeClassifier::detectMultiScale2( _InputArray            image,
                                               std::vector<cv::Rect>& objects,
                                               std::vector<int>&      numDetections,
                                               double                 scaleFactor = 1.1,
                                               int                    minNeighbors = 3,
                                               int                    flags = 0,
                                               cv::Size               minSize = Size(),
                                               cv::Size               maxSize = Size() )

AutoIt:
    $oCascadeClassifier.detectMultiScale2( $image[, $scaleFactor[, $minNeighbors[, $flags[, $minSize[, $maxSize[, $objects[, $numDetections]]]]]]] ) -> $objects, $numDetections
```

### cv::CascadeClassifier::detectMultiScale3

```cpp
void cv::CascadeClassifier::detectMultiScale3( _InputArray            image,
                                               std::vector<cv::Rect>& objects,
                                               std::vector<int>&      rejectLevels,
                                               std::vector<double>&   levelWeights,
                                               double                 scaleFactor = 1.1,
                                               int                    minNeighbors = 3,
                                               int                    flags = 0,
                                               cv::Size               minSize = Size(),
                                               cv::Size               maxSize = Size(),
                                               bool                   outputRejectLevels = false )

AutoIt:
    $oCascadeClassifier.detectMultiScale3( $image[, $scaleFactor[, $minNeighbors[, $flags[, $minSize[, $maxSize[, $outputRejectLevels[, $objects[, $rejectLevels[, $levelWeights]]]]]]]]] ) -> $objects, $rejectLevels, $levelWeights
```

### cv::CascadeClassifier::isOldFormatCascade

```cpp
bool cv::CascadeClassifier::isOldFormatCascade()

AutoIt:
    $oCascadeClassifier.isOldFormatCascade() -> retval
```

### cv::CascadeClassifier::getOriginalWindowSize

```cpp
cv::Size cv::CascadeClassifier::getOriginalWindowSize()

AutoIt:
    $oCascadeClassifier.getOriginalWindowSize() -> retval
```

### cv::CascadeClassifier::getFeatureType

```cpp
int cv::CascadeClassifier::getFeatureType()

AutoIt:
    $oCascadeClassifier.getFeatureType() -> retval
```

### cv::CascadeClassifier::convert

```cpp
static bool cv::CascadeClassifier::convert( const std::string& oldcascade,
                                            const std::string& newcascade )

AutoIt:
    _OpenCV_ObjCreate("cv.CascadeClassifier").convert( $oldcascade, $newcascade ) -> retval
```

## cv::HOGDescriptor

### cv::HOGDescriptor::create

```cpp
static cv::HOGDescriptor cv::HOGDescriptor::create()

AutoIt:
    _OpenCV_ObjCreate("cv.HOGDescriptor").create() -> <cv.HOGDescriptor object>
```

```cpp
static cv::HOGDescriptor cv::HOGDescriptor::create()

AutoIt:
    _OpenCV_ObjCreate("cv.HOGDescriptor").create() -> <cv.HOGDescriptor object>
```

```cpp
static cv::HOGDescriptor cv::HOGDescriptor::create( cv::Size _winSize,
                                                    cv::Size _blockSize,
                                                    cv::Size _blockStride,
                                                    cv::Size _cellSize,
                                                    int      _nbins,
                                                    int      _derivAperture = 1,
                                                    double   _winSigma = -1,
                                                    int      _histogramNormType = HOGDescriptor::L2Hys,
                                                    double   _L2HysThreshold = 0.2,
                                                    bool     _gammaCorrection = false,
                                                    int      _nlevels = HOGDescriptor::DEFAULT_NLEVELS,
                                                    bool     _signedGradient = false )

AutoIt:
    _OpenCV_ObjCreate("cv.HOGDescriptor").create( $_winSize, $_blockSize, $_blockStride, $_cellSize, $_nbins[, $_derivAperture[, $_winSigma[, $_histogramNormType[, $_L2HysThreshold[, $_gammaCorrection[, $_nlevels[, $_signedGradient]]]]]]] ) -> <cv.HOGDescriptor object>
```

```cpp
static cv::HOGDescriptor cv::HOGDescriptor::create( const std::string& filename )

AutoIt:
    _OpenCV_ObjCreate("cv.HOGDescriptor").create( $filename ) -> <cv.HOGDescriptor object>
```

### cv::HOGDescriptor::getDescriptorSize

```cpp
size_t cv::HOGDescriptor::getDescriptorSize()

AutoIt:
    $oHOGDescriptor.getDescriptorSize() -> retval
```

### cv::HOGDescriptor::checkDetectorSize

```cpp
bool cv::HOGDescriptor::checkDetectorSize()

AutoIt:
    $oHOGDescriptor.checkDetectorSize() -> retval
```

### cv::HOGDescriptor::getWinSigma

```cpp
double cv::HOGDescriptor::getWinSigma()

AutoIt:
    $oHOGDescriptor.getWinSigma() -> retval
```

### cv::HOGDescriptor::setSVMDetector

```cpp
void cv::HOGDescriptor::setSVMDetector( _InputArray svmdetector )

AutoIt:
    $oHOGDescriptor.setSVMDetector( $svmdetector ) -> None
```

### cv::HOGDescriptor::load

```cpp
bool cv::HOGDescriptor::load( const std::string& filename,
                              const std::string& objname = String() )

AutoIt:
    $oHOGDescriptor.load( $filename[, $objname] ) -> retval
```

### cv::HOGDescriptor::save

```cpp
void cv::HOGDescriptor::save( const std::string& filename,
                              const std::string& objname = String() )

AutoIt:
    $oHOGDescriptor.save( $filename[, $objname] ) -> None
```

### cv::HOGDescriptor::compute

```cpp
void cv::HOGDescriptor::compute( _InputArray                   img,
                                 std::vector<float>&           descriptors,
                                 cv::Size                      winStride = Size(),
                                 cv::Size                      padding = Size(),
                                 const std::vector<cv::Point>& locations = std::vector<Point>() )

AutoIt:
    $oHOGDescriptor.compute( $img[, $winStride[, $padding[, $locations[, $descriptors]]]] ) -> $descriptors
```

### cv::HOGDescriptor::detect

```cpp
void cv::HOGDescriptor::detect( _InputArray                   img,
                                std::vector<cv::Point>&       foundLocations,
                                std::vector<double>&          weights,
                                double                        hitThreshold = 0,
                                cv::Size                      winStride = Size(),
                                cv::Size                      padding = Size(),
                                const std::vector<cv::Point>& searchLocations = std::vector<Point>() )

AutoIt:
    $oHOGDescriptor.detect( $img[, $hitThreshold[, $winStride[, $padding[, $searchLocations[, $foundLocations[, $weights]]]]]] ) -> $foundLocations, $weights
```

### cv::HOGDescriptor::detectMultiScale

```cpp
void cv::HOGDescriptor::detectMultiScale( _InputArray            img,
                                          std::vector<cv::Rect>& foundLocations,
                                          std::vector<double>&   foundWeights,
                                          double                 hitThreshold = 0,
                                          cv::Size               winStride = Size(),
                                          cv::Size               padding = Size(),
                                          double                 scale = 1.05,
                                          double                 finalThreshold = 2.0,
                                          bool                   useMeanshiftGrouping = false )

AutoIt:
    $oHOGDescriptor.detectMultiScale( $img[, $hitThreshold[, $winStride[, $padding[, $scale[, $finalThreshold[, $useMeanshiftGrouping[, $foundLocations[, $foundWeights]]]]]]]] ) -> $foundLocations, $foundWeights
```

### cv::HOGDescriptor::computeGradient

```cpp
void cv::HOGDescriptor::computeGradient( _InputArray       img,
                                         _InputOutputArray grad,
                                         _InputOutputArray angleOfs,
                                         cv::Size          paddingTL = Size(),
                                         cv::Size          paddingBR = Size() )

AutoIt:
    $oHOGDescriptor.computeGradient( $img, $grad, $angleOfs[, $paddingTL[, $paddingBR]] ) -> $grad, $angleOfs
```

### cv::HOGDescriptor::getDefaultPeopleDetector

```cpp
static std::vector<float> cv::HOGDescriptor::getDefaultPeopleDetector()

AutoIt:
    _OpenCV_ObjCreate("cv.HOGDescriptor").getDefaultPeopleDetector() -> retval
```

### cv::HOGDescriptor::getDaimlerPeopleDetector

```cpp
static std::vector<float> cv::HOGDescriptor::getDaimlerPeopleDetector()

AutoIt:
    _OpenCV_ObjCreate("cv.HOGDescriptor").getDaimlerPeopleDetector() -> retval
```

## cv::QRCodeEncoder

### cv::QRCodeEncoder::create

```cpp
static cv::Ptr<cv::QRCodeEncoder> cv::QRCodeEncoder::create( const cv::QRCodeEncoder::Params& parameters = QRCodeEncoder::Params() )

AutoIt:
    _OpenCV_ObjCreate("cv.QRCodeEncoder").create( [$parameters] ) -> retval
```

### cv::QRCodeEncoder::encode

```cpp
void cv::QRCodeEncoder::encode( const std::string& encoded_info,
                                _OutputArray       qrcode )

AutoIt:
    $oQRCodeEncoder.encode( $encoded_info[, $qrcode] ) -> $qrcode
```

### cv::QRCodeEncoder::encodeStructuredAppend

```cpp
void cv::QRCodeEncoder::encodeStructuredAppend( const std::string& encoded_info,
                                                _OutputArray       qrcodes )

AutoIt:
    $oQRCodeEncoder.encodeStructuredAppend( $encoded_info[, $qrcodes] ) -> $qrcodes
```

## cv::QRCodeEncoder::Params

### cv::QRCodeEncoder::Params::create

```cpp
static cv::QRCodeEncoder::Params cv::QRCodeEncoder::Params::create()

AutoIt:
    _OpenCV_ObjCreate("cv.QRCodeEncoder.Params").create() -> <cv.QRCodeEncoder.Params object>
```

```cpp
static cv::QRCodeEncoder::Params cv::QRCodeEncoder::Params::create()

AutoIt:
    _OpenCV_ObjCreate("cv.QRCodeEncoder.Params").create() -> <cv.QRCodeEncoder.Params object>
```

## cv::QRCodeDetector

### cv::QRCodeDetector::create

```cpp
static cv::QRCodeDetector cv::QRCodeDetector::create()

AutoIt:
    _OpenCV_ObjCreate("cv.QRCodeDetector").create() -> <cv.QRCodeDetector object>
```

### cv::QRCodeDetector::setEpsX

```cpp
void cv::QRCodeDetector::setEpsX( double epsX )

AutoIt:
    $oQRCodeDetector.setEpsX( $epsX ) -> None
```

### cv::QRCodeDetector::setEpsY

```cpp
void cv::QRCodeDetector::setEpsY( double epsY )

AutoIt:
    $oQRCodeDetector.setEpsY( $epsY ) -> None
```

### cv::QRCodeDetector::detect

```cpp
bool cv::QRCodeDetector::detect( _InputArray  img,
                                 _OutputArray points )

AutoIt:
    $oQRCodeDetector.detect( $img[, $points] ) -> retval, $points
```

### cv::QRCodeDetector::decode

```cpp
std::string cv::QRCodeDetector::decode( _InputArray  img,
                                        _InputArray  points,
                                        _OutputArray straight_qrcode = noArray() )

AutoIt:
    $oQRCodeDetector.decode( $img, $points[, $straight_qrcode] ) -> retval, $straight_qrcode
```

### cv::QRCodeDetector::decodeCurved

```cpp
std::string cv::QRCodeDetector::decodeCurved( _InputArray  img,
                                              _InputArray  points,
                                              _OutputArray straight_qrcode = noArray() )

AutoIt:
    $oQRCodeDetector.decodeCurved( $img, $points[, $straight_qrcode] ) -> retval, $straight_qrcode
```

### cv::QRCodeDetector::detectAndDecode

```cpp
std::string cv::QRCodeDetector::detectAndDecode( _InputArray  img,
                                                 _OutputArray points = noArray(),
                                                 _OutputArray straight_qrcode = noArray() )

AutoIt:
    $oQRCodeDetector.detectAndDecode( $img[, $points[, $straight_qrcode]] ) -> retval, $points, $straight_qrcode
```

### cv::QRCodeDetector::detectAndDecodeCurved

```cpp
std::string cv::QRCodeDetector::detectAndDecodeCurved( _InputArray  img,
                                                       _OutputArray points = noArray(),
                                                       _OutputArray straight_qrcode = noArray() )

AutoIt:
    $oQRCodeDetector.detectAndDecodeCurved( $img[, $points[, $straight_qrcode]] ) -> retval, $points, $straight_qrcode
```

### cv::QRCodeDetector::detectMulti

```cpp
bool cv::QRCodeDetector::detectMulti( _InputArray  img,
                                      _OutputArray points )

AutoIt:
    $oQRCodeDetector.detectMulti( $img[, $points] ) -> retval, $points
```

### cv::QRCodeDetector::decodeMulti

```cpp
bool cv::QRCodeDetector::decodeMulti( _InputArray               img,
                                      _InputArray               points,
                                      std::vector<std::string>& decoded_info,
                                      _OutputArray              straight_qrcode = noArray() )

AutoIt:
    $oQRCodeDetector.decodeMulti( $img, $points[, $straight_qrcode[, $decoded_info]] ) -> retval, $decoded_info, $straight_qrcode
```

### cv::QRCodeDetector::detectAndDecodeMulti

```cpp
bool cv::QRCodeDetector::detectAndDecodeMulti( _InputArray               img,
                                               std::vector<std::string>& decoded_info,
                                               _OutputArray              points = noArray(),
                                               _OutputArray              straight_qrcode = noArray() )

AutoIt:
    $oQRCodeDetector.detectAndDecodeMulti( $img[, $points[, $straight_qrcode[, $decoded_info]]] ) -> retval, $decoded_info, $points, $straight_qrcode
```

## cv::FaceDetectorYN

### cv::FaceDetectorYN::setInputSize

```cpp
void cv::FaceDetectorYN::setInputSize( const cv::Size& input_size )

AutoIt:
    $oFaceDetectorYN.setInputSize( $input_size ) -> None
```

### cv::FaceDetectorYN::getInputSize

```cpp
cv::Size cv::FaceDetectorYN::getInputSize()

AutoIt:
    $oFaceDetectorYN.getInputSize() -> retval
```

### cv::FaceDetectorYN::setScoreThreshold

```cpp
void cv::FaceDetectorYN::setScoreThreshold( float score_threshold )

AutoIt:
    $oFaceDetectorYN.setScoreThreshold( $score_threshold ) -> None
```

### cv::FaceDetectorYN::getScoreThreshold

```cpp
float cv::FaceDetectorYN::getScoreThreshold()

AutoIt:
    $oFaceDetectorYN.getScoreThreshold() -> retval
```

### cv::FaceDetectorYN::setNMSThreshold

```cpp
void cv::FaceDetectorYN::setNMSThreshold( float nms_threshold )

AutoIt:
    $oFaceDetectorYN.setNMSThreshold( $nms_threshold ) -> None
```

### cv::FaceDetectorYN::getNMSThreshold

```cpp
float cv::FaceDetectorYN::getNMSThreshold()

AutoIt:
    $oFaceDetectorYN.getNMSThreshold() -> retval
```

### cv::FaceDetectorYN::setTopK

```cpp
void cv::FaceDetectorYN::setTopK( int top_k )

AutoIt:
    $oFaceDetectorYN.setTopK( $top_k ) -> None
```

### cv::FaceDetectorYN::getTopK

```cpp
int cv::FaceDetectorYN::getTopK()

AutoIt:
    $oFaceDetectorYN.getTopK() -> retval
```

### cv::FaceDetectorYN::detect

```cpp
int cv::FaceDetectorYN::detect( _InputArray  image,
                                _OutputArray faces )

AutoIt:
    $oFaceDetectorYN.detect( $image[, $faces] ) -> retval, $faces
```

### cv::FaceDetectorYN::create

```cpp
static cv::Ptr<cv::FaceDetectorYN> cv::FaceDetectorYN::create( const std::string& model,
                                                               const std::string& config,
                                                               const cv::Size&    input_size,
                                                               float              score_threshold = 0.9f,
                                                               float              nms_threshold = 0.3f,
                                                               int                top_k = 5000,
                                                               int                backend_id = 0,
                                                               int                target_id = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv.FaceDetectorYN").create( $model, $config, $input_size[, $score_threshold[, $nms_threshold[, $top_k[, $backend_id[, $target_id]]]]] ) -> retval
```

## cv::FaceRecognizerSF

### cv::FaceRecognizerSF::alignCrop

```cpp
void cv::FaceRecognizerSF::alignCrop( _InputArray  src_img,
                                      _InputArray  face_box,
                                      _OutputArray aligned_img )

AutoIt:
    $oFaceRecognizerSF.alignCrop( $src_img, $face_box[, $aligned_img] ) -> $aligned_img
```

### cv::FaceRecognizerSF::feature

```cpp
void cv::FaceRecognizerSF::feature( _InputArray  aligned_img,
                                    _OutputArray face_feature )

AutoIt:
    $oFaceRecognizerSF.feature( $aligned_img[, $face_feature] ) -> $face_feature
```

### cv::FaceRecognizerSF::match

```cpp
double cv::FaceRecognizerSF::match( _InputArray _face_feature1,
                                    _InputArray _face_feature2,
                                    int         dis_type = FaceRecognizerSF::FR_COSINE )

AutoIt:
    $oFaceRecognizerSF.match( $_face_feature1, $_face_feature2[, $dis_type] ) -> retval
```

### cv::FaceRecognizerSF::create

```cpp
static cv::Ptr<cv::FaceRecognizerSF> cv::FaceRecognizerSF::create( const std::string& model,
                                                                   const std::string& config,
                                                                   int                backend_id = 0,
                                                                   int                target_id = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv.FaceRecognizerSF").create( $model, $config[, $backend_id[, $target_id]] ) -> retval
```

## cv::Stitcher

### cv::Stitcher::create

```cpp
static cv::Ptr<cv::Stitcher> cv::Stitcher::create( int mode = Stitcher::PANORAMA )

AutoIt:
    _OpenCV_ObjCreate("cv.Stitcher").create( [$mode] ) -> retval
```

### cv::Stitcher::registrationResol

```cpp
double cv::Stitcher::registrationResol()

AutoIt:
    $oStitcher.registrationResol() -> retval
```

### cv::Stitcher::setRegistrationResol

```cpp
void cv::Stitcher::setRegistrationResol( double resol_mpx )

AutoIt:
    $oStitcher.setRegistrationResol( $resol_mpx ) -> None
```

### cv::Stitcher::seamEstimationResol

```cpp
double cv::Stitcher::seamEstimationResol()

AutoIt:
    $oStitcher.seamEstimationResol() -> retval
```

### cv::Stitcher::setSeamEstimationResol

```cpp
void cv::Stitcher::setSeamEstimationResol( double resol_mpx )

AutoIt:
    $oStitcher.setSeamEstimationResol( $resol_mpx ) -> None
```

### cv::Stitcher::compositingResol

```cpp
double cv::Stitcher::compositingResol()

AutoIt:
    $oStitcher.compositingResol() -> retval
```

### cv::Stitcher::setCompositingResol

```cpp
void cv::Stitcher::setCompositingResol( double resol_mpx )

AutoIt:
    $oStitcher.setCompositingResol( $resol_mpx ) -> None
```

### cv::Stitcher::panoConfidenceThresh

```cpp
double cv::Stitcher::panoConfidenceThresh()

AutoIt:
    $oStitcher.panoConfidenceThresh() -> retval
```

### cv::Stitcher::setPanoConfidenceThresh

```cpp
void cv::Stitcher::setPanoConfidenceThresh( double conf_thresh )

AutoIt:
    $oStitcher.setPanoConfidenceThresh( $conf_thresh ) -> None
```

### cv::Stitcher::waveCorrection

```cpp
bool cv::Stitcher::waveCorrection()

AutoIt:
    $oStitcher.waveCorrection() -> retval
```

### cv::Stitcher::setWaveCorrection

```cpp
void cv::Stitcher::setWaveCorrection( bool flag )

AutoIt:
    $oStitcher.setWaveCorrection( $flag ) -> None
```

### cv::Stitcher::interpolationFlags

```cpp
int cv::Stitcher::interpolationFlags()

AutoIt:
    $oStitcher.interpolationFlags() -> retval
```

### cv::Stitcher::setInterpolationFlags

```cpp
void cv::Stitcher::setInterpolationFlags( int interp_flags )

AutoIt:
    $oStitcher.setInterpolationFlags( $interp_flags ) -> None
```

### cv::Stitcher::estimateTransform

```cpp
int cv::Stitcher::estimateTransform( _InputArray images,
                                     _InputArray masks = noArray() )

AutoIt:
    $oStitcher.estimateTransform( $images[, $masks] ) -> retval
```

### cv::Stitcher::composePanorama

```cpp
int cv::Stitcher::composePanorama( _OutputArray pano )

AutoIt:
    $oStitcher.composePanorama( [$pano] ) -> retval, $pano
```

```cpp
int cv::Stitcher::composePanorama( _InputArray  images,
                                   _OutputArray pano )

AutoIt:
    $oStitcher.composePanorama( $images[, $pano] ) -> retval, $pano
```

### cv::Stitcher::stitch

```cpp
int cv::Stitcher::stitch( _InputArray  images,
                          _OutputArray pano )

AutoIt:
    $oStitcher.stitch( $images[, $pano] ) -> retval, $pano
```

```cpp
int cv::Stitcher::stitch( _InputArray  images,
                          _InputArray  masks,
                          _OutputArray pano )

AutoIt:
    $oStitcher.stitch( $images, $masks[, $pano] ) -> retval, $pano
```

### cv::Stitcher::workScale

```cpp
double cv::Stitcher::workScale()

AutoIt:
    $oStitcher.workScale() -> retval
```

## cv::PyRotationWarper

### cv::PyRotationWarper::create

```cpp
static cv::PyRotationWarper cv::PyRotationWarper::create( std::string type,
                                                          float       scale )

AutoIt:
    _OpenCV_ObjCreate("cv.PyRotationWarper").create( $type, $scale ) -> <cv.PyRotationWarper object>
```

```cpp
static cv::PyRotationWarper cv::PyRotationWarper::create()

AutoIt:
    _OpenCV_ObjCreate("cv.PyRotationWarper").create() -> <cv.PyRotationWarper object>
```

### cv::PyRotationWarper::warpPoint

```cpp
cv::Point2f cv::PyRotationWarper::warpPoint( const cv::Point2f& pt,
                                             _InputArray        K,
                                             _InputArray        R )

AutoIt:
    $oPyRotationWarper.warpPoint( $pt, $K, $R ) -> retval
```

### cv::PyRotationWarper::warpPointBackward

```cpp
cv::Point2f cv::PyRotationWarper::warpPointBackward( const cv::Point2f& pt,
                                                     _InputArray        K,
                                                     _InputArray        R )

AutoIt:
    $oPyRotationWarper.warpPointBackward( $pt, $K, $R ) -> retval
```

```cpp
cv::Point2f cv::PyRotationWarper::warpPointBackward( const cv::Point2f& pt,
                                                     _InputArray        K,
                                                     _InputArray        R )

AutoIt:
    $oPyRotationWarper.warpPointBackward( $pt, $K, $R ) -> retval
```

### cv::PyRotationWarper::buildMaps

```cpp
cv::Rect cv::PyRotationWarper::buildMaps( cv::Size     src_size,
                                          _InputArray  K,
                                          _InputArray  R,
                                          _OutputArray xmap,
                                          _OutputArray ymap )

AutoIt:
    $oPyRotationWarper.buildMaps( $src_size, $K, $R[, $xmap[, $ymap]] ) -> retval, $xmap, $ymap
```

### cv::PyRotationWarper::warp

```cpp
cv::Point cv::PyRotationWarper::warp( _InputArray  src,
                                      _InputArray  K,
                                      _InputArray  R,
                                      int          interp_mode,
                                      int          border_mode,
                                      _OutputArray dst )

AutoIt:
    $oPyRotationWarper.warp( $src, $K, $R, $interp_mode, $border_mode[, $dst] ) -> retval, $dst
```

### cv::PyRotationWarper::warpBackward

```cpp
void cv::PyRotationWarper::warpBackward( _InputArray  src,
                                         _InputArray  K,
                                         _InputArray  R,
                                         int          interp_mode,
                                         int          border_mode,
                                         cv::Size     dst_size,
                                         _OutputArray dst )

AutoIt:
    $oPyRotationWarper.warpBackward( $src, $K, $R, $interp_mode, $border_mode, $dst_size[, $dst] ) -> $dst
```

### cv::PyRotationWarper::warpRoi

```cpp
cv::Rect cv::PyRotationWarper::warpRoi( cv::Size    src_size,
                                        _InputArray K,
                                        _InputArray R )

AutoIt:
    $oPyRotationWarper.warpRoi( $src_size, $K, $R ) -> retval
```

### cv::PyRotationWarper::getScale

```cpp
float cv::PyRotationWarper::getScale()

AutoIt:
    $oPyRotationWarper.getScale() -> retval
```

### cv::PyRotationWarper::setScale

```cpp
void cv::PyRotationWarper::setScale( float arg1 )

AutoIt:
    $oPyRotationWarper.setScale( $arg1 ) -> None
```

## cv::detail::Blender

### cv::detail::Blender::createDefault

```cpp
static cv::Ptr<cv::detail::Blender> cv::detail::Blender::createDefault( int  type,
                                                                        bool try_gpu = false )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.Blender").createDefault( $type[, $try_gpu] ) -> retval
```

### cv::detail::Blender::prepare

```cpp
void cv::detail::Blender::prepare( const std::vector<cv::Point>& corners,
                                   const std::vector<cv::Size>&  sizes )

AutoIt:
    $oBlender.prepare( $corners, $sizes ) -> None
```

```cpp
void cv::detail::Blender::prepare( cv::Rect dst_roi )

AutoIt:
    $oBlender.prepare( $dst_roi ) -> None
```

### cv::detail::Blender::feed

```cpp
void cv::detail::Blender::feed( _InputArray img,
                                _InputArray mask,
                                cv::Point   tl )

AutoIt:
    $oBlender.feed( $img, $mask, $tl ) -> None
```

### cv::detail::Blender::blend

```cpp
void cv::detail::Blender::blend( _InputOutputArray dst,
                                 _InputOutputArray dst_mask )

AutoIt:
    $oBlender.blend( $dst, $dst_mask ) -> $dst, $dst_mask
```

## cv::detail::FeatherBlender

### cv::detail::FeatherBlender::create

```cpp
static cv::detail::FeatherBlender cv::detail::FeatherBlender::create( float sharpness = 0.02f )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.FeatherBlender").create( [$sharpness] ) -> <cv.detail.FeatherBlender object>
```

### cv::detail::FeatherBlender::sharpness

```cpp
float cv::detail::FeatherBlender::sharpness()

AutoIt:
    $oFeatherBlender.sharpness() -> retval
```

### cv::detail::FeatherBlender::setSharpness

```cpp
void cv::detail::FeatherBlender::setSharpness( float val )

AutoIt:
    $oFeatherBlender.setSharpness( $val ) -> None
```

### cv::detail::FeatherBlender::prepare

```cpp
void cv::detail::FeatherBlender::prepare( cv::Rect dst_roi )

AutoIt:
    $oFeatherBlender.prepare( $dst_roi ) -> None
```

```cpp
void cv::detail::FeatherBlender::prepare( const std::vector<cv::Point>& corners,
                                          const std::vector<cv::Size>&  sizes )

AutoIt:
    $oFeatherBlender.prepare( $corners, $sizes ) -> None
```

### cv::detail::FeatherBlender::feed

```cpp
void cv::detail::FeatherBlender::feed( _InputArray img,
                                       _InputArray mask,
                                       cv::Point   tl )

AutoIt:
    $oFeatherBlender.feed( $img, $mask, $tl ) -> None
```

### cv::detail::FeatherBlender::blend

```cpp
void cv::detail::FeatherBlender::blend( _InputOutputArray dst,
                                        _InputOutputArray dst_mask )

AutoIt:
    $oFeatherBlender.blend( $dst, $dst_mask ) -> $dst, $dst_mask
```

### cv::detail::FeatherBlender::createWeightMaps

```cpp
cv::Rect cv::detail::FeatherBlender::createWeightMaps( const std::vector<cv::UMat>&  masks,
                                                       const std::vector<cv::Point>& corners,
                                                       std::vector<cv::UMat>&        weight_maps )

AutoIt:
    $oFeatherBlender.createWeightMaps( $masks, $corners, $weight_maps ) -> retval, $weight_maps
```

### cv::detail::FeatherBlender::createDefault

```cpp
static cv::Ptr<cv::detail::Blender> cv::detail::FeatherBlender::createDefault( int  type,
                                                                               bool try_gpu = false )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.FeatherBlender").createDefault( $type[, $try_gpu] ) -> retval
```

## cv::detail::MultiBandBlender

### cv::detail::MultiBandBlender::create

```cpp
static cv::detail::MultiBandBlender cv::detail::MultiBandBlender::create( int try_gpu = false,
                                                                          int num_bands = 5,
                                                                          int weight_type = CV_32F )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.MultiBandBlender").create( [$try_gpu[, $num_bands[, $weight_type]]] ) -> <cv.detail.MultiBandBlender object>
```

### cv::detail::MultiBandBlender::numBands

```cpp
int cv::detail::MultiBandBlender::numBands()

AutoIt:
    $oMultiBandBlender.numBands() -> retval
```

### cv::detail::MultiBandBlender::setNumBands

```cpp
void cv::detail::MultiBandBlender::setNumBands( int val )

AutoIt:
    $oMultiBandBlender.setNumBands( $val ) -> None
```

### cv::detail::MultiBandBlender::prepare

```cpp
void cv::detail::MultiBandBlender::prepare( cv::Rect dst_roi )

AutoIt:
    $oMultiBandBlender.prepare( $dst_roi ) -> None
```

```cpp
void cv::detail::MultiBandBlender::prepare( const std::vector<cv::Point>& corners,
                                            const std::vector<cv::Size>&  sizes )

AutoIt:
    $oMultiBandBlender.prepare( $corners, $sizes ) -> None
```

### cv::detail::MultiBandBlender::feed

```cpp
void cv::detail::MultiBandBlender::feed( _InputArray img,
                                         _InputArray mask,
                                         cv::Point   tl )

AutoIt:
    $oMultiBandBlender.feed( $img, $mask, $tl ) -> None
```

### cv::detail::MultiBandBlender::blend

```cpp
void cv::detail::MultiBandBlender::blend( _InputOutputArray dst,
                                          _InputOutputArray dst_mask )

AutoIt:
    $oMultiBandBlender.blend( $dst, $dst_mask ) -> $dst, $dst_mask
```

### cv::detail::MultiBandBlender::createDefault

```cpp
static cv::Ptr<cv::detail::Blender> cv::detail::MultiBandBlender::createDefault( int  type,
                                                                                 bool try_gpu = false )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.MultiBandBlender").createDefault( $type[, $try_gpu] ) -> retval
```

## cv::detail::CameraParams

### cv::detail::CameraParams::create

```cpp
static cv::detail::CameraParams cv::detail::CameraParams::create()

AutoIt:
    _OpenCV_ObjCreate("cv.detail.CameraParams").create() -> <cv.detail.CameraParams object>
```

### cv::detail::CameraParams::K

```cpp
cv::Mat cv::detail::CameraParams::K()

AutoIt:
    $oCameraParams.K() -> retval
```

## cv::detail::ExposureCompensator

### cv::detail::ExposureCompensator::createDefault

```cpp
static cv::Ptr<cv::detail::ExposureCompensator> cv::detail::ExposureCompensator::createDefault( int type )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.ExposureCompensator").createDefault( $type ) -> retval
```

### cv::detail::ExposureCompensator::feed

```cpp
void cv::detail::ExposureCompensator::feed( const std::vector<cv::Point>& corners,
                                            const std::vector<cv::UMat>&  images,
                                            const std::vector<cv::UMat>&  masks )

AutoIt:
    $oExposureCompensator.feed( $corners, $images, $masks ) -> None
```

### cv::detail::ExposureCompensator::apply

```cpp
void cv::detail::ExposureCompensator::apply( int               index,
                                             cv::Point         corner,
                                             _InputOutputArray image,
                                             _InputArray       mask )

AutoIt:
    $oExposureCompensator.apply( $index, $corner, $image, $mask ) -> $image
```

### cv::detail::ExposureCompensator::getMatGains

```cpp
void cv::detail::ExposureCompensator::getMatGains( std::vector<cv::Mat>& arg1 )

AutoIt:
    $oExposureCompensator.getMatGains( [$arg1] ) -> $arg1
```

### cv::detail::ExposureCompensator::setMatGains

```cpp
void cv::detail::ExposureCompensator::setMatGains( std::vector<cv::Mat>& arg1 )

AutoIt:
    $oExposureCompensator.setMatGains( $arg1 ) -> None
```

### cv::detail::ExposureCompensator::setUpdateGain

```cpp
void cv::detail::ExposureCompensator::setUpdateGain( bool b )

AutoIt:
    $oExposureCompensator.setUpdateGain( $b ) -> None
```

### cv::detail::ExposureCompensator::getUpdateGain

```cpp
bool cv::detail::ExposureCompensator::getUpdateGain()

AutoIt:
    $oExposureCompensator.getUpdateGain() -> retval
```

## cv::detail::NoExposureCompensator

### cv::detail::NoExposureCompensator::apply

```cpp
void cv::detail::NoExposureCompensator::apply( int               arg1,
                                               cv::Point         arg2,
                                               _InputOutputArray arg3,
                                               _InputArray       arg4 )

AutoIt:
    $oNoExposureCompensator.apply( $arg1, $arg2, $arg3, $arg4 ) -> $arg3
```

### cv::detail::NoExposureCompensator::getMatGains

```cpp
void cv::detail::NoExposureCompensator::getMatGains( std::vector<cv::Mat>& umv )

AutoIt:
    $oNoExposureCompensator.getMatGains( [$umv] ) -> $umv
```

### cv::detail::NoExposureCompensator::setMatGains

```cpp
void cv::detail::NoExposureCompensator::setMatGains( std::vector<cv::Mat>& umv )

AutoIt:
    $oNoExposureCompensator.setMatGains( $umv ) -> None
```

### cv::detail::NoExposureCompensator::createDefault

```cpp
static cv::Ptr<cv::detail::ExposureCompensator> cv::detail::NoExposureCompensator::createDefault( int type )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.NoExposureCompensator").createDefault( $type ) -> retval
```

### cv::detail::NoExposureCompensator::feed

```cpp
void cv::detail::NoExposureCompensator::feed( const std::vector<cv::Point>& corners,
                                              const std::vector<cv::UMat>&  images,
                                              const std::vector<cv::UMat>&  masks )

AutoIt:
    $oNoExposureCompensator.feed( $corners, $images, $masks ) -> None
```

### cv::detail::NoExposureCompensator::setUpdateGain

```cpp
void cv::detail::NoExposureCompensator::setUpdateGain( bool b )

AutoIt:
    $oNoExposureCompensator.setUpdateGain( $b ) -> None
```

### cv::detail::NoExposureCompensator::getUpdateGain

```cpp
bool cv::detail::NoExposureCompensator::getUpdateGain()

AutoIt:
    $oNoExposureCompensator.getUpdateGain() -> retval
```

## cv::detail::GainCompensator

### cv::detail::GainCompensator::create

```cpp
static cv::detail::GainCompensator cv::detail::GainCompensator::create()

AutoIt:
    _OpenCV_ObjCreate("cv.detail.GainCompensator").create() -> <cv.detail.GainCompensator object>
```

```cpp
static cv::detail::GainCompensator cv::detail::GainCompensator::create( int nr_feeds )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.GainCompensator").create( $nr_feeds ) -> <cv.detail.GainCompensator object>
```

### cv::detail::GainCompensator::apply

```cpp
void cv::detail::GainCompensator::apply( int               index,
                                         cv::Point         corner,
                                         _InputOutputArray image,
                                         _InputArray       mask )

AutoIt:
    $oGainCompensator.apply( $index, $corner, $image, $mask ) -> $image
```

### cv::detail::GainCompensator::getMatGains

```cpp
void cv::detail::GainCompensator::getMatGains( std::vector<cv::Mat>& umv )

AutoIt:
    $oGainCompensator.getMatGains( [$umv] ) -> $umv
```

### cv::detail::GainCompensator::setMatGains

```cpp
void cv::detail::GainCompensator::setMatGains( std::vector<cv::Mat>& umv )

AutoIt:
    $oGainCompensator.setMatGains( $umv ) -> None
```

### cv::detail::GainCompensator::setNrFeeds

```cpp
void cv::detail::GainCompensator::setNrFeeds( int nr_feeds )

AutoIt:
    $oGainCompensator.setNrFeeds( $nr_feeds ) -> None
```

### cv::detail::GainCompensator::getNrFeeds

```cpp
int cv::detail::GainCompensator::getNrFeeds()

AutoIt:
    $oGainCompensator.getNrFeeds() -> retval
```

### cv::detail::GainCompensator::setSimilarityThreshold

```cpp
void cv::detail::GainCompensator::setSimilarityThreshold( double similarity_threshold )

AutoIt:
    $oGainCompensator.setSimilarityThreshold( $similarity_threshold ) -> None
```

### cv::detail::GainCompensator::getSimilarityThreshold

```cpp
double cv::detail::GainCompensator::getSimilarityThreshold()

AutoIt:
    $oGainCompensator.getSimilarityThreshold() -> retval
```

### cv::detail::GainCompensator::createDefault

```cpp
static cv::Ptr<cv::detail::ExposureCompensator> cv::detail::GainCompensator::createDefault( int type )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.GainCompensator").createDefault( $type ) -> retval
```

### cv::detail::GainCompensator::feed

```cpp
void cv::detail::GainCompensator::feed( const std::vector<cv::Point>& corners,
                                        const std::vector<cv::UMat>&  images,
                                        const std::vector<cv::UMat>&  masks )

AutoIt:
    $oGainCompensator.feed( $corners, $images, $masks ) -> None
```

### cv::detail::GainCompensator::setUpdateGain

```cpp
void cv::detail::GainCompensator::setUpdateGain( bool b )

AutoIt:
    $oGainCompensator.setUpdateGain( $b ) -> None
```

### cv::detail::GainCompensator::getUpdateGain

```cpp
bool cv::detail::GainCompensator::getUpdateGain()

AutoIt:
    $oGainCompensator.getUpdateGain() -> retval
```

## cv::detail::ChannelsCompensator

### cv::detail::ChannelsCompensator::create

```cpp
static cv::detail::ChannelsCompensator cv::detail::ChannelsCompensator::create( int nr_feeds = 1 )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.ChannelsCompensator").create( [$nr_feeds] ) -> <cv.detail.ChannelsCompensator object>
```

### cv::detail::ChannelsCompensator::apply

```cpp
void cv::detail::ChannelsCompensator::apply( int               index,
                                             cv::Point         corner,
                                             _InputOutputArray image,
                                             _InputArray       mask )

AutoIt:
    $oChannelsCompensator.apply( $index, $corner, $image, $mask ) -> $image
```

### cv::detail::ChannelsCompensator::getMatGains

```cpp
void cv::detail::ChannelsCompensator::getMatGains( std::vector<cv::Mat>& umv )

AutoIt:
    $oChannelsCompensator.getMatGains( [$umv] ) -> $umv
```

### cv::detail::ChannelsCompensator::setMatGains

```cpp
void cv::detail::ChannelsCompensator::setMatGains( std::vector<cv::Mat>& umv )

AutoIt:
    $oChannelsCompensator.setMatGains( $umv ) -> None
```

### cv::detail::ChannelsCompensator::setNrFeeds

```cpp
void cv::detail::ChannelsCompensator::setNrFeeds( int nr_feeds )

AutoIt:
    $oChannelsCompensator.setNrFeeds( $nr_feeds ) -> None
```

### cv::detail::ChannelsCompensator::getNrFeeds

```cpp
int cv::detail::ChannelsCompensator::getNrFeeds()

AutoIt:
    $oChannelsCompensator.getNrFeeds() -> retval
```

### cv::detail::ChannelsCompensator::setSimilarityThreshold

```cpp
void cv::detail::ChannelsCompensator::setSimilarityThreshold( double similarity_threshold )

AutoIt:
    $oChannelsCompensator.setSimilarityThreshold( $similarity_threshold ) -> None
```

### cv::detail::ChannelsCompensator::getSimilarityThreshold

```cpp
double cv::detail::ChannelsCompensator::getSimilarityThreshold()

AutoIt:
    $oChannelsCompensator.getSimilarityThreshold() -> retval
```

### cv::detail::ChannelsCompensator::createDefault

```cpp
static cv::Ptr<cv::detail::ExposureCompensator> cv::detail::ChannelsCompensator::createDefault( int type )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.ChannelsCompensator").createDefault( $type ) -> retval
```

### cv::detail::ChannelsCompensator::feed

```cpp
void cv::detail::ChannelsCompensator::feed( const std::vector<cv::Point>& corners,
                                            const std::vector<cv::UMat>&  images,
                                            const std::vector<cv::UMat>&  masks )

AutoIt:
    $oChannelsCompensator.feed( $corners, $images, $masks ) -> None
```

### cv::detail::ChannelsCompensator::setUpdateGain

```cpp
void cv::detail::ChannelsCompensator::setUpdateGain( bool b )

AutoIt:
    $oChannelsCompensator.setUpdateGain( $b ) -> None
```

### cv::detail::ChannelsCompensator::getUpdateGain

```cpp
bool cv::detail::ChannelsCompensator::getUpdateGain()

AutoIt:
    $oChannelsCompensator.getUpdateGain() -> retval
```

## cv::detail::BlocksCompensator

### cv::detail::BlocksCompensator::apply

```cpp
void cv::detail::BlocksCompensator::apply( int               index,
                                           cv::Point         corner,
                                           _InputOutputArray image,
                                           _InputArray       mask )

AutoIt:
    $oBlocksCompensator.apply( $index, $corner, $image, $mask ) -> $image
```

### cv::detail::BlocksCompensator::getMatGains

```cpp
void cv::detail::BlocksCompensator::getMatGains( std::vector<cv::Mat>& umv )

AutoIt:
    $oBlocksCompensator.getMatGains( [$umv] ) -> $umv
```

### cv::detail::BlocksCompensator::setMatGains

```cpp
void cv::detail::BlocksCompensator::setMatGains( std::vector<cv::Mat>& umv )

AutoIt:
    $oBlocksCompensator.setMatGains( $umv ) -> None
```

### cv::detail::BlocksCompensator::setNrFeeds

```cpp
void cv::detail::BlocksCompensator::setNrFeeds( int nr_feeds )

AutoIt:
    $oBlocksCompensator.setNrFeeds( $nr_feeds ) -> None
```

### cv::detail::BlocksCompensator::getNrFeeds

```cpp
int cv::detail::BlocksCompensator::getNrFeeds()

AutoIt:
    $oBlocksCompensator.getNrFeeds() -> retval
```

### cv::detail::BlocksCompensator::setSimilarityThreshold

```cpp
void cv::detail::BlocksCompensator::setSimilarityThreshold( double similarity_threshold )

AutoIt:
    $oBlocksCompensator.setSimilarityThreshold( $similarity_threshold ) -> None
```

### cv::detail::BlocksCompensator::getSimilarityThreshold

```cpp
double cv::detail::BlocksCompensator::getSimilarityThreshold()

AutoIt:
    $oBlocksCompensator.getSimilarityThreshold() -> retval
```

### cv::detail::BlocksCompensator::setBlockSize

```cpp
void cv::detail::BlocksCompensator::setBlockSize( int width,
                                                  int height )

AutoIt:
    $oBlocksCompensator.setBlockSize( $width, $height ) -> None
```

```cpp
void cv::detail::BlocksCompensator::setBlockSize( cv::Size size )

AutoIt:
    $oBlocksCompensator.setBlockSize( $size ) -> None
```

### cv::detail::BlocksCompensator::getBlockSize

```cpp
cv::Size cv::detail::BlocksCompensator::getBlockSize()

AutoIt:
    $oBlocksCompensator.getBlockSize() -> retval
```

### cv::detail::BlocksCompensator::setNrGainsFilteringIterations

```cpp
void cv::detail::BlocksCompensator::setNrGainsFilteringIterations( int nr_iterations )

AutoIt:
    $oBlocksCompensator.setNrGainsFilteringIterations( $nr_iterations ) -> None
```

### cv::detail::BlocksCompensator::getNrGainsFilteringIterations

```cpp
int cv::detail::BlocksCompensator::getNrGainsFilteringIterations()

AutoIt:
    $oBlocksCompensator.getNrGainsFilteringIterations() -> retval
```

### cv::detail::BlocksCompensator::createDefault

```cpp
static cv::Ptr<cv::detail::ExposureCompensator> cv::detail::BlocksCompensator::createDefault( int type )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.BlocksCompensator").createDefault( $type ) -> retval
```

### cv::detail::BlocksCompensator::feed

```cpp
void cv::detail::BlocksCompensator::feed( const std::vector<cv::Point>& corners,
                                          const std::vector<cv::UMat>&  images,
                                          const std::vector<cv::UMat>&  masks )

AutoIt:
    $oBlocksCompensator.feed( $corners, $images, $masks ) -> None
```

### cv::detail::BlocksCompensator::setUpdateGain

```cpp
void cv::detail::BlocksCompensator::setUpdateGain( bool b )

AutoIt:
    $oBlocksCompensator.setUpdateGain( $b ) -> None
```

### cv::detail::BlocksCompensator::getUpdateGain

```cpp
bool cv::detail::BlocksCompensator::getUpdateGain()

AutoIt:
    $oBlocksCompensator.getUpdateGain() -> retval
```

## cv::detail::BlocksGainCompensator

### cv::detail::BlocksGainCompensator::create

```cpp
static cv::detail::BlocksGainCompensator cv::detail::BlocksGainCompensator::create( int bl_width = 32,
                                                                                    int bl_height = 32 )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.BlocksGainCompensator").create( [$bl_width[, $bl_height]] ) -> <cv.detail.BlocksGainCompensator object>
```

```cpp
static cv::detail::BlocksGainCompensator cv::detail::BlocksGainCompensator::create( int bl_width,
                                                                                    int bl_height,
                                                                                    int nr_feeds )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.BlocksGainCompensator").create( $bl_width, $bl_height, $nr_feeds ) -> <cv.detail.BlocksGainCompensator object>
```

### cv::detail::BlocksGainCompensator::apply

```cpp
void cv::detail::BlocksGainCompensator::apply( int               index,
                                               cv::Point         corner,
                                               _InputOutputArray image,
                                               _InputArray       mask )

AutoIt:
    $oBlocksGainCompensator.apply( $index, $corner, $image, $mask ) -> $image
```

### cv::detail::BlocksGainCompensator::getMatGains

```cpp
void cv::detail::BlocksGainCompensator::getMatGains( std::vector<cv::Mat>& umv )

AutoIt:
    $oBlocksGainCompensator.getMatGains( [$umv] ) -> $umv
```

### cv::detail::BlocksGainCompensator::setMatGains

```cpp
void cv::detail::BlocksGainCompensator::setMatGains( std::vector<cv::Mat>& umv )

AutoIt:
    $oBlocksGainCompensator.setMatGains( $umv ) -> None
```

### cv::detail::BlocksGainCompensator::setNrFeeds

```cpp
void cv::detail::BlocksGainCompensator::setNrFeeds( int nr_feeds )

AutoIt:
    $oBlocksGainCompensator.setNrFeeds( $nr_feeds ) -> None
```

### cv::detail::BlocksGainCompensator::getNrFeeds

```cpp
int cv::detail::BlocksGainCompensator::getNrFeeds()

AutoIt:
    $oBlocksGainCompensator.getNrFeeds() -> retval
```

### cv::detail::BlocksGainCompensator::setSimilarityThreshold

```cpp
void cv::detail::BlocksGainCompensator::setSimilarityThreshold( double similarity_threshold )

AutoIt:
    $oBlocksGainCompensator.setSimilarityThreshold( $similarity_threshold ) -> None
```

### cv::detail::BlocksGainCompensator::getSimilarityThreshold

```cpp
double cv::detail::BlocksGainCompensator::getSimilarityThreshold()

AutoIt:
    $oBlocksGainCompensator.getSimilarityThreshold() -> retval
```

### cv::detail::BlocksGainCompensator::setBlockSize

```cpp
void cv::detail::BlocksGainCompensator::setBlockSize( int width,
                                                      int height )

AutoIt:
    $oBlocksGainCompensator.setBlockSize( $width, $height ) -> None
```

```cpp
void cv::detail::BlocksGainCompensator::setBlockSize( cv::Size size )

AutoIt:
    $oBlocksGainCompensator.setBlockSize( $size ) -> None
```

### cv::detail::BlocksGainCompensator::getBlockSize

```cpp
cv::Size cv::detail::BlocksGainCompensator::getBlockSize()

AutoIt:
    $oBlocksGainCompensator.getBlockSize() -> retval
```

### cv::detail::BlocksGainCompensator::setNrGainsFilteringIterations

```cpp
void cv::detail::BlocksGainCompensator::setNrGainsFilteringIterations( int nr_iterations )

AutoIt:
    $oBlocksGainCompensator.setNrGainsFilteringIterations( $nr_iterations ) -> None
```

### cv::detail::BlocksGainCompensator::getNrGainsFilteringIterations

```cpp
int cv::detail::BlocksGainCompensator::getNrGainsFilteringIterations()

AutoIt:
    $oBlocksGainCompensator.getNrGainsFilteringIterations() -> retval
```

### cv::detail::BlocksGainCompensator::createDefault

```cpp
static cv::Ptr<cv::detail::ExposureCompensator> cv::detail::BlocksGainCompensator::createDefault( int type )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.BlocksGainCompensator").createDefault( $type ) -> retval
```

### cv::detail::BlocksGainCompensator::feed

```cpp
void cv::detail::BlocksGainCompensator::feed( const std::vector<cv::Point>& corners,
                                              const std::vector<cv::UMat>&  images,
                                              const std::vector<cv::UMat>&  masks )

AutoIt:
    $oBlocksGainCompensator.feed( $corners, $images, $masks ) -> None
```

### cv::detail::BlocksGainCompensator::setUpdateGain

```cpp
void cv::detail::BlocksGainCompensator::setUpdateGain( bool b )

AutoIt:
    $oBlocksGainCompensator.setUpdateGain( $b ) -> None
```

### cv::detail::BlocksGainCompensator::getUpdateGain

```cpp
bool cv::detail::BlocksGainCompensator::getUpdateGain()

AutoIt:
    $oBlocksGainCompensator.getUpdateGain() -> retval
```

## cv::detail::BlocksChannelsCompensator

### cv::detail::BlocksChannelsCompensator::create

```cpp
static cv::detail::BlocksChannelsCompensator cv::detail::BlocksChannelsCompensator::create( int bl_width = 32,
                                                                                            int bl_height = 32,
                                                                                            int nr_feeds = 1 )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.BlocksChannelsCompensator").create( [$bl_width[, $bl_height[, $nr_feeds]]] ) -> <cv.detail.BlocksChannelsCompensator object>
```

### cv::detail::BlocksChannelsCompensator::apply

```cpp
void cv::detail::BlocksChannelsCompensator::apply( int               index,
                                                   cv::Point         corner,
                                                   _InputOutputArray image,
                                                   _InputArray       mask )

AutoIt:
    $oBlocksChannelsCompensator.apply( $index, $corner, $image, $mask ) -> $image
```

### cv::detail::BlocksChannelsCompensator::getMatGains

```cpp
void cv::detail::BlocksChannelsCompensator::getMatGains( std::vector<cv::Mat>& umv )

AutoIt:
    $oBlocksChannelsCompensator.getMatGains( [$umv] ) -> $umv
```

### cv::detail::BlocksChannelsCompensator::setMatGains

```cpp
void cv::detail::BlocksChannelsCompensator::setMatGains( std::vector<cv::Mat>& umv )

AutoIt:
    $oBlocksChannelsCompensator.setMatGains( $umv ) -> None
```

### cv::detail::BlocksChannelsCompensator::setNrFeeds

```cpp
void cv::detail::BlocksChannelsCompensator::setNrFeeds( int nr_feeds )

AutoIt:
    $oBlocksChannelsCompensator.setNrFeeds( $nr_feeds ) -> None
```

### cv::detail::BlocksChannelsCompensator::getNrFeeds

```cpp
int cv::detail::BlocksChannelsCompensator::getNrFeeds()

AutoIt:
    $oBlocksChannelsCompensator.getNrFeeds() -> retval
```

### cv::detail::BlocksChannelsCompensator::setSimilarityThreshold

```cpp
void cv::detail::BlocksChannelsCompensator::setSimilarityThreshold( double similarity_threshold )

AutoIt:
    $oBlocksChannelsCompensator.setSimilarityThreshold( $similarity_threshold ) -> None
```

### cv::detail::BlocksChannelsCompensator::getSimilarityThreshold

```cpp
double cv::detail::BlocksChannelsCompensator::getSimilarityThreshold()

AutoIt:
    $oBlocksChannelsCompensator.getSimilarityThreshold() -> retval
```

### cv::detail::BlocksChannelsCompensator::setBlockSize

```cpp
void cv::detail::BlocksChannelsCompensator::setBlockSize( int width,
                                                          int height )

AutoIt:
    $oBlocksChannelsCompensator.setBlockSize( $width, $height ) -> None
```

```cpp
void cv::detail::BlocksChannelsCompensator::setBlockSize( cv::Size size )

AutoIt:
    $oBlocksChannelsCompensator.setBlockSize( $size ) -> None
```

### cv::detail::BlocksChannelsCompensator::getBlockSize

```cpp
cv::Size cv::detail::BlocksChannelsCompensator::getBlockSize()

AutoIt:
    $oBlocksChannelsCompensator.getBlockSize() -> retval
```

### cv::detail::BlocksChannelsCompensator::setNrGainsFilteringIterations

```cpp
void cv::detail::BlocksChannelsCompensator::setNrGainsFilteringIterations( int nr_iterations )

AutoIt:
    $oBlocksChannelsCompensator.setNrGainsFilteringIterations( $nr_iterations ) -> None
```

### cv::detail::BlocksChannelsCompensator::getNrGainsFilteringIterations

```cpp
int cv::detail::BlocksChannelsCompensator::getNrGainsFilteringIterations()

AutoIt:
    $oBlocksChannelsCompensator.getNrGainsFilteringIterations() -> retval
```

### cv::detail::BlocksChannelsCompensator::createDefault

```cpp
static cv::Ptr<cv::detail::ExposureCompensator> cv::detail::BlocksChannelsCompensator::createDefault( int type )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.BlocksChannelsCompensator").createDefault( $type ) -> retval
```

### cv::detail::BlocksChannelsCompensator::feed

```cpp
void cv::detail::BlocksChannelsCompensator::feed( const std::vector<cv::Point>& corners,
                                                  const std::vector<cv::UMat>&  images,
                                                  const std::vector<cv::UMat>&  masks )

AutoIt:
    $oBlocksChannelsCompensator.feed( $corners, $images, $masks ) -> None
```

### cv::detail::BlocksChannelsCompensator::setUpdateGain

```cpp
void cv::detail::BlocksChannelsCompensator::setUpdateGain( bool b )

AutoIt:
    $oBlocksChannelsCompensator.setUpdateGain( $b ) -> None
```

### cv::detail::BlocksChannelsCompensator::getUpdateGain

```cpp
bool cv::detail::BlocksChannelsCompensator::getUpdateGain()

AutoIt:
    $oBlocksChannelsCompensator.getUpdateGain() -> retval
```

## cv::detail::ImageFeatures

### cv::detail::ImageFeatures::create

```cpp
static cv::detail::ImageFeatures cv::detail::ImageFeatures::create()

AutoIt:
    _OpenCV_ObjCreate("cv.detail.ImageFeatures").create() -> <cv.detail.ImageFeatures object>
```

### cv::detail::ImageFeatures::getKeypoints

```cpp
std::vector<cv::KeyPoint> cv::detail::ImageFeatures::getKeypoints()

AutoIt:
    $oImageFeatures.getKeypoints() -> retval
```

## cv::detail::MatchesInfo

### cv::detail::MatchesInfo::create

```cpp
static cv::detail::MatchesInfo cv::detail::MatchesInfo::create()

AutoIt:
    _OpenCV_ObjCreate("cv.detail.MatchesInfo").create() -> <cv.detail.MatchesInfo object>
```

### cv::detail::MatchesInfo::getMatches

```cpp
std::vector<cv::DMatch> cv::detail::MatchesInfo::getMatches()

AutoIt:
    $oMatchesInfo.getMatches() -> retval
```

### cv::detail::MatchesInfo::getInliers

```cpp
std::vector<uchar> cv::detail::MatchesInfo::getInliers()

AutoIt:
    $oMatchesInfo.getInliers() -> retval
```

## cv::detail::FeaturesMatcher

### cv::detail::FeaturesMatcher::apply

```cpp
void cv::detail::FeaturesMatcher::apply( const cv::detail::ImageFeatures& features1,
                                         const cv::detail::ImageFeatures& features2,
                                         cv::detail::MatchesInfo&         matches_info )

AutoIt:
    $oFeaturesMatcher.apply( $features1, $features2[, $matches_info] ) -> $matches_info
```

### cv::detail::FeaturesMatcher::apply2

```cpp
void cv::detail::FeaturesMatcher::apply2( const std::vector<cv::detail::ImageFeatures>& features,
                                          std::vector<cv::detail::MatchesInfo>&         pairwise_matches,
                                          const cv::UMat&                               mask = cv::UMat() )

AutoIt:
    $oFeaturesMatcher.apply2( $features[, $mask[, $pairwise_matches]] ) -> $pairwise_matches
```

### cv::detail::FeaturesMatcher::isThreadSafe

```cpp
bool cv::detail::FeaturesMatcher::isThreadSafe()

AutoIt:
    $oFeaturesMatcher.isThreadSafe() -> retval
```

### cv::detail::FeaturesMatcher::collectGarbage

```cpp
void cv::detail::FeaturesMatcher::collectGarbage()

AutoIt:
    $oFeaturesMatcher.collectGarbage() -> None
```

## cv::detail::BestOf2NearestMatcher

### cv::detail::BestOf2NearestMatcher::create

```cpp
static cv::detail::BestOf2NearestMatcher cv::detail::BestOf2NearestMatcher::create( bool  try_use_gpu = false,
                                                                                    float match_conf = 0.3f,
                                                                                    int   num_matches_thresh1 = 6,
                                                                                    int   num_matches_thresh2 = 6 )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.BestOf2NearestMatcher").create( [$try_use_gpu[, $match_conf[, $num_matches_thresh1[, $num_matches_thresh2]]]] ) -> <cv.detail.BestOf2NearestMatcher object>
```

```cpp
static cv::Ptr<cv::detail::BestOf2NearestMatcher> cv::detail::BestOf2NearestMatcher::create( bool  try_use_gpu = false,
                                                                                             float match_conf = 0.3f,
                                                                                             int   num_matches_thresh1 = 6,
                                                                                             int   num_matches_thresh2 = 6 )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.BestOf2NearestMatcher").create( [$try_use_gpu[, $match_conf[, $num_matches_thresh1[, $num_matches_thresh2]]]] ) -> retval
```

### cv::detail::BestOf2NearestMatcher::collectGarbage

```cpp
void cv::detail::BestOf2NearestMatcher::collectGarbage()

AutoIt:
    $oBestOf2NearestMatcher.collectGarbage() -> None
```

### cv::detail::BestOf2NearestMatcher::apply

```cpp
void cv::detail::BestOf2NearestMatcher::apply( const cv::detail::ImageFeatures& features1,
                                               const cv::detail::ImageFeatures& features2,
                                               cv::detail::MatchesInfo&         matches_info )

AutoIt:
    $oBestOf2NearestMatcher.apply( $features1, $features2[, $matches_info] ) -> $matches_info
```

### cv::detail::BestOf2NearestMatcher::apply2

```cpp
void cv::detail::BestOf2NearestMatcher::apply2( const std::vector<cv::detail::ImageFeatures>& features,
                                                std::vector<cv::detail::MatchesInfo>&         pairwise_matches,
                                                const cv::UMat&                               mask = cv::UMat() )

AutoIt:
    $oBestOf2NearestMatcher.apply2( $features[, $mask[, $pairwise_matches]] ) -> $pairwise_matches
```

### cv::detail::BestOf2NearestMatcher::isThreadSafe

```cpp
bool cv::detail::BestOf2NearestMatcher::isThreadSafe()

AutoIt:
    $oBestOf2NearestMatcher.isThreadSafe() -> retval
```

## cv::detail::BestOf2NearestRangeMatcher

### cv::detail::BestOf2NearestRangeMatcher::create

```cpp
static cv::detail::BestOf2NearestRangeMatcher cv::detail::BestOf2NearestRangeMatcher::create( int   range_width = 5,
                                                                                              bool  try_use_gpu = false,
                                                                                              float match_conf = 0.3f,
                                                                                              int   num_matches_thresh1 = 6,
                                                                                              int   num_matches_thresh2 = 6 )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.BestOf2NearestRangeMatcher").create( [$range_width[, $try_use_gpu[, $match_conf[, $num_matches_thresh1[, $num_matches_thresh2]]]]] ) -> <cv.detail.BestOf2NearestRangeMatcher object>
```

### cv::detail::BestOf2NearestRangeMatcher::collectGarbage

```cpp
void cv::detail::BestOf2NearestRangeMatcher::collectGarbage()

AutoIt:
    $oBestOf2NearestRangeMatcher.collectGarbage() -> None
```

### cv::detail::BestOf2NearestRangeMatcher::apply

```cpp
void cv::detail::BestOf2NearestRangeMatcher::apply( const cv::detail::ImageFeatures& features1,
                                                    const cv::detail::ImageFeatures& features2,
                                                    cv::detail::MatchesInfo&         matches_info )

AutoIt:
    $oBestOf2NearestRangeMatcher.apply( $features1, $features2[, $matches_info] ) -> $matches_info
```

### cv::detail::BestOf2NearestRangeMatcher::apply2

```cpp
void cv::detail::BestOf2NearestRangeMatcher::apply2( const std::vector<cv::detail::ImageFeatures>& features,
                                                     std::vector<cv::detail::MatchesInfo>&         pairwise_matches,
                                                     const cv::UMat&                               mask = cv::UMat() )

AutoIt:
    $oBestOf2NearestRangeMatcher.apply2( $features[, $mask[, $pairwise_matches]] ) -> $pairwise_matches
```

### cv::detail::BestOf2NearestRangeMatcher::isThreadSafe

```cpp
bool cv::detail::BestOf2NearestRangeMatcher::isThreadSafe()

AutoIt:
    $oBestOf2NearestRangeMatcher.isThreadSafe() -> retval
```

## cv::detail::AffineBestOf2NearestMatcher

### cv::detail::AffineBestOf2NearestMatcher::create

```cpp
static cv::detail::AffineBestOf2NearestMatcher cv::detail::AffineBestOf2NearestMatcher::create( bool  full_affine = false,
                                                                                                bool  try_use_gpu = false,
                                                                                                float match_conf = 0.3f,
                                                                                                int   num_matches_thresh1 = 6 )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.AffineBestOf2NearestMatcher").create( [$full_affine[, $try_use_gpu[, $match_conf[, $num_matches_thresh1]]]] ) -> <cv.detail.AffineBestOf2NearestMatcher object>
```

### cv::detail::AffineBestOf2NearestMatcher::collectGarbage

```cpp
void cv::detail::AffineBestOf2NearestMatcher::collectGarbage()

AutoIt:
    $oAffineBestOf2NearestMatcher.collectGarbage() -> None
```

### cv::detail::AffineBestOf2NearestMatcher::apply

```cpp
void cv::detail::AffineBestOf2NearestMatcher::apply( const cv::detail::ImageFeatures& features1,
                                                     const cv::detail::ImageFeatures& features2,
                                                     cv::detail::MatchesInfo&         matches_info )

AutoIt:
    $oAffineBestOf2NearestMatcher.apply( $features1, $features2[, $matches_info] ) -> $matches_info
```

### cv::detail::AffineBestOf2NearestMatcher::apply2

```cpp
void cv::detail::AffineBestOf2NearestMatcher::apply2( const std::vector<cv::detail::ImageFeatures>& features,
                                                      std::vector<cv::detail::MatchesInfo>&         pairwise_matches,
                                                      const cv::UMat&                               mask = cv::UMat() )

AutoIt:
    $oAffineBestOf2NearestMatcher.apply2( $features[, $mask[, $pairwise_matches]] ) -> $pairwise_matches
```

### cv::detail::AffineBestOf2NearestMatcher::isThreadSafe

```cpp
bool cv::detail::AffineBestOf2NearestMatcher::isThreadSafe()

AutoIt:
    $oAffineBestOf2NearestMatcher.isThreadSafe() -> retval
```

## cv::detail::Estimator

### cv::detail::Estimator::apply

```cpp
bool cv::detail::Estimator::apply( const std::vector<cv::detail::ImageFeatures>& features,
                                   const std::vector<cv::detail::MatchesInfo>&   pairwise_matches,
                                   std::vector<cv::detail::CameraParams>&        cameras )

AutoIt:
    $oEstimator.apply( $features, $pairwise_matches, $cameras ) -> retval, $cameras
```

## cv::detail::HomographyBasedEstimator

### cv::detail::HomographyBasedEstimator::create

```cpp
static cv::detail::HomographyBasedEstimator cv::detail::HomographyBasedEstimator::create( bool is_focals_estimated = false )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.HomographyBasedEstimator").create( [$is_focals_estimated] ) -> <cv.detail.HomographyBasedEstimator object>
```

### cv::detail::HomographyBasedEstimator::apply

```cpp
bool cv::detail::HomographyBasedEstimator::apply( const std::vector<cv::detail::ImageFeatures>& features,
                                                  const std::vector<cv::detail::MatchesInfo>&   pairwise_matches,
                                                  std::vector<cv::detail::CameraParams>&        cameras )

AutoIt:
    $oHomographyBasedEstimator.apply( $features, $pairwise_matches, $cameras ) -> retval, $cameras
```

## cv::detail::AffineBasedEstimator

### cv::detail::AffineBasedEstimator::create

```cpp
static cv::detail::AffineBasedEstimator cv::detail::AffineBasedEstimator::create()

AutoIt:
    _OpenCV_ObjCreate("cv.detail.AffineBasedEstimator").create() -> <cv.detail.AffineBasedEstimator object>
```

### cv::detail::AffineBasedEstimator::apply

```cpp
bool cv::detail::AffineBasedEstimator::apply( const std::vector<cv::detail::ImageFeatures>& features,
                                              const std::vector<cv::detail::MatchesInfo>&   pairwise_matches,
                                              std::vector<cv::detail::CameraParams>&        cameras )

AutoIt:
    $oAffineBasedEstimator.apply( $features, $pairwise_matches, $cameras ) -> retval, $cameras
```

## cv::detail::BundleAdjusterBase

### cv::detail::BundleAdjusterBase::refinementMask

```cpp
cv::Mat cv::detail::BundleAdjusterBase::refinementMask()

AutoIt:
    $oBundleAdjusterBase.refinementMask() -> retval
```

### cv::detail::BundleAdjusterBase::setRefinementMask

```cpp
void cv::detail::BundleAdjusterBase::setRefinementMask( const cv::Mat& mask )

AutoIt:
    $oBundleAdjusterBase.setRefinementMask( $mask ) -> None
```

### cv::detail::BundleAdjusterBase::confThresh

```cpp
double cv::detail::BundleAdjusterBase::confThresh()

AutoIt:
    $oBundleAdjusterBase.confThresh() -> retval
```

### cv::detail::BundleAdjusterBase::setConfThresh

```cpp
void cv::detail::BundleAdjusterBase::setConfThresh( double conf_thresh )

AutoIt:
    $oBundleAdjusterBase.setConfThresh( $conf_thresh ) -> None
```

### cv::detail::BundleAdjusterBase::termCriteria

```cpp
cv::TermCriteria cv::detail::BundleAdjusterBase::termCriteria()

AutoIt:
    $oBundleAdjusterBase.termCriteria() -> retval
```

### cv::detail::BundleAdjusterBase::setTermCriteria

```cpp
void cv::detail::BundleAdjusterBase::setTermCriteria( const cv::TermCriteria& term_criteria )

AutoIt:
    $oBundleAdjusterBase.setTermCriteria( $term_criteria ) -> None
```

### cv::detail::BundleAdjusterBase::apply

```cpp
bool cv::detail::BundleAdjusterBase::apply( const std::vector<cv::detail::ImageFeatures>& features,
                                            const std::vector<cv::detail::MatchesInfo>&   pairwise_matches,
                                            std::vector<cv::detail::CameraParams>&        cameras )

AutoIt:
    $oBundleAdjusterBase.apply( $features, $pairwise_matches, $cameras ) -> retval, $cameras
```

## cv::detail::NoBundleAdjuster

### cv::detail::NoBundleAdjuster::create

```cpp
static cv::detail::NoBundleAdjuster cv::detail::NoBundleAdjuster::create()

AutoIt:
    _OpenCV_ObjCreate("cv.detail.NoBundleAdjuster").create() -> <cv.detail.NoBundleAdjuster object>
```

### cv::detail::NoBundleAdjuster::refinementMask

```cpp
cv::Mat cv::detail::NoBundleAdjuster::refinementMask()

AutoIt:
    $oNoBundleAdjuster.refinementMask() -> retval
```

### cv::detail::NoBundleAdjuster::setRefinementMask

```cpp
void cv::detail::NoBundleAdjuster::setRefinementMask( const cv::Mat& mask )

AutoIt:
    $oNoBundleAdjuster.setRefinementMask( $mask ) -> None
```

### cv::detail::NoBundleAdjuster::confThresh

```cpp
double cv::detail::NoBundleAdjuster::confThresh()

AutoIt:
    $oNoBundleAdjuster.confThresh() -> retval
```

### cv::detail::NoBundleAdjuster::setConfThresh

```cpp
void cv::detail::NoBundleAdjuster::setConfThresh( double conf_thresh )

AutoIt:
    $oNoBundleAdjuster.setConfThresh( $conf_thresh ) -> None
```

### cv::detail::NoBundleAdjuster::termCriteria

```cpp
cv::TermCriteria cv::detail::NoBundleAdjuster::termCriteria()

AutoIt:
    $oNoBundleAdjuster.termCriteria() -> retval
```

### cv::detail::NoBundleAdjuster::setTermCriteria

```cpp
void cv::detail::NoBundleAdjuster::setTermCriteria( const cv::TermCriteria& term_criteria )

AutoIt:
    $oNoBundleAdjuster.setTermCriteria( $term_criteria ) -> None
```

### cv::detail::NoBundleAdjuster::apply

```cpp
bool cv::detail::NoBundleAdjuster::apply( const std::vector<cv::detail::ImageFeatures>& features,
                                          const std::vector<cv::detail::MatchesInfo>&   pairwise_matches,
                                          std::vector<cv::detail::CameraParams>&        cameras )

AutoIt:
    $oNoBundleAdjuster.apply( $features, $pairwise_matches, $cameras ) -> retval, $cameras
```

## cv::detail::BundleAdjusterReproj

### cv::detail::BundleAdjusterReproj::create

```cpp
static cv::detail::BundleAdjusterReproj cv::detail::BundleAdjusterReproj::create()

AutoIt:
    _OpenCV_ObjCreate("cv.detail.BundleAdjusterReproj").create() -> <cv.detail.BundleAdjusterReproj object>
```

### cv::detail::BundleAdjusterReproj::refinementMask

```cpp
cv::Mat cv::detail::BundleAdjusterReproj::refinementMask()

AutoIt:
    $oBundleAdjusterReproj.refinementMask() -> retval
```

### cv::detail::BundleAdjusterReproj::setRefinementMask

```cpp
void cv::detail::BundleAdjusterReproj::setRefinementMask( const cv::Mat& mask )

AutoIt:
    $oBundleAdjusterReproj.setRefinementMask( $mask ) -> None
```

### cv::detail::BundleAdjusterReproj::confThresh

```cpp
double cv::detail::BundleAdjusterReproj::confThresh()

AutoIt:
    $oBundleAdjusterReproj.confThresh() -> retval
```

### cv::detail::BundleAdjusterReproj::setConfThresh

```cpp
void cv::detail::BundleAdjusterReproj::setConfThresh( double conf_thresh )

AutoIt:
    $oBundleAdjusterReproj.setConfThresh( $conf_thresh ) -> None
```

### cv::detail::BundleAdjusterReproj::termCriteria

```cpp
cv::TermCriteria cv::detail::BundleAdjusterReproj::termCriteria()

AutoIt:
    $oBundleAdjusterReproj.termCriteria() -> retval
```

### cv::detail::BundleAdjusterReproj::setTermCriteria

```cpp
void cv::detail::BundleAdjusterReproj::setTermCriteria( const cv::TermCriteria& term_criteria )

AutoIt:
    $oBundleAdjusterReproj.setTermCriteria( $term_criteria ) -> None
```

### cv::detail::BundleAdjusterReproj::apply

```cpp
bool cv::detail::BundleAdjusterReproj::apply( const std::vector<cv::detail::ImageFeatures>& features,
                                              const std::vector<cv::detail::MatchesInfo>&   pairwise_matches,
                                              std::vector<cv::detail::CameraParams>&        cameras )

AutoIt:
    $oBundleAdjusterReproj.apply( $features, $pairwise_matches, $cameras ) -> retval, $cameras
```

## cv::detail::BundleAdjusterRay

### cv::detail::BundleAdjusterRay::create

```cpp
static cv::detail::BundleAdjusterRay cv::detail::BundleAdjusterRay::create()

AutoIt:
    _OpenCV_ObjCreate("cv.detail.BundleAdjusterRay").create() -> <cv.detail.BundleAdjusterRay object>
```

### cv::detail::BundleAdjusterRay::refinementMask

```cpp
cv::Mat cv::detail::BundleAdjusterRay::refinementMask()

AutoIt:
    $oBundleAdjusterRay.refinementMask() -> retval
```

### cv::detail::BundleAdjusterRay::setRefinementMask

```cpp
void cv::detail::BundleAdjusterRay::setRefinementMask( const cv::Mat& mask )

AutoIt:
    $oBundleAdjusterRay.setRefinementMask( $mask ) -> None
```

### cv::detail::BundleAdjusterRay::confThresh

```cpp
double cv::detail::BundleAdjusterRay::confThresh()

AutoIt:
    $oBundleAdjusterRay.confThresh() -> retval
```

### cv::detail::BundleAdjusterRay::setConfThresh

```cpp
void cv::detail::BundleAdjusterRay::setConfThresh( double conf_thresh )

AutoIt:
    $oBundleAdjusterRay.setConfThresh( $conf_thresh ) -> None
```

### cv::detail::BundleAdjusterRay::termCriteria

```cpp
cv::TermCriteria cv::detail::BundleAdjusterRay::termCriteria()

AutoIt:
    $oBundleAdjusterRay.termCriteria() -> retval
```

### cv::detail::BundleAdjusterRay::setTermCriteria

```cpp
void cv::detail::BundleAdjusterRay::setTermCriteria( const cv::TermCriteria& term_criteria )

AutoIt:
    $oBundleAdjusterRay.setTermCriteria( $term_criteria ) -> None
```

### cv::detail::BundleAdjusterRay::apply

```cpp
bool cv::detail::BundleAdjusterRay::apply( const std::vector<cv::detail::ImageFeatures>& features,
                                           const std::vector<cv::detail::MatchesInfo>&   pairwise_matches,
                                           std::vector<cv::detail::CameraParams>&        cameras )

AutoIt:
    $oBundleAdjusterRay.apply( $features, $pairwise_matches, $cameras ) -> retval, $cameras
```

## cv::detail::BundleAdjusterAffine

### cv::detail::BundleAdjusterAffine::create

```cpp
static cv::detail::BundleAdjusterAffine cv::detail::BundleAdjusterAffine::create()

AutoIt:
    _OpenCV_ObjCreate("cv.detail.BundleAdjusterAffine").create() -> <cv.detail.BundleAdjusterAffine object>
```

### cv::detail::BundleAdjusterAffine::refinementMask

```cpp
cv::Mat cv::detail::BundleAdjusterAffine::refinementMask()

AutoIt:
    $oBundleAdjusterAffine.refinementMask() -> retval
```

### cv::detail::BundleAdjusterAffine::setRefinementMask

```cpp
void cv::detail::BundleAdjusterAffine::setRefinementMask( const cv::Mat& mask )

AutoIt:
    $oBundleAdjusterAffine.setRefinementMask( $mask ) -> None
```

### cv::detail::BundleAdjusterAffine::confThresh

```cpp
double cv::detail::BundleAdjusterAffine::confThresh()

AutoIt:
    $oBundleAdjusterAffine.confThresh() -> retval
```

### cv::detail::BundleAdjusterAffine::setConfThresh

```cpp
void cv::detail::BundleAdjusterAffine::setConfThresh( double conf_thresh )

AutoIt:
    $oBundleAdjusterAffine.setConfThresh( $conf_thresh ) -> None
```

### cv::detail::BundleAdjusterAffine::termCriteria

```cpp
cv::TermCriteria cv::detail::BundleAdjusterAffine::termCriteria()

AutoIt:
    $oBundleAdjusterAffine.termCriteria() -> retval
```

### cv::detail::BundleAdjusterAffine::setTermCriteria

```cpp
void cv::detail::BundleAdjusterAffine::setTermCriteria( const cv::TermCriteria& term_criteria )

AutoIt:
    $oBundleAdjusterAffine.setTermCriteria( $term_criteria ) -> None
```

### cv::detail::BundleAdjusterAffine::apply

```cpp
bool cv::detail::BundleAdjusterAffine::apply( const std::vector<cv::detail::ImageFeatures>& features,
                                              const std::vector<cv::detail::MatchesInfo>&   pairwise_matches,
                                              std::vector<cv::detail::CameraParams>&        cameras )

AutoIt:
    $oBundleAdjusterAffine.apply( $features, $pairwise_matches, $cameras ) -> retval, $cameras
```

## cv::detail::BundleAdjusterAffinePartial

### cv::detail::BundleAdjusterAffinePartial::create

```cpp
static cv::detail::BundleAdjusterAffinePartial cv::detail::BundleAdjusterAffinePartial::create()

AutoIt:
    _OpenCV_ObjCreate("cv.detail.BundleAdjusterAffinePartial").create() -> <cv.detail.BundleAdjusterAffinePartial object>
```

### cv::detail::BundleAdjusterAffinePartial::refinementMask

```cpp
cv::Mat cv::detail::BundleAdjusterAffinePartial::refinementMask()

AutoIt:
    $oBundleAdjusterAffinePartial.refinementMask() -> retval
```

### cv::detail::BundleAdjusterAffinePartial::setRefinementMask

```cpp
void cv::detail::BundleAdjusterAffinePartial::setRefinementMask( const cv::Mat& mask )

AutoIt:
    $oBundleAdjusterAffinePartial.setRefinementMask( $mask ) -> None
```

### cv::detail::BundleAdjusterAffinePartial::confThresh

```cpp
double cv::detail::BundleAdjusterAffinePartial::confThresh()

AutoIt:
    $oBundleAdjusterAffinePartial.confThresh() -> retval
```

### cv::detail::BundleAdjusterAffinePartial::setConfThresh

```cpp
void cv::detail::BundleAdjusterAffinePartial::setConfThresh( double conf_thresh )

AutoIt:
    $oBundleAdjusterAffinePartial.setConfThresh( $conf_thresh ) -> None
```

### cv::detail::BundleAdjusterAffinePartial::termCriteria

```cpp
cv::TermCriteria cv::detail::BundleAdjusterAffinePartial::termCriteria()

AutoIt:
    $oBundleAdjusterAffinePartial.termCriteria() -> retval
```

### cv::detail::BundleAdjusterAffinePartial::setTermCriteria

```cpp
void cv::detail::BundleAdjusterAffinePartial::setTermCriteria( const cv::TermCriteria& term_criteria )

AutoIt:
    $oBundleAdjusterAffinePartial.setTermCriteria( $term_criteria ) -> None
```

### cv::detail::BundleAdjusterAffinePartial::apply

```cpp
bool cv::detail::BundleAdjusterAffinePartial::apply( const std::vector<cv::detail::ImageFeatures>& features,
                                                     const std::vector<cv::detail::MatchesInfo>&   pairwise_matches,
                                                     std::vector<cv::detail::CameraParams>&        cameras )

AutoIt:
    $oBundleAdjusterAffinePartial.apply( $features, $pairwise_matches, $cameras ) -> retval, $cameras
```

## cv::detail::SeamFinder

### cv::detail::SeamFinder::find

```cpp
void cv::detail::SeamFinder::find( const std::vector<cv::UMat>&  src,
                                   const std::vector<cv::Point>& corners,
                                   std::vector<cv::UMat>&        masks )

AutoIt:
    $oSeamFinder.find( $src, $corners, $masks ) -> $masks
```

### cv::detail::SeamFinder::createDefault

```cpp
static cv::Ptr<cv::detail::SeamFinder> cv::detail::SeamFinder::createDefault( int type )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.SeamFinder").createDefault( $type ) -> retval
```

## cv::detail::NoSeamFinder

### cv::detail::NoSeamFinder::find

```cpp
void cv::detail::NoSeamFinder::find( const std::vector<cv::UMat>&  arg1,
                                     const std::vector<cv::Point>& arg2,
                                     std::vector<cv::UMat>&        arg3 )

AutoIt:
    $oNoSeamFinder.find( $arg1, $arg2, $arg3 ) -> $arg3
```

### cv::detail::NoSeamFinder::createDefault

```cpp
static cv::Ptr<cv::detail::SeamFinder> cv::detail::NoSeamFinder::createDefault( int type )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.NoSeamFinder").createDefault( $type ) -> retval
```

## cv::detail::PairwiseSeamFinder

### cv::detail::PairwiseSeamFinder::find

```cpp
void cv::detail::PairwiseSeamFinder::find( const std::vector<cv::UMat>&  src,
                                           const std::vector<cv::Point>& corners,
                                           std::vector<cv::UMat>&        masks )

AutoIt:
    $oPairwiseSeamFinder.find( $src, $corners, $masks ) -> $masks
```

### cv::detail::PairwiseSeamFinder::createDefault

```cpp
static cv::Ptr<cv::detail::SeamFinder> cv::detail::PairwiseSeamFinder::createDefault( int type )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.PairwiseSeamFinder").createDefault( $type ) -> retval
```

## cv::detail::VoronoiSeamFinder

### cv::detail::VoronoiSeamFinder::find

```cpp
void cv::detail::VoronoiSeamFinder::find( const std::vector<cv::UMat>&  src,
                                          const std::vector<cv::Point>& corners,
                                          std::vector<cv::UMat>&        masks )

AutoIt:
    $oVoronoiSeamFinder.find( $src, $corners, $masks ) -> $masks
```

### cv::detail::VoronoiSeamFinder::createDefault

```cpp
static cv::Ptr<cv::detail::SeamFinder> cv::detail::VoronoiSeamFinder::createDefault( int type )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.VoronoiSeamFinder").createDefault( $type ) -> retval
```

## cv::detail::DpSeamFinder

### cv::detail::DpSeamFinder::create

```cpp
static cv::detail::DpSeamFinder cv::detail::DpSeamFinder::create( std::string costFunc )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.DpSeamFinder").create( $costFunc ) -> <cv.detail.DpSeamFinder object>
```

### cv::detail::DpSeamFinder::setCostFunction

```cpp
void cv::detail::DpSeamFinder::setCostFunction( std::string val )

AutoIt:
    $oDpSeamFinder.setCostFunction( $val ) -> None
```

### cv::detail::DpSeamFinder::find

```cpp
void cv::detail::DpSeamFinder::find( const std::vector<cv::UMat>&  src,
                                     const std::vector<cv::Point>& corners,
                                     std::vector<cv::UMat>&        masks )

AutoIt:
    $oDpSeamFinder.find( $src, $corners, $masks ) -> $masks
```

### cv::detail::DpSeamFinder::createDefault

```cpp
static cv::Ptr<cv::detail::SeamFinder> cv::detail::DpSeamFinder::createDefault( int type )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.DpSeamFinder").createDefault( $type ) -> retval
```

## cv::detail::GraphCutSeamFinder

### cv::detail::GraphCutSeamFinder::create

```cpp
static cv::detail::GraphCutSeamFinder cv::detail::GraphCutSeamFinder::create( std::string cost_type,
                                                                              float       terminal_cost = 10000.f,
                                                                              float       bad_region_penalty = 1000.f )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.GraphCutSeamFinder").create( $cost_type[, $terminal_cost[, $bad_region_penalty]] ) -> <cv.detail.GraphCutSeamFinder object>
```

### cv::detail::GraphCutSeamFinder::find

```cpp
void cv::detail::GraphCutSeamFinder::find( const std::vector<cv::UMat>&  src,
                                           const std::vector<cv::Point>& corners,
                                           std::vector<cv::UMat>&        masks )

AutoIt:
    $oGraphCutSeamFinder.find( $src, $corners, $masks ) -> None
```

### cv::detail::GraphCutSeamFinder::createDefault

```cpp
static cv::Ptr<cv::detail::SeamFinder> cv::detail::GraphCutSeamFinder::createDefault( int type )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.GraphCutSeamFinder").createDefault( $type ) -> retval
```

## cv::detail::Timelapser

### cv::detail::Timelapser::createDefault

```cpp
static cv::Ptr<cv::detail::Timelapser> cv::detail::Timelapser::createDefault( int type )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.Timelapser").createDefault( $type ) -> retval
```

### cv::detail::Timelapser::initialize

```cpp
void cv::detail::Timelapser::initialize( const std::vector<cv::Point>& corners,
                                         const std::vector<cv::Size>&  sizes )

AutoIt:
    $oTimelapser.initialize( $corners, $sizes ) -> None
```

### cv::detail::Timelapser::process

```cpp
void cv::detail::Timelapser::process( _InputArray img,
                                      _InputArray mask,
                                      cv::Point   tl )

AutoIt:
    $oTimelapser.process( $img, $mask, $tl ) -> None
```

### cv::detail::Timelapser::getDst

```cpp
cv::UMat cv::detail::Timelapser::getDst()

AutoIt:
    $oTimelapser.getDst() -> retval
```

## cv::detail::TimelapserCrop

### cv::detail::TimelapserCrop::createDefault

```cpp
static cv::Ptr<cv::detail::Timelapser> cv::detail::TimelapserCrop::createDefault( int type )

AutoIt:
    _OpenCV_ObjCreate("cv.detail.TimelapserCrop").createDefault( $type ) -> retval
```

### cv::detail::TimelapserCrop::initialize

```cpp
void cv::detail::TimelapserCrop::initialize( const std::vector<cv::Point>& corners,
                                             const std::vector<cv::Size>&  sizes )

AutoIt:
    $oTimelapserCrop.initialize( $corners, $sizes ) -> None
```

### cv::detail::TimelapserCrop::process

```cpp
void cv::detail::TimelapserCrop::process( _InputArray img,
                                          _InputArray mask,
                                          cv::Point   tl )

AutoIt:
    $oTimelapserCrop.process( $img, $mask, $tl ) -> None
```

### cv::detail::TimelapserCrop::getDst

```cpp
cv::UMat cv::detail::TimelapserCrop::getDst()

AutoIt:
    $oTimelapserCrop.getDst() -> retval
```

## cv::detail::ProjectorBase

### cv::detail::ProjectorBase::create

```cpp
static cv::detail::ProjectorBase cv::detail::ProjectorBase::create()

AutoIt:
    _OpenCV_ObjCreate("cv.detail.ProjectorBase").create() -> <cv.detail.ProjectorBase object>
```

## cv::detail::SphericalProjector

### cv::detail::SphericalProjector::create

```cpp
static cv::detail::SphericalProjector cv::detail::SphericalProjector::create()

AutoIt:
    _OpenCV_ObjCreate("cv.detail.SphericalProjector").create() -> <cv.detail.SphericalProjector object>
```

### cv::detail::SphericalProjector::mapForward

```cpp
void cv::detail::SphericalProjector::mapForward( float  x,
                                                 float  y,
                                                 float& u,
                                                 float& v )

AutoIt:
    $oSphericalProjector.mapForward( $x, $y, $u, $v ) -> None
```

### cv::detail::SphericalProjector::mapBackward

```cpp
void cv::detail::SphericalProjector::mapBackward( float  u,
                                                  float  v,
                                                  float& x,
                                                  float& y )

AutoIt:
    $oSphericalProjector.mapBackward( $u, $v, $x, $y ) -> None
```

## cv::BackgroundSubtractor

### cv::BackgroundSubtractor::apply

```cpp
void cv::BackgroundSubtractor::apply( _InputArray  image,
                                      _OutputArray fgmask,
                                      double       learningRate = -1 )

AutoIt:
    $oBackgroundSubtractor.apply( $image[, $fgmask[, $learningRate]] ) -> $fgmask
```

### cv::BackgroundSubtractor::getBackgroundImage

```cpp
void cv::BackgroundSubtractor::getBackgroundImage( _OutputArray backgroundImage )

AutoIt:
    $oBackgroundSubtractor.getBackgroundImage( [$backgroundImage] ) -> $backgroundImage
```

### cv::BackgroundSubtractor::clear

```cpp
void cv::BackgroundSubtractor::clear()

AutoIt:
    $oBackgroundSubtractor.clear() -> None
```

### cv::BackgroundSubtractor::write

```cpp
void cv::BackgroundSubtractor::write( const cv::Ptr<cv::FileStorage>& fs,
                                      const std::string&              name = String() )

AutoIt:
    $oBackgroundSubtractor.write( $fs[, $name] ) -> None
```

### cv::BackgroundSubtractor::read

```cpp
void cv::BackgroundSubtractor::read( const cv::FileNode& fn )

AutoIt:
    $oBackgroundSubtractor.read( $fn ) -> None
```

### cv::BackgroundSubtractor::empty

```cpp
bool cv::BackgroundSubtractor::empty()

AutoIt:
    $oBackgroundSubtractor.empty() -> retval
```

### cv::BackgroundSubtractor::save

```cpp
void cv::BackgroundSubtractor::save( const std::string& filename )

AutoIt:
    $oBackgroundSubtractor.save( $filename ) -> None
```

### cv::BackgroundSubtractor::getDefaultName

```cpp
std::string cv::BackgroundSubtractor::getDefaultName()

AutoIt:
    $oBackgroundSubtractor.getDefaultName() -> retval
```

## cv::BackgroundSubtractorMOG2

### cv::BackgroundSubtractorMOG2::getHistory

```cpp
int cv::BackgroundSubtractorMOG2::getHistory()

AutoIt:
    $oBackgroundSubtractorMOG2.getHistory() -> retval
```

### cv::BackgroundSubtractorMOG2::setHistory

```cpp
void cv::BackgroundSubtractorMOG2::setHistory( int history )

AutoIt:
    $oBackgroundSubtractorMOG2.setHistory( $history ) -> None
```

### cv::BackgroundSubtractorMOG2::getNMixtures

```cpp
int cv::BackgroundSubtractorMOG2::getNMixtures()

AutoIt:
    $oBackgroundSubtractorMOG2.getNMixtures() -> retval
```

### cv::BackgroundSubtractorMOG2::setNMixtures

```cpp
void cv::BackgroundSubtractorMOG2::setNMixtures( int nmixtures )

AutoIt:
    $oBackgroundSubtractorMOG2.setNMixtures( $nmixtures ) -> None
```

### cv::BackgroundSubtractorMOG2::getBackgroundRatio

```cpp
double cv::BackgroundSubtractorMOG2::getBackgroundRatio()

AutoIt:
    $oBackgroundSubtractorMOG2.getBackgroundRatio() -> retval
```

### cv::BackgroundSubtractorMOG2::setBackgroundRatio

```cpp
void cv::BackgroundSubtractorMOG2::setBackgroundRatio( double ratio )

AutoIt:
    $oBackgroundSubtractorMOG2.setBackgroundRatio( $ratio ) -> None
```

### cv::BackgroundSubtractorMOG2::getVarThreshold

```cpp
double cv::BackgroundSubtractorMOG2::getVarThreshold()

AutoIt:
    $oBackgroundSubtractorMOG2.getVarThreshold() -> retval
```

### cv::BackgroundSubtractorMOG2::setVarThreshold

```cpp
void cv::BackgroundSubtractorMOG2::setVarThreshold( double varThreshold )

AutoIt:
    $oBackgroundSubtractorMOG2.setVarThreshold( $varThreshold ) -> None
```

### cv::BackgroundSubtractorMOG2::getVarThresholdGen

```cpp
double cv::BackgroundSubtractorMOG2::getVarThresholdGen()

AutoIt:
    $oBackgroundSubtractorMOG2.getVarThresholdGen() -> retval
```

### cv::BackgroundSubtractorMOG2::setVarThresholdGen

```cpp
void cv::BackgroundSubtractorMOG2::setVarThresholdGen( double varThresholdGen )

AutoIt:
    $oBackgroundSubtractorMOG2.setVarThresholdGen( $varThresholdGen ) -> None
```

### cv::BackgroundSubtractorMOG2::getVarInit

```cpp
double cv::BackgroundSubtractorMOG2::getVarInit()

AutoIt:
    $oBackgroundSubtractorMOG2.getVarInit() -> retval
```

### cv::BackgroundSubtractorMOG2::setVarInit

```cpp
void cv::BackgroundSubtractorMOG2::setVarInit( double varInit )

AutoIt:
    $oBackgroundSubtractorMOG2.setVarInit( $varInit ) -> None
```

### cv::BackgroundSubtractorMOG2::getVarMin

```cpp
double cv::BackgroundSubtractorMOG2::getVarMin()

AutoIt:
    $oBackgroundSubtractorMOG2.getVarMin() -> retval
```

### cv::BackgroundSubtractorMOG2::setVarMin

```cpp
void cv::BackgroundSubtractorMOG2::setVarMin( double varMin )

AutoIt:
    $oBackgroundSubtractorMOG2.setVarMin( $varMin ) -> None
```

### cv::BackgroundSubtractorMOG2::getVarMax

```cpp
double cv::BackgroundSubtractorMOG2::getVarMax()

AutoIt:
    $oBackgroundSubtractorMOG2.getVarMax() -> retval
```

### cv::BackgroundSubtractorMOG2::setVarMax

```cpp
void cv::BackgroundSubtractorMOG2::setVarMax( double varMax )

AutoIt:
    $oBackgroundSubtractorMOG2.setVarMax( $varMax ) -> None
```

### cv::BackgroundSubtractorMOG2::getComplexityReductionThreshold

```cpp
double cv::BackgroundSubtractorMOG2::getComplexityReductionThreshold()

AutoIt:
    $oBackgroundSubtractorMOG2.getComplexityReductionThreshold() -> retval
```

### cv::BackgroundSubtractorMOG2::setComplexityReductionThreshold

```cpp
void cv::BackgroundSubtractorMOG2::setComplexityReductionThreshold( double ct )

AutoIt:
    $oBackgroundSubtractorMOG2.setComplexityReductionThreshold( $ct ) -> None
```

### cv::BackgroundSubtractorMOG2::getDetectShadows

```cpp
bool cv::BackgroundSubtractorMOG2::getDetectShadows()

AutoIt:
    $oBackgroundSubtractorMOG2.getDetectShadows() -> retval
```

### cv::BackgroundSubtractorMOG2::setDetectShadows

```cpp
void cv::BackgroundSubtractorMOG2::setDetectShadows( bool detectShadows )

AutoIt:
    $oBackgroundSubtractorMOG2.setDetectShadows( $detectShadows ) -> None
```

### cv::BackgroundSubtractorMOG2::getShadowValue

```cpp
int cv::BackgroundSubtractorMOG2::getShadowValue()

AutoIt:
    $oBackgroundSubtractorMOG2.getShadowValue() -> retval
```

### cv::BackgroundSubtractorMOG2::setShadowValue

```cpp
void cv::BackgroundSubtractorMOG2::setShadowValue( int value )

AutoIt:
    $oBackgroundSubtractorMOG2.setShadowValue( $value ) -> None
```

### cv::BackgroundSubtractorMOG2::getShadowThreshold

```cpp
double cv::BackgroundSubtractorMOG2::getShadowThreshold()

AutoIt:
    $oBackgroundSubtractorMOG2.getShadowThreshold() -> retval
```

### cv::BackgroundSubtractorMOG2::setShadowThreshold

```cpp
void cv::BackgroundSubtractorMOG2::setShadowThreshold( double threshold )

AutoIt:
    $oBackgroundSubtractorMOG2.setShadowThreshold( $threshold ) -> None
```

### cv::BackgroundSubtractorMOG2::apply

```cpp
void cv::BackgroundSubtractorMOG2::apply( _InputArray  image,
                                          _OutputArray fgmask,
                                          double       learningRate = -1 )

AutoIt:
    $oBackgroundSubtractorMOG2.apply( $image[, $fgmask[, $learningRate]] ) -> $fgmask
```

### cv::BackgroundSubtractorMOG2::getBackgroundImage

```cpp
void cv::BackgroundSubtractorMOG2::getBackgroundImage( _OutputArray backgroundImage )

AutoIt:
    $oBackgroundSubtractorMOG2.getBackgroundImage( [$backgroundImage] ) -> $backgroundImage
```

### cv::BackgroundSubtractorMOG2::clear

```cpp
void cv::BackgroundSubtractorMOG2::clear()

AutoIt:
    $oBackgroundSubtractorMOG2.clear() -> None
```

### cv::BackgroundSubtractorMOG2::write

```cpp
void cv::BackgroundSubtractorMOG2::write( const cv::Ptr<cv::FileStorage>& fs,
                                          const std::string&              name = String() )

AutoIt:
    $oBackgroundSubtractorMOG2.write( $fs[, $name] ) -> None
```

### cv::BackgroundSubtractorMOG2::read

```cpp
void cv::BackgroundSubtractorMOG2::read( const cv::FileNode& fn )

AutoIt:
    $oBackgroundSubtractorMOG2.read( $fn ) -> None
```

### cv::BackgroundSubtractorMOG2::empty

```cpp
bool cv::BackgroundSubtractorMOG2::empty()

AutoIt:
    $oBackgroundSubtractorMOG2.empty() -> retval
```

### cv::BackgroundSubtractorMOG2::save

```cpp
void cv::BackgroundSubtractorMOG2::save( const std::string& filename )

AutoIt:
    $oBackgroundSubtractorMOG2.save( $filename ) -> None
```

### cv::BackgroundSubtractorMOG2::getDefaultName

```cpp
std::string cv::BackgroundSubtractorMOG2::getDefaultName()

AutoIt:
    $oBackgroundSubtractorMOG2.getDefaultName() -> retval
```

## cv::BackgroundSubtractorKNN

### cv::BackgroundSubtractorKNN::getHistory

```cpp
int cv::BackgroundSubtractorKNN::getHistory()

AutoIt:
    $oBackgroundSubtractorKNN.getHistory() -> retval
```

### cv::BackgroundSubtractorKNN::setHistory

```cpp
void cv::BackgroundSubtractorKNN::setHistory( int history )

AutoIt:
    $oBackgroundSubtractorKNN.setHistory( $history ) -> None
```

### cv::BackgroundSubtractorKNN::getNSamples

```cpp
int cv::BackgroundSubtractorKNN::getNSamples()

AutoIt:
    $oBackgroundSubtractorKNN.getNSamples() -> retval
```

### cv::BackgroundSubtractorKNN::setNSamples

```cpp
void cv::BackgroundSubtractorKNN::setNSamples( int _nN )

AutoIt:
    $oBackgroundSubtractorKNN.setNSamples( $_nN ) -> None
```

### cv::BackgroundSubtractorKNN::getDist2Threshold

```cpp
double cv::BackgroundSubtractorKNN::getDist2Threshold()

AutoIt:
    $oBackgroundSubtractorKNN.getDist2Threshold() -> retval
```

### cv::BackgroundSubtractorKNN::setDist2Threshold

```cpp
void cv::BackgroundSubtractorKNN::setDist2Threshold( double _dist2Threshold )

AutoIt:
    $oBackgroundSubtractorKNN.setDist2Threshold( $_dist2Threshold ) -> None
```

### cv::BackgroundSubtractorKNN::getkNNSamples

```cpp
int cv::BackgroundSubtractorKNN::getkNNSamples()

AutoIt:
    $oBackgroundSubtractorKNN.getkNNSamples() -> retval
```

### cv::BackgroundSubtractorKNN::setkNNSamples

```cpp
void cv::BackgroundSubtractorKNN::setkNNSamples( int _nkNN )

AutoIt:
    $oBackgroundSubtractorKNN.setkNNSamples( $_nkNN ) -> None
```

### cv::BackgroundSubtractorKNN::getDetectShadows

```cpp
bool cv::BackgroundSubtractorKNN::getDetectShadows()

AutoIt:
    $oBackgroundSubtractorKNN.getDetectShadows() -> retval
```

### cv::BackgroundSubtractorKNN::setDetectShadows

```cpp
void cv::BackgroundSubtractorKNN::setDetectShadows( bool detectShadows )

AutoIt:
    $oBackgroundSubtractorKNN.setDetectShadows( $detectShadows ) -> None
```

### cv::BackgroundSubtractorKNN::getShadowValue

```cpp
int cv::BackgroundSubtractorKNN::getShadowValue()

AutoIt:
    $oBackgroundSubtractorKNN.getShadowValue() -> retval
```

### cv::BackgroundSubtractorKNN::setShadowValue

```cpp
void cv::BackgroundSubtractorKNN::setShadowValue( int value )

AutoIt:
    $oBackgroundSubtractorKNN.setShadowValue( $value ) -> None
```

### cv::BackgroundSubtractorKNN::getShadowThreshold

```cpp
double cv::BackgroundSubtractorKNN::getShadowThreshold()

AutoIt:
    $oBackgroundSubtractorKNN.getShadowThreshold() -> retval
```

### cv::BackgroundSubtractorKNN::setShadowThreshold

```cpp
void cv::BackgroundSubtractorKNN::setShadowThreshold( double threshold )

AutoIt:
    $oBackgroundSubtractorKNN.setShadowThreshold( $threshold ) -> None
```

### cv::BackgroundSubtractorKNN::apply

```cpp
void cv::BackgroundSubtractorKNN::apply( _InputArray  image,
                                         _OutputArray fgmask,
                                         double       learningRate = -1 )

AutoIt:
    $oBackgroundSubtractorKNN.apply( $image[, $fgmask[, $learningRate]] ) -> $fgmask
```

### cv::BackgroundSubtractorKNN::getBackgroundImage

```cpp
void cv::BackgroundSubtractorKNN::getBackgroundImage( _OutputArray backgroundImage )

AutoIt:
    $oBackgroundSubtractorKNN.getBackgroundImage( [$backgroundImage] ) -> $backgroundImage
```

### cv::BackgroundSubtractorKNN::clear

```cpp
void cv::BackgroundSubtractorKNN::clear()

AutoIt:
    $oBackgroundSubtractorKNN.clear() -> None
```

### cv::BackgroundSubtractorKNN::write

```cpp
void cv::BackgroundSubtractorKNN::write( const cv::Ptr<cv::FileStorage>& fs,
                                         const std::string&              name = String() )

AutoIt:
    $oBackgroundSubtractorKNN.write( $fs[, $name] ) -> None
```

### cv::BackgroundSubtractorKNN::read

```cpp
void cv::BackgroundSubtractorKNN::read( const cv::FileNode& fn )

AutoIt:
    $oBackgroundSubtractorKNN.read( $fn ) -> None
```

### cv::BackgroundSubtractorKNN::empty

```cpp
bool cv::BackgroundSubtractorKNN::empty()

AutoIt:
    $oBackgroundSubtractorKNN.empty() -> retval
```

### cv::BackgroundSubtractorKNN::save

```cpp
void cv::BackgroundSubtractorKNN::save( const std::string& filename )

AutoIt:
    $oBackgroundSubtractorKNN.save( $filename ) -> None
```

### cv::BackgroundSubtractorKNN::getDefaultName

```cpp
std::string cv::BackgroundSubtractorKNN::getDefaultName()

AutoIt:
    $oBackgroundSubtractorKNN.getDefaultName() -> retval
```

## cv::KalmanFilter

### cv::KalmanFilter::create

```cpp
static cv::KalmanFilter cv::KalmanFilter::create()

AutoIt:
    _OpenCV_ObjCreate("cv.KalmanFilter").create() -> <cv.KalmanFilter object>
```

```cpp
static cv::KalmanFilter cv::KalmanFilter::create( int dynamParams,
                                                  int measureParams,
                                                  int controlParams = 0,
                                                  int type = CV_32F )

AutoIt:
    _OpenCV_ObjCreate("cv.KalmanFilter").create( $dynamParams, $measureParams[, $controlParams[, $type]] ) -> <cv.KalmanFilter object>
```

### cv::KalmanFilter::predict

```cpp
cv::Mat cv::KalmanFilter::predict( const cv::Mat& control = Mat() )

AutoIt:
    $oKalmanFilter.predict( [$control] ) -> retval
```

### cv::KalmanFilter::correct

```cpp
cv::Mat cv::KalmanFilter::correct( const cv::Mat& measurement )

AutoIt:
    $oKalmanFilter.correct( $measurement ) -> retval
```

## cv::DenseOpticalFlow

### cv::DenseOpticalFlow::calc

```cpp
void cv::DenseOpticalFlow::calc( _InputArray       I0,
                                 _InputArray       I1,
                                 _InputOutputArray flow )

AutoIt:
    $oDenseOpticalFlow.calc( $I0, $I1, $flow ) -> $flow
```

### cv::DenseOpticalFlow::collectGarbage

```cpp
void cv::DenseOpticalFlow::collectGarbage()

AutoIt:
    $oDenseOpticalFlow.collectGarbage() -> None
```

### cv::DenseOpticalFlow::clear

```cpp
void cv::DenseOpticalFlow::clear()

AutoIt:
    $oDenseOpticalFlow.clear() -> None
```

### cv::DenseOpticalFlow::write

```cpp
void cv::DenseOpticalFlow::write( const cv::Ptr<cv::FileStorage>& fs,
                                  const std::string&              name = String() )

AutoIt:
    $oDenseOpticalFlow.write( $fs[, $name] ) -> None
```

### cv::DenseOpticalFlow::read

```cpp
void cv::DenseOpticalFlow::read( const cv::FileNode& fn )

AutoIt:
    $oDenseOpticalFlow.read( $fn ) -> None
```

### cv::DenseOpticalFlow::empty

```cpp
bool cv::DenseOpticalFlow::empty()

AutoIt:
    $oDenseOpticalFlow.empty() -> retval
```

### cv::DenseOpticalFlow::save

```cpp
void cv::DenseOpticalFlow::save( const std::string& filename )

AutoIt:
    $oDenseOpticalFlow.save( $filename ) -> None
```

### cv::DenseOpticalFlow::getDefaultName

```cpp
std::string cv::DenseOpticalFlow::getDefaultName()

AutoIt:
    $oDenseOpticalFlow.getDefaultName() -> retval
```

## cv::SparseOpticalFlow

### cv::SparseOpticalFlow::calc

```cpp
void cv::SparseOpticalFlow::calc( _InputArray       prevImg,
                                  _InputArray       nextImg,
                                  _InputArray       prevPts,
                                  _InputOutputArray nextPts,
                                  _OutputArray      status,
                                  _OutputArray      err = cv::noArray() )

AutoIt:
    $oSparseOpticalFlow.calc( $prevImg, $nextImg, $prevPts, $nextPts[, $status[, $err]] ) -> $nextPts, $status, $err
```

### cv::SparseOpticalFlow::clear

```cpp
void cv::SparseOpticalFlow::clear()

AutoIt:
    $oSparseOpticalFlow.clear() -> None
```

### cv::SparseOpticalFlow::write

```cpp
void cv::SparseOpticalFlow::write( const cv::Ptr<cv::FileStorage>& fs,
                                   const std::string&              name = String() )

AutoIt:
    $oSparseOpticalFlow.write( $fs[, $name] ) -> None
```

### cv::SparseOpticalFlow::read

```cpp
void cv::SparseOpticalFlow::read( const cv::FileNode& fn )

AutoIt:
    $oSparseOpticalFlow.read( $fn ) -> None
```

### cv::SparseOpticalFlow::empty

```cpp
bool cv::SparseOpticalFlow::empty()

AutoIt:
    $oSparseOpticalFlow.empty() -> retval
```

### cv::SparseOpticalFlow::save

```cpp
void cv::SparseOpticalFlow::save( const std::string& filename )

AutoIt:
    $oSparseOpticalFlow.save( $filename ) -> None
```

### cv::SparseOpticalFlow::getDefaultName

```cpp
std::string cv::SparseOpticalFlow::getDefaultName()

AutoIt:
    $oSparseOpticalFlow.getDefaultName() -> retval
```

## cv::FarnebackOpticalFlow

### cv::FarnebackOpticalFlow::getNumLevels

```cpp
int cv::FarnebackOpticalFlow::getNumLevels()

AutoIt:
    $oFarnebackOpticalFlow.getNumLevels() -> retval
```

### cv::FarnebackOpticalFlow::setNumLevels

```cpp
void cv::FarnebackOpticalFlow::setNumLevels( int numLevels )

AutoIt:
    $oFarnebackOpticalFlow.setNumLevels( $numLevels ) -> None
```

### cv::FarnebackOpticalFlow::getPyrScale

```cpp
double cv::FarnebackOpticalFlow::getPyrScale()

AutoIt:
    $oFarnebackOpticalFlow.getPyrScale() -> retval
```

### cv::FarnebackOpticalFlow::setPyrScale

```cpp
void cv::FarnebackOpticalFlow::setPyrScale( double pyrScale )

AutoIt:
    $oFarnebackOpticalFlow.setPyrScale( $pyrScale ) -> None
```

### cv::FarnebackOpticalFlow::getFastPyramids

```cpp
bool cv::FarnebackOpticalFlow::getFastPyramids()

AutoIt:
    $oFarnebackOpticalFlow.getFastPyramids() -> retval
```

### cv::FarnebackOpticalFlow::setFastPyramids

```cpp
void cv::FarnebackOpticalFlow::setFastPyramids( bool fastPyramids )

AutoIt:
    $oFarnebackOpticalFlow.setFastPyramids( $fastPyramids ) -> None
```

### cv::FarnebackOpticalFlow::getWinSize

```cpp
int cv::FarnebackOpticalFlow::getWinSize()

AutoIt:
    $oFarnebackOpticalFlow.getWinSize() -> retval
```

### cv::FarnebackOpticalFlow::setWinSize

```cpp
void cv::FarnebackOpticalFlow::setWinSize( int winSize )

AutoIt:
    $oFarnebackOpticalFlow.setWinSize( $winSize ) -> None
```

### cv::FarnebackOpticalFlow::getNumIters

```cpp
int cv::FarnebackOpticalFlow::getNumIters()

AutoIt:
    $oFarnebackOpticalFlow.getNumIters() -> retval
```

### cv::FarnebackOpticalFlow::setNumIters

```cpp
void cv::FarnebackOpticalFlow::setNumIters( int numIters )

AutoIt:
    $oFarnebackOpticalFlow.setNumIters( $numIters ) -> None
```

### cv::FarnebackOpticalFlow::getPolyN

```cpp
int cv::FarnebackOpticalFlow::getPolyN()

AutoIt:
    $oFarnebackOpticalFlow.getPolyN() -> retval
```

### cv::FarnebackOpticalFlow::setPolyN

```cpp
void cv::FarnebackOpticalFlow::setPolyN( int polyN )

AutoIt:
    $oFarnebackOpticalFlow.setPolyN( $polyN ) -> None
```

### cv::FarnebackOpticalFlow::getPolySigma

```cpp
double cv::FarnebackOpticalFlow::getPolySigma()

AutoIt:
    $oFarnebackOpticalFlow.getPolySigma() -> retval
```

### cv::FarnebackOpticalFlow::setPolySigma

```cpp
void cv::FarnebackOpticalFlow::setPolySigma( double polySigma )

AutoIt:
    $oFarnebackOpticalFlow.setPolySigma( $polySigma ) -> None
```

### cv::FarnebackOpticalFlow::getFlags

```cpp
int cv::FarnebackOpticalFlow::getFlags()

AutoIt:
    $oFarnebackOpticalFlow.getFlags() -> retval
```

### cv::FarnebackOpticalFlow::setFlags

```cpp
void cv::FarnebackOpticalFlow::setFlags( int flags )

AutoIt:
    $oFarnebackOpticalFlow.setFlags( $flags ) -> None
```

### cv::FarnebackOpticalFlow::create

```cpp
static cv::Ptr<cv::FarnebackOpticalFlow> cv::FarnebackOpticalFlow::create( int    numLevels = 5,
                                                                           double pyrScale = 0.5,
                                                                           bool   fastPyramids = false,
                                                                           int    winSize = 13,
                                                                           int    numIters = 10,
                                                                           int    polyN = 5,
                                                                           double polySigma = 1.1,
                                                                           int    flags = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv.FarnebackOpticalFlow").create( [$numLevels[, $pyrScale[, $fastPyramids[, $winSize[, $numIters[, $polyN[, $polySigma[, $flags]]]]]]]] ) -> retval
```

### cv::FarnebackOpticalFlow::calc

```cpp
void cv::FarnebackOpticalFlow::calc( _InputArray       I0,
                                     _InputArray       I1,
                                     _InputOutputArray flow )

AutoIt:
    $oFarnebackOpticalFlow.calc( $I0, $I1, $flow ) -> $flow
```

### cv::FarnebackOpticalFlow::collectGarbage

```cpp
void cv::FarnebackOpticalFlow::collectGarbage()

AutoIt:
    $oFarnebackOpticalFlow.collectGarbage() -> None
```

### cv::FarnebackOpticalFlow::clear

```cpp
void cv::FarnebackOpticalFlow::clear()

AutoIt:
    $oFarnebackOpticalFlow.clear() -> None
```

### cv::FarnebackOpticalFlow::write

```cpp
void cv::FarnebackOpticalFlow::write( const cv::Ptr<cv::FileStorage>& fs,
                                      const std::string&              name = String() )

AutoIt:
    $oFarnebackOpticalFlow.write( $fs[, $name] ) -> None
```

### cv::FarnebackOpticalFlow::read

```cpp
void cv::FarnebackOpticalFlow::read( const cv::FileNode& fn )

AutoIt:
    $oFarnebackOpticalFlow.read( $fn ) -> None
```

### cv::FarnebackOpticalFlow::empty

```cpp
bool cv::FarnebackOpticalFlow::empty()

AutoIt:
    $oFarnebackOpticalFlow.empty() -> retval
```

### cv::FarnebackOpticalFlow::save

```cpp
void cv::FarnebackOpticalFlow::save( const std::string& filename )

AutoIt:
    $oFarnebackOpticalFlow.save( $filename ) -> None
```

### cv::FarnebackOpticalFlow::getDefaultName

```cpp
std::string cv::FarnebackOpticalFlow::getDefaultName()

AutoIt:
    $oFarnebackOpticalFlow.getDefaultName() -> retval
```

## cv::VariationalRefinement

### cv::VariationalRefinement::calcUV

```cpp
void cv::VariationalRefinement::calcUV( _InputArray       I0,
                                        _InputArray       I1,
                                        _InputOutputArray flow_u,
                                        _InputOutputArray flow_v )

AutoIt:
    $oVariationalRefinement.calcUV( $I0, $I1, $flow_u, $flow_v ) -> $flow_u, $flow_v
```

### cv::VariationalRefinement::getFixedPointIterations

```cpp
int cv::VariationalRefinement::getFixedPointIterations()

AutoIt:
    $oVariationalRefinement.getFixedPointIterations() -> retval
```

### cv::VariationalRefinement::setFixedPointIterations

```cpp
void cv::VariationalRefinement::setFixedPointIterations( int val )

AutoIt:
    $oVariationalRefinement.setFixedPointIterations( $val ) -> None
```

### cv::VariationalRefinement::getSorIterations

```cpp
int cv::VariationalRefinement::getSorIterations()

AutoIt:
    $oVariationalRefinement.getSorIterations() -> retval
```

### cv::VariationalRefinement::setSorIterations

```cpp
void cv::VariationalRefinement::setSorIterations( int val )

AutoIt:
    $oVariationalRefinement.setSorIterations( $val ) -> None
```

### cv::VariationalRefinement::getOmega

```cpp
float cv::VariationalRefinement::getOmega()

AutoIt:
    $oVariationalRefinement.getOmega() -> retval
```

### cv::VariationalRefinement::setOmega

```cpp
void cv::VariationalRefinement::setOmega( float val )

AutoIt:
    $oVariationalRefinement.setOmega( $val ) -> None
```

### cv::VariationalRefinement::getAlpha

```cpp
float cv::VariationalRefinement::getAlpha()

AutoIt:
    $oVariationalRefinement.getAlpha() -> retval
```

### cv::VariationalRefinement::setAlpha

```cpp
void cv::VariationalRefinement::setAlpha( float val )

AutoIt:
    $oVariationalRefinement.setAlpha( $val ) -> None
```

### cv::VariationalRefinement::getDelta

```cpp
float cv::VariationalRefinement::getDelta()

AutoIt:
    $oVariationalRefinement.getDelta() -> retval
```

### cv::VariationalRefinement::setDelta

```cpp
void cv::VariationalRefinement::setDelta( float val )

AutoIt:
    $oVariationalRefinement.setDelta( $val ) -> None
```

### cv::VariationalRefinement::getGamma

```cpp
float cv::VariationalRefinement::getGamma()

AutoIt:
    $oVariationalRefinement.getGamma() -> retval
```

### cv::VariationalRefinement::setGamma

```cpp
void cv::VariationalRefinement::setGamma( float val )

AutoIt:
    $oVariationalRefinement.setGamma( $val ) -> None
```

### cv::VariationalRefinement::create

```cpp
static cv::Ptr<cv::VariationalRefinement> cv::VariationalRefinement::create()

AutoIt:
    _OpenCV_ObjCreate("cv.VariationalRefinement").create() -> retval
```

### cv::VariationalRefinement::calc

```cpp
void cv::VariationalRefinement::calc( _InputArray       I0,
                                      _InputArray       I1,
                                      _InputOutputArray flow )

AutoIt:
    $oVariationalRefinement.calc( $I0, $I1, $flow ) -> $flow
```

### cv::VariationalRefinement::collectGarbage

```cpp
void cv::VariationalRefinement::collectGarbage()

AutoIt:
    $oVariationalRefinement.collectGarbage() -> None
```

### cv::VariationalRefinement::clear

```cpp
void cv::VariationalRefinement::clear()

AutoIt:
    $oVariationalRefinement.clear() -> None
```

### cv::VariationalRefinement::write

```cpp
void cv::VariationalRefinement::write( const cv::Ptr<cv::FileStorage>& fs,
                                       const std::string&              name = String() )

AutoIt:
    $oVariationalRefinement.write( $fs[, $name] ) -> None
```

### cv::VariationalRefinement::read

```cpp
void cv::VariationalRefinement::read( const cv::FileNode& fn )

AutoIt:
    $oVariationalRefinement.read( $fn ) -> None
```

### cv::VariationalRefinement::empty

```cpp
bool cv::VariationalRefinement::empty()

AutoIt:
    $oVariationalRefinement.empty() -> retval
```

### cv::VariationalRefinement::save

```cpp
void cv::VariationalRefinement::save( const std::string& filename )

AutoIt:
    $oVariationalRefinement.save( $filename ) -> None
```

### cv::VariationalRefinement::getDefaultName

```cpp
std::string cv::VariationalRefinement::getDefaultName()

AutoIt:
    $oVariationalRefinement.getDefaultName() -> retval
```

## cv::DISOpticalFlow

### cv::DISOpticalFlow::getFinestScale

```cpp
int cv::DISOpticalFlow::getFinestScale()

AutoIt:
    $oDISOpticalFlow.getFinestScale() -> retval
```

### cv::DISOpticalFlow::setFinestScale

```cpp
void cv::DISOpticalFlow::setFinestScale( int val )

AutoIt:
    $oDISOpticalFlow.setFinestScale( $val ) -> None
```

### cv::DISOpticalFlow::getPatchSize

```cpp
int cv::DISOpticalFlow::getPatchSize()

AutoIt:
    $oDISOpticalFlow.getPatchSize() -> retval
```

### cv::DISOpticalFlow::setPatchSize

```cpp
void cv::DISOpticalFlow::setPatchSize( int val )

AutoIt:
    $oDISOpticalFlow.setPatchSize( $val ) -> None
```

### cv::DISOpticalFlow::getPatchStride

```cpp
int cv::DISOpticalFlow::getPatchStride()

AutoIt:
    $oDISOpticalFlow.getPatchStride() -> retval
```

### cv::DISOpticalFlow::setPatchStride

```cpp
void cv::DISOpticalFlow::setPatchStride( int val )

AutoIt:
    $oDISOpticalFlow.setPatchStride( $val ) -> None
```

### cv::DISOpticalFlow::getGradientDescentIterations

```cpp
int cv::DISOpticalFlow::getGradientDescentIterations()

AutoIt:
    $oDISOpticalFlow.getGradientDescentIterations() -> retval
```

### cv::DISOpticalFlow::setGradientDescentIterations

```cpp
void cv::DISOpticalFlow::setGradientDescentIterations( int val )

AutoIt:
    $oDISOpticalFlow.setGradientDescentIterations( $val ) -> None
```

### cv::DISOpticalFlow::getVariationalRefinementIterations

```cpp
int cv::DISOpticalFlow::getVariationalRefinementIterations()

AutoIt:
    $oDISOpticalFlow.getVariationalRefinementIterations() -> retval
```

### cv::DISOpticalFlow::setVariationalRefinementIterations

```cpp
void cv::DISOpticalFlow::setVariationalRefinementIterations( int val )

AutoIt:
    $oDISOpticalFlow.setVariationalRefinementIterations( $val ) -> None
```

### cv::DISOpticalFlow::getVariationalRefinementAlpha

```cpp
float cv::DISOpticalFlow::getVariationalRefinementAlpha()

AutoIt:
    $oDISOpticalFlow.getVariationalRefinementAlpha() -> retval
```

### cv::DISOpticalFlow::setVariationalRefinementAlpha

```cpp
void cv::DISOpticalFlow::setVariationalRefinementAlpha( float val )

AutoIt:
    $oDISOpticalFlow.setVariationalRefinementAlpha( $val ) -> None
```

### cv::DISOpticalFlow::getVariationalRefinementDelta

```cpp
float cv::DISOpticalFlow::getVariationalRefinementDelta()

AutoIt:
    $oDISOpticalFlow.getVariationalRefinementDelta() -> retval
```

### cv::DISOpticalFlow::setVariationalRefinementDelta

```cpp
void cv::DISOpticalFlow::setVariationalRefinementDelta( float val )

AutoIt:
    $oDISOpticalFlow.setVariationalRefinementDelta( $val ) -> None
```

### cv::DISOpticalFlow::getVariationalRefinementGamma

```cpp
float cv::DISOpticalFlow::getVariationalRefinementGamma()

AutoIt:
    $oDISOpticalFlow.getVariationalRefinementGamma() -> retval
```

### cv::DISOpticalFlow::setVariationalRefinementGamma

```cpp
void cv::DISOpticalFlow::setVariationalRefinementGamma( float val )

AutoIt:
    $oDISOpticalFlow.setVariationalRefinementGamma( $val ) -> None
```

### cv::DISOpticalFlow::getUseMeanNormalization

```cpp
bool cv::DISOpticalFlow::getUseMeanNormalization()

AutoIt:
    $oDISOpticalFlow.getUseMeanNormalization() -> retval
```

### cv::DISOpticalFlow::setUseMeanNormalization

```cpp
void cv::DISOpticalFlow::setUseMeanNormalization( bool val )

AutoIt:
    $oDISOpticalFlow.setUseMeanNormalization( $val ) -> None
```

### cv::DISOpticalFlow::getUseSpatialPropagation

```cpp
bool cv::DISOpticalFlow::getUseSpatialPropagation()

AutoIt:
    $oDISOpticalFlow.getUseSpatialPropagation() -> retval
```

### cv::DISOpticalFlow::setUseSpatialPropagation

```cpp
void cv::DISOpticalFlow::setUseSpatialPropagation( bool val )

AutoIt:
    $oDISOpticalFlow.setUseSpatialPropagation( $val ) -> None
```

### cv::DISOpticalFlow::create

```cpp
static cv::Ptr<cv::DISOpticalFlow> cv::DISOpticalFlow::create( int preset = DISOpticalFlow::PRESET_FAST )

AutoIt:
    _OpenCV_ObjCreate("cv.DISOpticalFlow").create( [$preset] ) -> retval
```

### cv::DISOpticalFlow::calc

```cpp
void cv::DISOpticalFlow::calc( _InputArray       I0,
                               _InputArray       I1,
                               _InputOutputArray flow )

AutoIt:
    $oDISOpticalFlow.calc( $I0, $I1, $flow ) -> $flow
```

### cv::DISOpticalFlow::collectGarbage

```cpp
void cv::DISOpticalFlow::collectGarbage()

AutoIt:
    $oDISOpticalFlow.collectGarbage() -> None
```

### cv::DISOpticalFlow::clear

```cpp
void cv::DISOpticalFlow::clear()

AutoIt:
    $oDISOpticalFlow.clear() -> None
```

### cv::DISOpticalFlow::write

```cpp
void cv::DISOpticalFlow::write( const cv::Ptr<cv::FileStorage>& fs,
                                const std::string&              name = String() )

AutoIt:
    $oDISOpticalFlow.write( $fs[, $name] ) -> None
```

### cv::DISOpticalFlow::read

```cpp
void cv::DISOpticalFlow::read( const cv::FileNode& fn )

AutoIt:
    $oDISOpticalFlow.read( $fn ) -> None
```

### cv::DISOpticalFlow::empty

```cpp
bool cv::DISOpticalFlow::empty()

AutoIt:
    $oDISOpticalFlow.empty() -> retval
```

### cv::DISOpticalFlow::save

```cpp
void cv::DISOpticalFlow::save( const std::string& filename )

AutoIt:
    $oDISOpticalFlow.save( $filename ) -> None
```

### cv::DISOpticalFlow::getDefaultName

```cpp
std::string cv::DISOpticalFlow::getDefaultName()

AutoIt:
    $oDISOpticalFlow.getDefaultName() -> retval
```

## cv::SparsePyrLKOpticalFlow

### cv::SparsePyrLKOpticalFlow::getWinSize

```cpp
cv::Size cv::SparsePyrLKOpticalFlow::getWinSize()

AutoIt:
    $oSparsePyrLKOpticalFlow.getWinSize() -> retval
```

### cv::SparsePyrLKOpticalFlow::setWinSize

```cpp
void cv::SparsePyrLKOpticalFlow::setWinSize( cv::Size winSize )

AutoIt:
    $oSparsePyrLKOpticalFlow.setWinSize( $winSize ) -> None
```

### cv::SparsePyrLKOpticalFlow::getMaxLevel

```cpp
int cv::SparsePyrLKOpticalFlow::getMaxLevel()

AutoIt:
    $oSparsePyrLKOpticalFlow.getMaxLevel() -> retval
```

### cv::SparsePyrLKOpticalFlow::setMaxLevel

```cpp
void cv::SparsePyrLKOpticalFlow::setMaxLevel( int maxLevel )

AutoIt:
    $oSparsePyrLKOpticalFlow.setMaxLevel( $maxLevel ) -> None
```

### cv::SparsePyrLKOpticalFlow::getTermCriteria

```cpp
cv::TermCriteria cv::SparsePyrLKOpticalFlow::getTermCriteria()

AutoIt:
    $oSparsePyrLKOpticalFlow.getTermCriteria() -> retval
```

### cv::SparsePyrLKOpticalFlow::setTermCriteria

```cpp
void cv::SparsePyrLKOpticalFlow::setTermCriteria( cv::TermCriteria& crit )

AutoIt:
    $oSparsePyrLKOpticalFlow.setTermCriteria( $crit ) -> None
```

### cv::SparsePyrLKOpticalFlow::getFlags

```cpp
int cv::SparsePyrLKOpticalFlow::getFlags()

AutoIt:
    $oSparsePyrLKOpticalFlow.getFlags() -> retval
```

### cv::SparsePyrLKOpticalFlow::setFlags

```cpp
void cv::SparsePyrLKOpticalFlow::setFlags( int flags )

AutoIt:
    $oSparsePyrLKOpticalFlow.setFlags( $flags ) -> None
```

### cv::SparsePyrLKOpticalFlow::getMinEigThreshold

```cpp
double cv::SparsePyrLKOpticalFlow::getMinEigThreshold()

AutoIt:
    $oSparsePyrLKOpticalFlow.getMinEigThreshold() -> retval
```

### cv::SparsePyrLKOpticalFlow::setMinEigThreshold

```cpp
void cv::SparsePyrLKOpticalFlow::setMinEigThreshold( double minEigThreshold )

AutoIt:
    $oSparsePyrLKOpticalFlow.setMinEigThreshold( $minEigThreshold ) -> None
```

### cv::SparsePyrLKOpticalFlow::create

```cpp
static cv::Ptr<cv::SparsePyrLKOpticalFlow> cv::SparsePyrLKOpticalFlow::create( cv::Size         winSize = Size(21, 21),
                                                                               int              maxLevel = 3,
                                                                               cv::TermCriteria crit = TermCriteria(TermCriteria::COUNT+TermCriteria::EPS, 30, 0.01),
                                                                               int              flags = 0,
                                                                               double           minEigThreshold = 1e-4 )

AutoIt:
    _OpenCV_ObjCreate("cv.SparsePyrLKOpticalFlow").create( [$winSize[, $maxLevel[, $crit[, $flags[, $minEigThreshold]]]]] ) -> retval
```

### cv::SparsePyrLKOpticalFlow::calc

```cpp
void cv::SparsePyrLKOpticalFlow::calc( _InputArray       prevImg,
                                       _InputArray       nextImg,
                                       _InputArray       prevPts,
                                       _InputOutputArray nextPts,
                                       _OutputArray      status,
                                       _OutputArray      err = cv::noArray() )

AutoIt:
    $oSparsePyrLKOpticalFlow.calc( $prevImg, $nextImg, $prevPts, $nextPts[, $status[, $err]] ) -> $nextPts, $status, $err
```

### cv::SparsePyrLKOpticalFlow::clear

```cpp
void cv::SparsePyrLKOpticalFlow::clear()

AutoIt:
    $oSparsePyrLKOpticalFlow.clear() -> None
```

### cv::SparsePyrLKOpticalFlow::write

```cpp
void cv::SparsePyrLKOpticalFlow::write( const cv::Ptr<cv::FileStorage>& fs,
                                        const std::string&              name = String() )

AutoIt:
    $oSparsePyrLKOpticalFlow.write( $fs[, $name] ) -> None
```

### cv::SparsePyrLKOpticalFlow::read

```cpp
void cv::SparsePyrLKOpticalFlow::read( const cv::FileNode& fn )

AutoIt:
    $oSparsePyrLKOpticalFlow.read( $fn ) -> None
```

### cv::SparsePyrLKOpticalFlow::empty

```cpp
bool cv::SparsePyrLKOpticalFlow::empty()

AutoIt:
    $oSparsePyrLKOpticalFlow.empty() -> retval
```

### cv::SparsePyrLKOpticalFlow::save

```cpp
void cv::SparsePyrLKOpticalFlow::save( const std::string& filename )

AutoIt:
    $oSparsePyrLKOpticalFlow.save( $filename ) -> None
```

### cv::SparsePyrLKOpticalFlow::getDefaultName

```cpp
std::string cv::SparsePyrLKOpticalFlow::getDefaultName()

AutoIt:
    $oSparsePyrLKOpticalFlow.getDefaultName() -> retval
```

## cv::Tracker

### cv::Tracker::init

```cpp
void cv::Tracker::init( _InputArray     image,
                        const cv::Rect& boundingBox )

AutoIt:
    $oTracker.init( $image, $boundingBox ) -> None
```

### cv::Tracker::update

```cpp
bool cv::Tracker::update( _InputArray image,
                          cv::Rect&   boundingBox )

AutoIt:
    $oTracker.update( $image[, $boundingBox] ) -> retval, $boundingBox
```

## cv::TrackerMIL

### cv::TrackerMIL::create

```cpp
static cv::Ptr<cv::TrackerMIL> cv::TrackerMIL::create( const cv::TrackerMIL::Params& parameters = TrackerMIL::Params() )

AutoIt:
    _OpenCV_ObjCreate("cv.TrackerMIL").create( [$parameters] ) -> retval
```

### cv::TrackerMIL::init

```cpp
void cv::TrackerMIL::init( _InputArray     image,
                           const cv::Rect& boundingBox )

AutoIt:
    $oTrackerMIL.init( $image, $boundingBox ) -> None
```

### cv::TrackerMIL::update

```cpp
bool cv::TrackerMIL::update( _InputArray image,
                             cv::Rect&   boundingBox )

AutoIt:
    $oTrackerMIL.update( $image[, $boundingBox] ) -> retval, $boundingBox
```

## cv::TrackerMIL::Params

### cv::TrackerMIL::Params::create

```cpp
static cv::TrackerMIL::Params cv::TrackerMIL::Params::create()

AutoIt:
    _OpenCV_ObjCreate("cv.TrackerMIL.Params").create() -> <cv.TrackerMIL.Params object>
```

```cpp
static cv::TrackerMIL::Params cv::TrackerMIL::Params::create()

AutoIt:
    _OpenCV_ObjCreate("cv.TrackerMIL.Params").create() -> <cv.TrackerMIL.Params object>
```

## cv::TrackerGOTURN

### cv::TrackerGOTURN::create

```cpp
static cv::Ptr<cv::TrackerGOTURN> cv::TrackerGOTURN::create( const cv::TrackerGOTURN::Params& parameters = TrackerGOTURN::Params() )

AutoIt:
    _OpenCV_ObjCreate("cv.TrackerGOTURN").create( [$parameters] ) -> retval
```

### cv::TrackerGOTURN::init

```cpp
void cv::TrackerGOTURN::init( _InputArray     image,
                              const cv::Rect& boundingBox )

AutoIt:
    $oTrackerGOTURN.init( $image, $boundingBox ) -> None
```

### cv::TrackerGOTURN::update

```cpp
bool cv::TrackerGOTURN::update( _InputArray image,
                                cv::Rect&   boundingBox )

AutoIt:
    $oTrackerGOTURN.update( $image[, $boundingBox] ) -> retval, $boundingBox
```

## cv::TrackerGOTURN::Params

### cv::TrackerGOTURN::Params::create

```cpp
static cv::TrackerGOTURN::Params cv::TrackerGOTURN::Params::create()

AutoIt:
    _OpenCV_ObjCreate("cv.TrackerGOTURN.Params").create() -> <cv.TrackerGOTURN.Params object>
```

```cpp
static cv::TrackerGOTURN::Params cv::TrackerGOTURN::Params::create()

AutoIt:
    _OpenCV_ObjCreate("cv.TrackerGOTURN.Params").create() -> <cv.TrackerGOTURN.Params object>
```

## cv::TrackerDaSiamRPN

### cv::TrackerDaSiamRPN::create

```cpp
static cv::Ptr<cv::TrackerDaSiamRPN> cv::TrackerDaSiamRPN::create( const cv::TrackerDaSiamRPN::Params& parameters = TrackerDaSiamRPN::Params() )

AutoIt:
    _OpenCV_ObjCreate("cv.TrackerDaSiamRPN").create( [$parameters] ) -> retval
```

### cv::TrackerDaSiamRPN::getTrackingScore

```cpp
float cv::TrackerDaSiamRPN::getTrackingScore()

AutoIt:
    $oTrackerDaSiamRPN.getTrackingScore() -> retval
```

### cv::TrackerDaSiamRPN::init

```cpp
void cv::TrackerDaSiamRPN::init( _InputArray     image,
                                 const cv::Rect& boundingBox )

AutoIt:
    $oTrackerDaSiamRPN.init( $image, $boundingBox ) -> None
```

### cv::TrackerDaSiamRPN::update

```cpp
bool cv::TrackerDaSiamRPN::update( _InputArray image,
                                   cv::Rect&   boundingBox )

AutoIt:
    $oTrackerDaSiamRPN.update( $image[, $boundingBox] ) -> retval, $boundingBox
```

## cv::TrackerDaSiamRPN::Params

### cv::TrackerDaSiamRPN::Params::create

```cpp
static cv::TrackerDaSiamRPN::Params cv::TrackerDaSiamRPN::Params::create()

AutoIt:
    _OpenCV_ObjCreate("cv.TrackerDaSiamRPN.Params").create() -> <cv.TrackerDaSiamRPN.Params object>
```

```cpp
static cv::TrackerDaSiamRPN::Params cv::TrackerDaSiamRPN::Params::create()

AutoIt:
    _OpenCV_ObjCreate("cv.TrackerDaSiamRPN.Params").create() -> <cv.TrackerDaSiamRPN.Params object>
```

## cv::gapi

### cv::gapi::add

```cpp
cv::GMat cv::gapi::add( const cv::GMat& src1,
                        const cv::GMat& src2,
                        int             ddepth = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").add( $src1, $src2[, $ddepth] ) -> retval
```

### cv::gapi::addC

```cpp
cv::GMat cv::gapi::addC( const cv::GMat&    src1,
                         const cv::GScalar& c,
                         int                ddepth = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").addC( $src1, $c[, $ddepth] ) -> retval
```

### cv::gapi::mean

```cpp
cv::GScalar cv::gapi::mean( const cv::GMat& src )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").mean( $src ) -> retval
```

### cv::gapi::threshold

```cpp
std::tuple<cv::GMat, cv::GScalar> cv::gapi::threshold( const cv::GMat&    src,
                                                       const cv::GScalar& maxval,
                                                       int                type )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").threshold( $src, $maxval, $type ) -> retval
```

### cv::gapi::resize

```cpp
cv::GMat cv::gapi::resize( const cv::GMat& src,
                           const cv::Size& dsize,
                           double          fx = 0,
                           double          fy = 0,
                           int             interpolation = INTER_LINEAR )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").resize( $src, $dsize[, $fx[, $fy[, $interpolation]]] ) -> retval
```

### cv::gapi::split3

```cpp
std::tuple<cv::GMat, cv::GMat, cv::GMat> cv::gapi::split3( const cv::GMat& src )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").split3( $src ) -> retval
```

### cv::gapi::kmeans

```cpp
std::tuple<cv::GOpaque<double>, cv::GMat, cv::GMat> cv::gapi::kmeans( const cv::GMat&         data,
                                                                      const int               K,
                                                                      const cv::TermCriteria& criteria,
                                                                      const int               attempts,
                                                                      const int               flags )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").kmeans( $data, $K, $criteria, $attempts, $flags ) -> retval
```

```cpp
std::tuple<cv::GOpaque<double>, cv::GArray<int>, cv::GArray<cv::Point2f>> cv::gapi::kmeans( const cv::GArray<cv::Point2f>& data,
                                                                                            const int                      K,
                                                                                            const cv::GArray<int>&         bestLabels,
                                                                                            const cv::TermCriteria&        criteria,
                                                                                            const int                      attempts,
                                                                                            const int                      flags )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").kmeans( $data, $K, $bestLabels, $criteria, $attempts, $flags ) -> retval
```

### cv::gapi::medianBlur

```cpp
cv::GMat cv::gapi::medianBlur( const cv::GMat& src,
                               int             ksize )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").medianBlur( $src, $ksize ) -> retval
```

### cv::gapi::goodFeaturesToTrack

```cpp
cv::GArray<cv::Point2f> cv::gapi::goodFeaturesToTrack( const cv::GMat& image,
                                                       int             maxCorners,
                                                       double          qualityLevel,
                                                       double          minDistance,
                                                       const cv::Mat&  mask = Mat(),
                                                       int             blockSize = 3,
                                                       bool            useHarrisDetector = false,
                                                       double          k = 0.04 )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").goodFeaturesToTrack( $image, $maxCorners, $qualityLevel, $minDistance[, $mask[, $blockSize[, $useHarrisDetector[, $k]]]] ) -> retval
```

### cv::gapi::boundingRect

```cpp
cv::GOpaque<cv::Rect> cv::gapi::boundingRect( const cv::GMat& src )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").boundingRect( $src ) -> retval
```

```cpp
cv::GOpaque<cv::Rect> cv::gapi::boundingRect( const cv::GArray<cv::Point2i>& src )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").boundingRect( $src ) -> retval
```

### cv::gapi::BGR2RGB

```cpp
cv::GMat cv::gapi::BGR2RGB( const cv::GMat& src )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").BGR2RGB( $src ) -> retval
```

### cv::gapi::RGB2Gray

```cpp
cv::GMat cv::gapi::RGB2Gray( const cv::GMat& src )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").RGB2Gray( $src ) -> retval
```

### cv::gapi::parseSSD

```cpp
std::tuple<cv::GArray<cv::Rect>, cv::GArray<int>> cv::gapi::parseSSD( const cv::GMat&              in,
                                                                      const cv::GOpaque<cv::Size>& inSz,
                                                                      const float                  confidenceThreshold = 0.5f,
                                                                      const int                    filterLabel = -1 )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").parseSSD( $in, $inSz[, $confidenceThreshold[, $filterLabel]] ) -> retval
```

```cpp
cv::GArray<cv::Rect> cv::gapi::parseSSD( const cv::GMat&              in,
                                         const cv::GOpaque<cv::Size>& inSz,
                                         const float                  confidenceThreshold,
                                         const bool                   alignmentToSquare,
                                         const bool                   filterOutOfBounds )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").parseSSD( $in, $inSz, $confidenceThreshold, $alignmentToSquare, $filterOutOfBounds ) -> retval
```

### cv::gapi::parseYolo

```cpp
std::tuple<cv::GArray<cv::Rect>, cv::GArray<int>> cv::gapi::parseYolo( const cv::GMat&              in,
                                                                       const cv::GOpaque<cv::Size>& inSz,
                                                                       const float                  confidenceThreshold = 0.5f,
                                                                       const float                  nmsThreshold = 0.5f,
                                                                       const std::vector<float>&    anchors = nn::parsers::GParseYolo::defaultAnchors() )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").parseYolo( $in, $inSz[, $confidenceThreshold[, $nmsThreshold[, $anchors]]] ) -> retval
```

### cv::gapi::copy

```cpp
cv::GMat cv::gapi::copy( const cv::GMat& in )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi").copy( $in ) -> retval
```

## cv::gapi::streaming

### cv::gapi::streaming::size

```cpp
cv::GOpaque<cv::Size> cv::gapi::streaming::size( const cv::GMat& src )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.streaming").size( $src ) -> retval
```

```cpp
cv::GOpaque<cv::Size> cv::gapi::streaming::size( const cv::GOpaque<cv::Rect>& r )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.streaming").size( $r ) -> retval
```

## cv::gapi::core::cpu

### cv::gapi::core::cpu::kernels

```cpp
cv::gapi::GKernelPackage cv::gapi::core::cpu::kernels()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.core.cpu").kernels() -> retval
```

## cv::gapi::core::fluid

### cv::gapi::core::fluid::kernels

```cpp
cv::gapi::GKernelPackage cv::gapi::core::fluid::kernels()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.core.fluid").kernels() -> retval
```

## cv::GArrayDesc

### cv::GArrayDesc::create

```cpp
static cv::GArrayDesc cv::GArrayDesc::create()

AutoIt:
    _OpenCV_ObjCreate("cv.GArrayDesc").create() -> <cv.GArrayDesc object>
```

## cv::GComputation

### cv::GComputation::create

```cpp
static cv::GComputation cv::GComputation::create( cv::GProtoInputArgs  ins,
                                                  cv::GProtoOutputArgs outs )

AutoIt:
    _OpenCV_ObjCreate("cv.GComputation").create( $ins, $outs ) -> <cv.GComputation object>
```

```cpp
static cv::GComputation cv::GComputation::create( cv::GMat in,
                                                  cv::GMat out )

AutoIt:
    _OpenCV_ObjCreate("cv.GComputation").create( $in, $out ) -> <cv.GComputation object>
```

```cpp
static cv::GComputation cv::GComputation::create( cv::GMat    in,
                                                  cv::GScalar out )

AutoIt:
    _OpenCV_ObjCreate("cv.GComputation").create( $in, $out ) -> <cv.GComputation object>
```

```cpp
static cv::GComputation cv::GComputation::create( cv::GMat in1,
                                                  cv::GMat in2,
                                                  cv::GMat out )

AutoIt:
    _OpenCV_ObjCreate("cv.GComputation").create( $in1, $in2, $out ) -> <cv.GComputation object>
```

### cv::GComputation::apply

```cpp
std::vector<cv::GRunArg> cv::GComputation::apply( const cv::detail::ExtractArgsCallback& callback,
                                                  std::vector<cv::GCompileArg>           args = {} )

AutoIt:
    $oGComputation.apply( $callback[, $args] ) -> retval
```

### cv::GComputation::compileStreaming

```cpp
cv::GStreamingCompiled cv::GComputation::compileStreaming( std::vector<GMetaArg>        in_metas,
                                                           std::vector<cv::GCompileArg> args = {} )

AutoIt:
    $oGComputation.compileStreaming( $in_metas[, $args] ) -> retval
```

```cpp
cv::GStreamingCompiled cv::GComputation::compileStreaming( std::vector<cv::GCompileArg> args = {} )

AutoIt:
    $oGComputation.compileStreaming( [$args] ) -> retval
```

```cpp
cv::GStreamingCompiled cv::GComputation::compileStreaming( const cv::detail::ExtractMetaCallback& callback,
                                                           std::vector<cv::GCompileArg>           args = {} )

AutoIt:
    $oGComputation.compileStreaming( $callback[, $args] ) -> retval
```

## cv::GFrame

### cv::GFrame::create

```cpp
static cv::GFrame cv::GFrame::create()

AutoIt:
    _OpenCV_ObjCreate("cv.GFrame").create() -> <cv.GFrame object>
```

## cv::GMat

### cv::GMat::create

```cpp
static cv::GMat cv::GMat::create()

AutoIt:
    _OpenCV_ObjCreate("cv.GMat").create() -> <cv.GMat object>
```

## cv::GMatDesc

### cv::GMatDesc::create

```cpp
static cv::GMatDesc cv::GMatDesc::create()

AutoIt:
    _OpenCV_ObjCreate("cv.GMatDesc").create() -> <cv.GMatDesc object>
```

```cpp
static cv::GMatDesc cv::GMatDesc::create( int      d,
                                          int      c,
                                          cv::Size s,
                                          bool     p = false )

AutoIt:
    _OpenCV_ObjCreate("cv.GMatDesc").create( $d, $c, $s[, $p] ) -> <cv.GMatDesc object>
```

```cpp
static cv::GMatDesc cv::GMatDesc::create( int                     d,
                                          const std::vector<int>& dd )

AutoIt:
    _OpenCV_ObjCreate("cv.GMatDesc").create( $d, $dd ) -> <cv.GMatDesc object>
```

```cpp
static cv::GMatDesc cv::GMatDesc::create( int              d,
                                          std::vector<int> dd )

AutoIt:
    _OpenCV_ObjCreate("cv.GMatDesc").create( $d, $dd ) -> <cv.GMatDesc object>
```

```cpp
static cv::GMatDesc cv::GMatDesc::create()

AutoIt:
    _OpenCV_ObjCreate("cv.GMatDesc").create() -> <cv.GMatDesc object>
```

### cv::GMatDesc::withSizeDelta

```cpp
cv::GMatDesc cv::GMatDesc::withSizeDelta( cv::Size delta )

AutoIt:
    $oGMatDesc.withSizeDelta( $delta ) -> retval
```

```cpp
cv::GMatDesc cv::GMatDesc::withSizeDelta( int dx,
                                          int dy )

AutoIt:
    $oGMatDesc.withSizeDelta( $dx, $dy ) -> retval
```

### cv::GMatDesc::withSize

```cpp
cv::GMatDesc cv::GMatDesc::withSize( cv::Size sz )

AutoIt:
    $oGMatDesc.withSize( $sz ) -> retval
```

### cv::GMatDesc::withDepth

```cpp
cv::GMatDesc cv::GMatDesc::withDepth( int ddepth )

AutoIt:
    $oGMatDesc.withDepth( $ddepth ) -> retval
```

### cv::GMatDesc::withType

```cpp
cv::GMatDesc cv::GMatDesc::withType( int ddepth,
                                     int dchan )

AutoIt:
    $oGMatDesc.withType( $ddepth, $dchan ) -> retval
```

### cv::GMatDesc::asPlanar

```cpp
cv::GMatDesc cv::GMatDesc::asPlanar()

AutoIt:
    $oGMatDesc.asPlanar() -> retval
```

```cpp
cv::GMatDesc cv::GMatDesc::asPlanar( int planes )

AutoIt:
    $oGMatDesc.asPlanar( $planes ) -> retval
```

### cv::GMatDesc::asInterleaved

```cpp
cv::GMatDesc cv::GMatDesc::asInterleaved()

AutoIt:
    $oGMatDesc.asInterleaved() -> retval
```

## cv::GOpaqueDesc

### cv::GOpaqueDesc::create

```cpp
static cv::GOpaqueDesc cv::GOpaqueDesc::create()

AutoIt:
    _OpenCV_ObjCreate("cv.GOpaqueDesc").create() -> <cv.GOpaqueDesc object>
```

## cv::GScalar

### cv::GScalar::create

```cpp
static cv::GScalar cv::GScalar::create()

AutoIt:
    _OpenCV_ObjCreate("cv.GScalar").create() -> <cv.GScalar object>
```

## cv::GScalarDesc

### cv::GScalarDesc::create

```cpp
static cv::GScalarDesc cv::GScalarDesc::create()

AutoIt:
    _OpenCV_ObjCreate("cv.GScalarDesc").create() -> <cv.GScalarDesc object>
```

## cv::GStreamingCompiled

### cv::GStreamingCompiled::create

```cpp
static cv::GStreamingCompiled cv::GStreamingCompiled::create()

AutoIt:
    _OpenCV_ObjCreate("cv.GStreamingCompiled").create() -> <cv.GStreamingCompiled object>
```

### cv::GStreamingCompiled::setSource

```cpp
void cv::GStreamingCompiled::setSource( const cv::detail::ExtractArgsCallback& callback )

AutoIt:
    $oGStreamingCompiled.setSource( $callback ) -> None
```

### cv::GStreamingCompiled::start

```cpp
void cv::GStreamingCompiled::start()

AutoIt:
    $oGStreamingCompiled.start() -> None
```

### cv::GStreamingCompiled::pull

```cpp
std::tuple<bool, util_variant_GRunArgs, GOptRunArgs> cv::GStreamingCompiled::pull()

AutoIt:
    $oGStreamingCompiled.pull() -> retval
```

### cv::GStreamingCompiled::stop

```cpp
void cv::GStreamingCompiled::stop()

AutoIt:
    $oGStreamingCompiled.stop() -> None
```

### cv::GStreamingCompiled::running

```cpp
bool cv::GStreamingCompiled::running()

AutoIt:
    $oGStreamingCompiled.running() -> retval
```

## cv::gapi::streaming::queue_capacity

### cv::gapi::streaming::queue_capacity::create

```cpp
static cv::gapi::streaming::queue_capacity cv::gapi::streaming::queue_capacity::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.streaming.queue_capacity").create() -> <cv.gapi.streaming.queue_capacity object>
```

```cpp
static cv::gapi::streaming::queue_capacity cv::gapi::streaming::queue_capacity::create( size_t cap = 1 )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.streaming.queue_capacity").create( [$cap] ) -> <cv.gapi.streaming.queue_capacity object>
```

## cv::gapi::GNetParam

### cv::gapi::GNetParam::create

```cpp
static cv::gapi::GNetParam cv::gapi::GNetParam::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.GNetParam").create() -> <cv.gapi.GNetParam object>
```

## cv::gapi::GNetPackage

### cv::gapi::GNetPackage::create

```cpp
static cv::gapi::GNetPackage cv::gapi::GNetPackage::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.GNetPackage").create() -> <cv.gapi.GNetPackage object>
```

```cpp
static cv::gapi::GNetPackage cv::gapi::GNetPackage::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.GNetPackage").create() -> <cv.gapi.GNetPackage object>
```

```cpp
static cv::gapi::GNetPackage cv::gapi::GNetPackage::create( std::vector<cv::gapi::GNetParam> nets )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.GNetPackage").create( $nets ) -> <cv.gapi.GNetPackage object>
```

## cv::gapi::ie

### cv::gapi::ie::params

```cpp
cv::gapi::ie::PyParams cv::gapi::ie::params( const std::string& tag,
                                             const std::string& model,
                                             const std::string& weights,
                                             const std::string& device )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.ie").params( $tag, $model, $weights, $device ) -> retval
```

```cpp
cv::gapi::ie::PyParams cv::gapi::ie::params( const std::string& tag,
                                             const std::string& model,
                                             const std::string& device )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.ie").params( $tag, $model, $device ) -> retval
```

## cv::gapi::ie::PyParams

### cv::gapi::ie::PyParams::create

```cpp
static cv::gapi::ie::PyParams cv::gapi::ie::PyParams::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.ie.PyParams").create() -> <cv.gapi.ie.PyParams object>
```

```cpp
static cv::gapi::ie::PyParams cv::gapi::ie::PyParams::create( const std::string& tag,
                                                              const std::string& model,
                                                              const std::string& weights,
                                                              const std::string& device )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.ie.PyParams").create( $tag, $model, $weights, $device ) -> <cv.gapi.ie.PyParams object>
```

```cpp
static cv::gapi::ie::PyParams cv::gapi::ie::PyParams::create( const std::string& tag,
                                                              const std::string& model,
                                                              const std::string& device )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.ie.PyParams").create( $tag, $model, $device ) -> <cv.gapi.ie.PyParams object>
```

### cv::gapi::ie::PyParams::constInput

```cpp
cv::gapi::ie::PyParams cv::gapi::ie::PyParams::constInput( const std::string& layer_name,
                                                           const cv::Mat&     data,
                                                           int                hint = TraitAs::TENSOR )

AutoIt:
    $oPyParams.constInput( $layer_name, $data[, $hint] ) -> retval
```

### cv::gapi::ie::PyParams::cfgNumRequests

```cpp
cv::gapi::ie::PyParams cv::gapi::ie::PyParams::cfgNumRequests( size_t nireq )

AutoIt:
    $oPyParams.cfgNumRequests( $nireq ) -> retval
```

### cv::gapi::ie::PyParams::cfgBatchSize

```cpp
cv::gapi::ie::PyParams cv::gapi::ie::PyParams::cfgBatchSize( const size_t size )

AutoIt:
    $oPyParams.cfgBatchSize( $size ) -> retval
```

## cv::gapi::core::ocl

### cv::gapi::core::ocl::kernels

```cpp
cv::gapi::GKernelPackage cv::gapi::core::ocl::kernels()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.core.ocl").kernels() -> retval
```

## cv::gapi::wip

### cv::gapi::wip::make_capture_src

```cpp
cv::Ptr<cv::gapi::wip::IStreamSource> cv::gapi::wip::make_capture_src( const std::string& path )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip").make_capture_src( $path ) -> retval
```

## cv::gapi::wip::draw

### cv::gapi::wip::draw::render

```cpp
void cv::gapi::wip::draw::render( cv::Mat&                                      bgr,
                                  const std::vector<cv::gapi::wip::draw::Prim>& prims,
                                  std::vector<cv::GCompileArg>                  args = {} )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw").render( $bgr, $prims[, $args] ) -> None
```

```cpp
void cv::gapi::wip::draw::render( cv::Mat&                                      y_plane,
                                  cv::Mat&                                      uv_plane,
                                  const std::vector<cv::gapi::wip::draw::Prim>& prims,
                                  std::vector<cv::GCompileArg>                  args = {} )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw").render( $y_plane, $uv_plane, $prims[, $args] ) -> None
```

### cv::gapi::wip::draw::render3ch

```cpp
cv::GMat cv::gapi::wip::draw::render3ch( const cv::GMat&                              src,
                                         const cv::GArray<cv::gapi::wip::draw::Prim>& prims )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw").render3ch( $src, $prims ) -> retval
```

### cv::gapi::wip::draw::renderNV12

```cpp
std::tuple<cv::GMat, cv::GMat> cv::gapi::wip::draw::renderNV12( const cv::GMat&                              y,
                                                                const cv::GMat&                              uv,
                                                                const cv::GArray<cv::gapi::wip::draw::Prim>& prims )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw").renderNV12( $y, $uv, $prims ) -> retval
```

## cv::gapi::render::ocv

### cv::gapi::render::ocv::kernels

```cpp
cv::gapi::GKernelPackage cv::gapi::render::ocv::kernels()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.render.ocv").kernels() -> retval
```

## cv::gapi::wip::draw::Text

### cv::gapi::wip::draw::Text::create

```cpp
static cv::gapi::wip::draw::Text cv::gapi::wip::draw::Text::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Text").create() -> <cv.gapi.wip.draw.Text object>
```

```cpp
static cv::gapi::wip::draw::Text cv::gapi::wip::draw::Text::create( const std::string& text_,
                                                                    const cv::Point&   org_,
                                                                    int                ff_,
                                                                    double             fs_,
                                                                    const cv::Scalar&  color_,
                                                                    int                thick_ = 1,
                                                                    int                lt_ = 8,
                                                                    bool               bottom_left_origin_ = false )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Text").create( $text_, $org_, $ff_, $fs_, $color_[, $thick_[, $lt_[, $bottom_left_origin_]]] ) -> <cv.gapi.wip.draw.Text object>
```

```cpp
static cv::gapi::wip::draw::Text cv::gapi::wip::draw::Text::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Text").create() -> <cv.gapi.wip.draw.Text object>
```

## cv::gapi::wip::draw::Rect

### cv::gapi::wip::draw::Rect::create

```cpp
static cv::gapi::wip::draw::Rect cv::gapi::wip::draw::Rect::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Rect").create() -> <cv.gapi.wip.draw.Rect object>
```

```cpp
static cv::gapi::wip::draw::Rect cv::gapi::wip::draw::Rect::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Rect").create() -> <cv.gapi.wip.draw.Rect object>
```

## cv::gapi::wip::draw::Circle

### cv::gapi::wip::draw::Circle::create

```cpp
static cv::gapi::wip::draw::Circle cv::gapi::wip::draw::Circle::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Circle").create() -> <cv.gapi.wip.draw.Circle object>
```

```cpp
static cv::gapi::wip::draw::Circle cv::gapi::wip::draw::Circle::create( const cv::Point&  center_,
                                                                        int               radius_,
                                                                        const cv::Scalar& color_,
                                                                        int               thick_ = 1,
                                                                        int               lt_ = 8,
                                                                        int               shift_ = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Circle").create( $center_, $radius_, $color_[, $thick_[, $lt_[, $shift_]]] ) -> <cv.gapi.wip.draw.Circle object>
```

```cpp
static cv::gapi::wip::draw::Circle cv::gapi::wip::draw::Circle::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Circle").create() -> <cv.gapi.wip.draw.Circle object>
```

## cv::gapi::wip::draw::Line

### cv::gapi::wip::draw::Line::create

```cpp
static cv::gapi::wip::draw::Line cv::gapi::wip::draw::Line::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Line").create() -> <cv.gapi.wip.draw.Line object>
```

```cpp
static cv::gapi::wip::draw::Line cv::gapi::wip::draw::Line::create( const cv::Point&  pt1_,
                                                                    const cv::Point&  pt2_,
                                                                    const cv::Scalar& color_,
                                                                    int               thick_ = 1,
                                                                    int               lt_ = 8,
                                                                    int               shift_ = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Line").create( $pt1_, $pt2_, $color_[, $thick_[, $lt_[, $shift_]]] ) -> <cv.gapi.wip.draw.Line object>
```

```cpp
static cv::gapi::wip::draw::Line cv::gapi::wip::draw::Line::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Line").create() -> <cv.gapi.wip.draw.Line object>
```

## cv::gapi::wip::draw::Mosaic

### cv::gapi::wip::draw::Mosaic::create

```cpp
static cv::gapi::wip::draw::Mosaic cv::gapi::wip::draw::Mosaic::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Mosaic").create() -> <cv.gapi.wip.draw.Mosaic object>
```

```cpp
static cv::gapi::wip::draw::Mosaic cv::gapi::wip::draw::Mosaic::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Mosaic").create() -> <cv.gapi.wip.draw.Mosaic object>
```

## cv::gapi::wip::draw::Image

### cv::gapi::wip::draw::Image::create

```cpp
static cv::gapi::wip::draw::Image cv::gapi::wip::draw::Image::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Image").create() -> <cv.gapi.wip.draw.Image object>
```

```cpp
static cv::gapi::wip::draw::Image cv::gapi::wip::draw::Image::create( const cv::Point& org_,
                                                                      const cv::Mat&   img_,
                                                                      const cv::Mat&   alpha_ )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Image").create( $org_, $img_, $alpha_ ) -> <cv.gapi.wip.draw.Image object>
```

```cpp
static cv::gapi::wip::draw::Image cv::gapi::wip::draw::Image::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Image").create() -> <cv.gapi.wip.draw.Image object>
```

## cv::gapi::wip::draw::Poly

### cv::gapi::wip::draw::Poly::create

```cpp
static cv::gapi::wip::draw::Poly cv::gapi::wip::draw::Poly::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Poly").create() -> <cv.gapi.wip.draw.Poly object>
```

```cpp
static cv::gapi::wip::draw::Poly cv::gapi::wip::draw::Poly::create( const std::vector<cv::Point>& points_,
                                                                    const cv::Scalar&             color_,
                                                                    int                           thick_ = 1,
                                                                    int                           lt_ = 8,
                                                                    int                           shift_ = 0 )

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Poly").create( $points_, $color_[, $thick_[, $lt_[, $shift_]]] ) -> <cv.gapi.wip.draw.Poly object>
```

```cpp
static cv::gapi::wip::draw::Poly cv::gapi::wip::draw::Poly::create()

AutoIt:
    _OpenCV_ObjCreate("cv.gapi.wip.draw.Poly").create() -> <cv.gapi.wip.draw.Poly object>
```

## cv::wgc

### cv::wgc::isWGCSupported

```cpp
bool cv::wgc::isWGCSupported()

AutoIt:
    _OpenCV_ObjCreate("cv.wgc").isWGCSupported() -> retval
```

### cv::wgc::createSimpleCapture

```cpp
cv::Ptr<cv::wgc::SimpleCapture> cv::wgc::createSimpleCapture()

AutoIt:
    _OpenCV_ObjCreate("cv.wgc").createSimpleCapture() -> retval
```

```cpp
cv::Ptr<cv::wgc::SimpleCapture> cv::wgc::createSimpleCapture( WGCFrameCallback handleFrame )

AutoIt:
    _OpenCV_ObjCreate("cv.wgc").createSimpleCapture( $handleFrame ) -> retval
```

### cv::wgc::BitBltCapture

```cpp
void cv::wgc::BitBltCapture( HWND     hWnd,
                             cv::Mat& dst,
                             WORD     channels = 4 )

AutoIt:
    _OpenCV_ObjCreate("cv.wgc").BitBltCapture( $hWnd[, $channels[, $dst]] ) -> $dst
```

## cv::wgc::SimpleCapture

### cv::wgc::SimpleCapture::setHandle

```cpp
bool cv::wgc::SimpleCapture::setHandle( HWND hWnd,
                                        WORD channels = 4 )

AutoIt:
    $oSimpleCapture.setHandle( $hWnd[, $channels] ) -> retval
```

### cv::wgc::SimpleCapture::Start

```cpp
bool cv::wgc::SimpleCapture::Start()

AutoIt:
    $oSimpleCapture.Start() -> retval
```

### cv::wgc::SimpleCapture::Pause

```cpp
bool cv::wgc::SimpleCapture::Pause()

AutoIt:
    $oSimpleCapture.Pause() -> retval
```

### cv::wgc::SimpleCapture::Resume

```cpp
bool cv::wgc::SimpleCapture::Resume()

AutoIt:
    $oSimpleCapture.Resume() -> retval
```

### cv::wgc::SimpleCapture::Stop

```cpp
bool cv::wgc::SimpleCapture::Stop()

AutoIt:
    $oSimpleCapture.Stop() -> retval
```

### cv::wgc::SimpleCapture::Paused

```cpp
bool cv::wgc::SimpleCapture::Paused()

AutoIt:
    $oSimpleCapture.Paused() -> retval
```

## cv::Range

### cv::Range::create

```cpp
static cv::Range cv::Range::create()

AutoIt:
    _OpenCV_ObjCreate("cv.Range").create() -> <cv.Range object>
```

```cpp
static cv::Range cv::Range::create( int start,
                                    int end )

AutoIt:
    _OpenCV_ObjCreate("cv.Range").create( $start, $end ) -> <cv.Range object>
```

### cv::Range::size

```cpp
int cv::Range::size()

AutoIt:
    $oRange.size() -> retval
```

### cv::Range::empty

```cpp
bool cv::Range::empty()

AutoIt:
    $oRange.empty() -> retval
```

### cv::Range::all

```cpp
static cv::Range cv::Range::all()

AutoIt:
    _OpenCV_ObjCreate("cv.Range").all() -> retval
```

## cv::RotatedRect

### cv::RotatedRect::create

```cpp
static cv::RotatedRect cv::RotatedRect::create()

AutoIt:
    _OpenCV_ObjCreate("cv.RotatedRect").create() -> <cv.RotatedRect object>
```

```cpp
static cv::RotatedRect cv::RotatedRect::create( cv::Point2f center,
                                                cv::Size2f  size,
                                                float       angle )

AutoIt:
    _OpenCV_ObjCreate("cv.RotatedRect").create( $center, $size, $angle ) -> <cv.RotatedRect object>
```

```cpp
static cv::RotatedRect cv::RotatedRect::create( cv::Point2f point1,
                                                cv::Point2f point2,
                                                cv::Point2f point3 )

AutoIt:
    _OpenCV_ObjCreate("cv.RotatedRect").create( $point1, $point2, $point3 ) -> <cv.RotatedRect object>
```

### cv::RotatedRect::boundingRect

```cpp
cv::Rect cv::RotatedRect::boundingRect()

AutoIt:
    $oRotatedRect.boundingRect() -> retval
```

## cv::GCompileArg

### cv::GCompileArg::create

```cpp
static cv::GCompileArg cv::GCompileArg::create()

AutoIt:
    _OpenCV_ObjCreate("cv.GCompileArg").create() -> <cv.GCompileArg object>
```

## cv::GRunArg

### cv::GRunArg::create

```cpp
static cv::GRunArg cv::GRunArg::create()

AutoIt:
    _OpenCV_ObjCreate("cv.GRunArg").create() -> <cv.GRunArg object>
```

## VectorOfVariant

### VectorOfVariant::create

```cpp
static VectorOfVariant VectorOfVariant::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVariant").create() -> <VectorOfVariant object>
```

```cpp
static VectorOfVariant VectorOfVariant::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVariant").create( $size ) -> <VectorOfVariant object>
```

```cpp
static VectorOfVariant VectorOfVariant::create( VectorOfVariant other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVariant").create( $other ) -> <VectorOfVariant object>
```

### VectorOfVariant::Keys

```cpp
std::vector<int> VectorOfVariant::Keys()

AutoIt:
    $oVectorOfVariant.Keys() -> retval
```

### VectorOfVariant::Items

```cpp
VectorOfVariant VectorOfVariant::Items()

AutoIt:
    $oVectorOfVariant.Items() -> retval
```

### VectorOfVariant::push_back

```cpp
void VectorOfVariant::push_back( _variant_t value )

AutoIt:
    $oVectorOfVariant.push_back( $value ) -> None
```

### VectorOfVariant::Add

```cpp
void VectorOfVariant::Add( _variant_t value )

AutoIt:
    $oVectorOfVariant.Add( $value ) -> None
```

### VectorOfVariant::Remove

```cpp
void VectorOfVariant::Remove( size_t index )

AutoIt:
    $oVectorOfVariant.Remove( $index ) -> None
```

### VectorOfVariant::at

```cpp
_variant_t VectorOfVariant::at( size_t index )

AutoIt:
    $oVectorOfVariant.at( $index ) -> retval
```

```cpp
void VectorOfVariant::at( size_t     index,
                          _variant_t value )

AutoIt:
    $oVectorOfVariant.at( $index, $value ) -> None
```

### VectorOfVariant::size

```cpp
size_t VectorOfVariant::size()

AutoIt:
    $oVectorOfVariant.size() -> retval
```

### VectorOfVariant::empty

```cpp
bool VectorOfVariant::empty()

AutoIt:
    $oVectorOfVariant.empty() -> retval
```

### VectorOfVariant::clear

```cpp
void VectorOfVariant::clear()

AutoIt:
    $oVectorOfVariant.clear() -> None
```

### VectorOfVariant::push_vector

```cpp
void VectorOfVariant::push_vector( VectorOfVariant other )

AutoIt:
    $oVectorOfVariant.push_vector( $other ) -> None
```

```cpp
void VectorOfVariant::push_vector( VectorOfVariant other,
                                   size_t          count,
                                   size_t          start = 0 )

AutoIt:
    $oVectorOfVariant.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVariant::slice

```cpp
VectorOfVariant VectorOfVariant::slice( size_t start = 0,
                                        size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVariant.slice( [$start[, $count]] ) -> retval
```

### VectorOfVariant::sort

```cpp
void VectorOfVariant::sort( void*  comparator,
                            size_t start = 0,
                            size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVariant.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVariant::sort_variant

```cpp
void VectorOfVariant::sort_variant( void*  comparator,
                                    size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVariant.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVariant::start

```cpp
void* VectorOfVariant::start()

AutoIt:
    $oVectorOfVariant.start() -> retval
```

### VectorOfVariant::end

```cpp
void* VectorOfVariant::end()

AutoIt:
    $oVectorOfVariant.end() -> retval
```

### VectorOfVariant::get_Item

```cpp
_variant_t VectorOfVariant::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVariant.Item( $vIndex ) -> retval
    VectorOfVariant( $vIndex ) -> retval
```

### VectorOfVariant::put_Item

```cpp
void VectorOfVariant::put_Item( size_t     vIndex,
                                _variant_t vItem )

AutoIt:
    $oVectorOfVariant.Item( $vIndex ) = $$vItem
```

## VectorOfMat

### VectorOfMat::create

```cpp
static VectorOfMat VectorOfMat::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfMat").create() -> <VectorOfMat object>
```

```cpp
static VectorOfMat VectorOfMat::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfMat").create( $size ) -> <VectorOfMat object>
```

```cpp
static VectorOfMat VectorOfMat::create( VectorOfMat other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfMat").create( $other ) -> <VectorOfMat object>
```

### VectorOfMat::Keys

```cpp
std::vector<int> VectorOfMat::Keys()

AutoIt:
    $oVectorOfMat.Keys() -> retval
```

### VectorOfMat::Items

```cpp
VectorOfMat VectorOfMat::Items()

AutoIt:
    $oVectorOfMat.Items() -> retval
```

### VectorOfMat::push_back

```cpp
void VectorOfMat::push_back( cv::Mat value )

AutoIt:
    $oVectorOfMat.push_back( $value ) -> None
```

### VectorOfMat::Add

```cpp
void VectorOfMat::Add( cv::Mat value )

AutoIt:
    $oVectorOfMat.Add( $value ) -> None
```

### VectorOfMat::Remove

```cpp
void VectorOfMat::Remove( size_t index )

AutoIt:
    $oVectorOfMat.Remove( $index ) -> None
```

### VectorOfMat::at

```cpp
cv::Mat VectorOfMat::at( size_t index )

AutoIt:
    $oVectorOfMat.at( $index ) -> retval
```

```cpp
void VectorOfMat::at( size_t  index,
                      cv::Mat value )

AutoIt:
    $oVectorOfMat.at( $index, $value ) -> None
```

### VectorOfMat::size

```cpp
size_t VectorOfMat::size()

AutoIt:
    $oVectorOfMat.size() -> retval
```

### VectorOfMat::empty

```cpp
bool VectorOfMat::empty()

AutoIt:
    $oVectorOfMat.empty() -> retval
```

### VectorOfMat::clear

```cpp
void VectorOfMat::clear()

AutoIt:
    $oVectorOfMat.clear() -> None
```

### VectorOfMat::push_vector

```cpp
void VectorOfMat::push_vector( VectorOfMat other )

AutoIt:
    $oVectorOfMat.push_vector( $other ) -> None
```

```cpp
void VectorOfMat::push_vector( VectorOfMat other,
                               size_t      count,
                               size_t      start = 0 )

AutoIt:
    $oVectorOfMat.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfMat::slice

```cpp
VectorOfMat VectorOfMat::slice( size_t start = 0,
                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfMat.slice( [$start[, $count]] ) -> retval
```

### VectorOfMat::sort

```cpp
void VectorOfMat::sort( void*  comparator,
                        size_t start = 0,
                        size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfMat.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfMat::sort_variant

```cpp
void VectorOfMat::sort_variant( void*  comparator,
                                size_t start = 0,
                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfMat.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfMat::start

```cpp
void* VectorOfMat::start()

AutoIt:
    $oVectorOfMat.start() -> retval
```

### VectorOfMat::end

```cpp
void* VectorOfMat::end()

AutoIt:
    $oVectorOfMat.end() -> retval
```

### VectorOfMat::get_Item

```cpp
cv::Mat VectorOfMat::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfMat.Item( $vIndex ) -> retval
    VectorOfMat( $vIndex ) -> retval
```

### VectorOfMat::put_Item

```cpp
void VectorOfMat::put_Item( size_t  vIndex,
                            cv::Mat vItem )

AutoIt:
    $oVectorOfMat.Item( $vIndex ) = $$vItem
```

## VectorOfInt

### VectorOfInt::create

```cpp
static VectorOfInt VectorOfInt::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfInt").create() -> <VectorOfInt object>
```

```cpp
static VectorOfInt VectorOfInt::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfInt").create( $size ) -> <VectorOfInt object>
```

```cpp
static VectorOfInt VectorOfInt::create( VectorOfInt other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfInt").create( $other ) -> <VectorOfInt object>
```

### VectorOfInt::Keys

```cpp
std::vector<int> VectorOfInt::Keys()

AutoIt:
    $oVectorOfInt.Keys() -> retval
```

### VectorOfInt::Items

```cpp
VectorOfInt VectorOfInt::Items()

AutoIt:
    $oVectorOfInt.Items() -> retval
```

### VectorOfInt::push_back

```cpp
void VectorOfInt::push_back( int value )

AutoIt:
    $oVectorOfInt.push_back( $value ) -> None
```

### VectorOfInt::Add

```cpp
void VectorOfInt::Add( int value )

AutoIt:
    $oVectorOfInt.Add( $value ) -> None
```

### VectorOfInt::Remove

```cpp
void VectorOfInt::Remove( size_t index )

AutoIt:
    $oVectorOfInt.Remove( $index ) -> None
```

### VectorOfInt::at

```cpp
int VectorOfInt::at( size_t index )

AutoIt:
    $oVectorOfInt.at( $index ) -> retval
```

```cpp
void VectorOfInt::at( size_t index,
                      int    value )

AutoIt:
    $oVectorOfInt.at( $index, $value ) -> None
```

### VectorOfInt::size

```cpp
size_t VectorOfInt::size()

AutoIt:
    $oVectorOfInt.size() -> retval
```

### VectorOfInt::empty

```cpp
bool VectorOfInt::empty()

AutoIt:
    $oVectorOfInt.empty() -> retval
```

### VectorOfInt::clear

```cpp
void VectorOfInt::clear()

AutoIt:
    $oVectorOfInt.clear() -> None
```

### VectorOfInt::push_vector

```cpp
void VectorOfInt::push_vector( VectorOfInt other )

AutoIt:
    $oVectorOfInt.push_vector( $other ) -> None
```

```cpp
void VectorOfInt::push_vector( VectorOfInt other,
                               size_t      count,
                               size_t      start = 0 )

AutoIt:
    $oVectorOfInt.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfInt::slice

```cpp
VectorOfInt VectorOfInt::slice( size_t start = 0,
                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfInt.slice( [$start[, $count]] ) -> retval
```

### VectorOfInt::sort

```cpp
void VectorOfInt::sort( void*  comparator,
                        size_t start = 0,
                        size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfInt.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfInt::sort_variant

```cpp
void VectorOfInt::sort_variant( void*  comparator,
                                size_t start = 0,
                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfInt.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfInt::start

```cpp
void* VectorOfInt::start()

AutoIt:
    $oVectorOfInt.start() -> retval
```

### VectorOfInt::end

```cpp
void* VectorOfInt::end()

AutoIt:
    $oVectorOfInt.end() -> retval
```

### VectorOfInt::get_Item

```cpp
int VectorOfInt::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfInt.Item( $vIndex ) -> retval
    VectorOfInt( $vIndex ) -> retval
```

### VectorOfInt::put_Item

```cpp
void VectorOfInt::put_Item( size_t vIndex,
                            int    vItem )

AutoIt:
    $oVectorOfInt.Item( $vIndex ) = $$vItem
```

## VectorOfFloat

### VectorOfFloat::create

```cpp
static VectorOfFloat VectorOfFloat::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfFloat").create() -> <VectorOfFloat object>
```

```cpp
static VectorOfFloat VectorOfFloat::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfFloat").create( $size ) -> <VectorOfFloat object>
```

```cpp
static VectorOfFloat VectorOfFloat::create( VectorOfFloat other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfFloat").create( $other ) -> <VectorOfFloat object>
```

### VectorOfFloat::Keys

```cpp
std::vector<int> VectorOfFloat::Keys()

AutoIt:
    $oVectorOfFloat.Keys() -> retval
```

### VectorOfFloat::Items

```cpp
VectorOfFloat VectorOfFloat::Items()

AutoIt:
    $oVectorOfFloat.Items() -> retval
```

### VectorOfFloat::push_back

```cpp
void VectorOfFloat::push_back( float value )

AutoIt:
    $oVectorOfFloat.push_back( $value ) -> None
```

### VectorOfFloat::Add

```cpp
void VectorOfFloat::Add( float value )

AutoIt:
    $oVectorOfFloat.Add( $value ) -> None
```

### VectorOfFloat::Remove

```cpp
void VectorOfFloat::Remove( size_t index )

AutoIt:
    $oVectorOfFloat.Remove( $index ) -> None
```

### VectorOfFloat::at

```cpp
float VectorOfFloat::at( size_t index )

AutoIt:
    $oVectorOfFloat.at( $index ) -> retval
```

```cpp
void VectorOfFloat::at( size_t index,
                        float  value )

AutoIt:
    $oVectorOfFloat.at( $index, $value ) -> None
```

### VectorOfFloat::size

```cpp
size_t VectorOfFloat::size()

AutoIt:
    $oVectorOfFloat.size() -> retval
```

### VectorOfFloat::empty

```cpp
bool VectorOfFloat::empty()

AutoIt:
    $oVectorOfFloat.empty() -> retval
```

### VectorOfFloat::clear

```cpp
void VectorOfFloat::clear()

AutoIt:
    $oVectorOfFloat.clear() -> None
```

### VectorOfFloat::push_vector

```cpp
void VectorOfFloat::push_vector( VectorOfFloat other )

AutoIt:
    $oVectorOfFloat.push_vector( $other ) -> None
```

```cpp
void VectorOfFloat::push_vector( VectorOfFloat other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfFloat.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfFloat::slice

```cpp
VectorOfFloat VectorOfFloat::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfFloat.slice( [$start[, $count]] ) -> retval
```

### VectorOfFloat::sort

```cpp
void VectorOfFloat::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfFloat.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfFloat::sort_variant

```cpp
void VectorOfFloat::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfFloat.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfFloat::start

```cpp
void* VectorOfFloat::start()

AutoIt:
    $oVectorOfFloat.start() -> retval
```

### VectorOfFloat::end

```cpp
void* VectorOfFloat::end()

AutoIt:
    $oVectorOfFloat.end() -> retval
```

### VectorOfFloat::get_Item

```cpp
float VectorOfFloat::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfFloat.Item( $vIndex ) -> retval
    VectorOfFloat( $vIndex ) -> retval
```

### VectorOfFloat::put_Item

```cpp
void VectorOfFloat::put_Item( size_t vIndex,
                              float  vItem )

AutoIt:
    $oVectorOfFloat.Item( $vIndex ) = $$vItem
```

## VectorOfPoint

### VectorOfPoint::create

```cpp
static VectorOfPoint VectorOfPoint::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfPoint").create() -> <VectorOfPoint object>
```

```cpp
static VectorOfPoint VectorOfPoint::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfPoint").create( $size ) -> <VectorOfPoint object>
```

```cpp
static VectorOfPoint VectorOfPoint::create( VectorOfPoint other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfPoint").create( $other ) -> <VectorOfPoint object>
```

### VectorOfPoint::Keys

```cpp
std::vector<int> VectorOfPoint::Keys()

AutoIt:
    $oVectorOfPoint.Keys() -> retval
```

### VectorOfPoint::Items

```cpp
VectorOfPoint VectorOfPoint::Items()

AutoIt:
    $oVectorOfPoint.Items() -> retval
```

### VectorOfPoint::push_back

```cpp
void VectorOfPoint::push_back( cv::Point value )

AutoIt:
    $oVectorOfPoint.push_back( $value ) -> None
```

### VectorOfPoint::Add

```cpp
void VectorOfPoint::Add( cv::Point value )

AutoIt:
    $oVectorOfPoint.Add( $value ) -> None
```

### VectorOfPoint::Remove

```cpp
void VectorOfPoint::Remove( size_t index )

AutoIt:
    $oVectorOfPoint.Remove( $index ) -> None
```

### VectorOfPoint::at

```cpp
cv::Point VectorOfPoint::at( size_t index )

AutoIt:
    $oVectorOfPoint.at( $index ) -> retval
```

```cpp
void VectorOfPoint::at( size_t    index,
                        cv::Point value )

AutoIt:
    $oVectorOfPoint.at( $index, $value ) -> None
```

### VectorOfPoint::size

```cpp
size_t VectorOfPoint::size()

AutoIt:
    $oVectorOfPoint.size() -> retval
```

### VectorOfPoint::empty

```cpp
bool VectorOfPoint::empty()

AutoIt:
    $oVectorOfPoint.empty() -> retval
```

### VectorOfPoint::clear

```cpp
void VectorOfPoint::clear()

AutoIt:
    $oVectorOfPoint.clear() -> None
```

### VectorOfPoint::push_vector

```cpp
void VectorOfPoint::push_vector( VectorOfPoint other )

AutoIt:
    $oVectorOfPoint.push_vector( $other ) -> None
```

```cpp
void VectorOfPoint::push_vector( VectorOfPoint other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfPoint.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfPoint::slice

```cpp
VectorOfPoint VectorOfPoint::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfPoint.slice( [$start[, $count]] ) -> retval
```

### VectorOfPoint::sort

```cpp
void VectorOfPoint::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfPoint.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPoint::sort_variant

```cpp
void VectorOfPoint::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfPoint.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPoint::start

```cpp
void* VectorOfPoint::start()

AutoIt:
    $oVectorOfPoint.start() -> retval
```

### VectorOfPoint::end

```cpp
void* VectorOfPoint::end()

AutoIt:
    $oVectorOfPoint.end() -> retval
```

### VectorOfPoint::get_Item

```cpp
cv::Point VectorOfPoint::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfPoint.Item( $vIndex ) -> retval
    VectorOfPoint( $vIndex ) -> retval
```

### VectorOfPoint::put_Item

```cpp
void VectorOfPoint::put_Item( size_t    vIndex,
                              cv::Point vItem )

AutoIt:
    $oVectorOfPoint.Item( $vIndex ) = $$vItem
```

## VectorOfKeyPoint

### VectorOfKeyPoint::create

```cpp
static VectorOfKeyPoint VectorOfKeyPoint::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfKeyPoint").create() -> <VectorOfKeyPoint object>
```

```cpp
static VectorOfKeyPoint VectorOfKeyPoint::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfKeyPoint").create( $size ) -> <VectorOfKeyPoint object>
```

```cpp
static VectorOfKeyPoint VectorOfKeyPoint::create( VectorOfKeyPoint other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfKeyPoint").create( $other ) -> <VectorOfKeyPoint object>
```

### VectorOfKeyPoint::Keys

```cpp
std::vector<int> VectorOfKeyPoint::Keys()

AutoIt:
    $oVectorOfKeyPoint.Keys() -> retval
```

### VectorOfKeyPoint::Items

```cpp
VectorOfKeyPoint VectorOfKeyPoint::Items()

AutoIt:
    $oVectorOfKeyPoint.Items() -> retval
```

### VectorOfKeyPoint::push_back

```cpp
void VectorOfKeyPoint::push_back( cv::KeyPoint value )

AutoIt:
    $oVectorOfKeyPoint.push_back( $value ) -> None
```

### VectorOfKeyPoint::Add

```cpp
void VectorOfKeyPoint::Add( cv::KeyPoint value )

AutoIt:
    $oVectorOfKeyPoint.Add( $value ) -> None
```

### VectorOfKeyPoint::Remove

```cpp
void VectorOfKeyPoint::Remove( size_t index )

AutoIt:
    $oVectorOfKeyPoint.Remove( $index ) -> None
```

### VectorOfKeyPoint::at

```cpp
cv::KeyPoint VectorOfKeyPoint::at( size_t index )

AutoIt:
    $oVectorOfKeyPoint.at( $index ) -> retval
```

```cpp
void VectorOfKeyPoint::at( size_t       index,
                           cv::KeyPoint value )

AutoIt:
    $oVectorOfKeyPoint.at( $index, $value ) -> None
```

### VectorOfKeyPoint::size

```cpp
size_t VectorOfKeyPoint::size()

AutoIt:
    $oVectorOfKeyPoint.size() -> retval
```

### VectorOfKeyPoint::empty

```cpp
bool VectorOfKeyPoint::empty()

AutoIt:
    $oVectorOfKeyPoint.empty() -> retval
```

### VectorOfKeyPoint::clear

```cpp
void VectorOfKeyPoint::clear()

AutoIt:
    $oVectorOfKeyPoint.clear() -> None
```

### VectorOfKeyPoint::push_vector

```cpp
void VectorOfKeyPoint::push_vector( VectorOfKeyPoint other )

AutoIt:
    $oVectorOfKeyPoint.push_vector( $other ) -> None
```

```cpp
void VectorOfKeyPoint::push_vector( VectorOfKeyPoint other,
                                    size_t           count,
                                    size_t           start = 0 )

AutoIt:
    $oVectorOfKeyPoint.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfKeyPoint::slice

```cpp
VectorOfKeyPoint VectorOfKeyPoint::slice( size_t start = 0,
                                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfKeyPoint.slice( [$start[, $count]] ) -> retval
```

### VectorOfKeyPoint::sort

```cpp
void VectorOfKeyPoint::sort( void*  comparator,
                             size_t start = 0,
                             size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfKeyPoint.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfKeyPoint::sort_variant

```cpp
void VectorOfKeyPoint::sort_variant( void*  comparator,
                                     size_t start = 0,
                                     size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfKeyPoint.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfKeyPoint::start

```cpp
void* VectorOfKeyPoint::start()

AutoIt:
    $oVectorOfKeyPoint.start() -> retval
```

### VectorOfKeyPoint::end

```cpp
void* VectorOfKeyPoint::end()

AutoIt:
    $oVectorOfKeyPoint.end() -> retval
```

### VectorOfKeyPoint::get_Item

```cpp
cv::KeyPoint VectorOfKeyPoint::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfKeyPoint.Item( $vIndex ) -> retval
    VectorOfKeyPoint( $vIndex ) -> retval
```

### VectorOfKeyPoint::put_Item

```cpp
void VectorOfKeyPoint::put_Item( size_t       vIndex,
                                 cv::KeyPoint vItem )

AutoIt:
    $oVectorOfKeyPoint.Item( $vIndex ) = $$vItem
```

## VectorOfDMatch

### VectorOfDMatch::create

```cpp
static VectorOfDMatch VectorOfDMatch::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfDMatch").create() -> <VectorOfDMatch object>
```

```cpp
static VectorOfDMatch VectorOfDMatch::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfDMatch").create( $size ) -> <VectorOfDMatch object>
```

```cpp
static VectorOfDMatch VectorOfDMatch::create( VectorOfDMatch other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfDMatch").create( $other ) -> <VectorOfDMatch object>
```

### VectorOfDMatch::Keys

```cpp
std::vector<int> VectorOfDMatch::Keys()

AutoIt:
    $oVectorOfDMatch.Keys() -> retval
```

### VectorOfDMatch::Items

```cpp
VectorOfDMatch VectorOfDMatch::Items()

AutoIt:
    $oVectorOfDMatch.Items() -> retval
```

### VectorOfDMatch::push_back

```cpp
void VectorOfDMatch::push_back( cv::DMatch value )

AutoIt:
    $oVectorOfDMatch.push_back( $value ) -> None
```

### VectorOfDMatch::Add

```cpp
void VectorOfDMatch::Add( cv::DMatch value )

AutoIt:
    $oVectorOfDMatch.Add( $value ) -> None
```

### VectorOfDMatch::Remove

```cpp
void VectorOfDMatch::Remove( size_t index )

AutoIt:
    $oVectorOfDMatch.Remove( $index ) -> None
```

### VectorOfDMatch::at

```cpp
cv::DMatch VectorOfDMatch::at( size_t index )

AutoIt:
    $oVectorOfDMatch.at( $index ) -> retval
```

```cpp
void VectorOfDMatch::at( size_t     index,
                         cv::DMatch value )

AutoIt:
    $oVectorOfDMatch.at( $index, $value ) -> None
```

### VectorOfDMatch::size

```cpp
size_t VectorOfDMatch::size()

AutoIt:
    $oVectorOfDMatch.size() -> retval
```

### VectorOfDMatch::empty

```cpp
bool VectorOfDMatch::empty()

AutoIt:
    $oVectorOfDMatch.empty() -> retval
```

### VectorOfDMatch::clear

```cpp
void VectorOfDMatch::clear()

AutoIt:
    $oVectorOfDMatch.clear() -> None
```

### VectorOfDMatch::push_vector

```cpp
void VectorOfDMatch::push_vector( VectorOfDMatch other )

AutoIt:
    $oVectorOfDMatch.push_vector( $other ) -> None
```

```cpp
void VectorOfDMatch::push_vector( VectorOfDMatch other,
                                  size_t         count,
                                  size_t         start = 0 )

AutoIt:
    $oVectorOfDMatch.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfDMatch::slice

```cpp
VectorOfDMatch VectorOfDMatch::slice( size_t start = 0,
                                      size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfDMatch.slice( [$start[, $count]] ) -> retval
```

### VectorOfDMatch::sort

```cpp
void VectorOfDMatch::sort( void*  comparator,
                           size_t start = 0,
                           size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfDMatch.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfDMatch::sort_variant

```cpp
void VectorOfDMatch::sort_variant( void*  comparator,
                                   size_t start = 0,
                                   size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfDMatch.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfDMatch::start

```cpp
void* VectorOfDMatch::start()

AutoIt:
    $oVectorOfDMatch.start() -> retval
```

### VectorOfDMatch::end

```cpp
void* VectorOfDMatch::end()

AutoIt:
    $oVectorOfDMatch.end() -> retval
```

### VectorOfDMatch::get_Item

```cpp
cv::DMatch VectorOfDMatch::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfDMatch.Item( $vIndex ) -> retval
    VectorOfDMatch( $vIndex ) -> retval
```

### VectorOfDMatch::put_Item

```cpp
void VectorOfDMatch::put_Item( size_t     vIndex,
                               cv::DMatch vItem )

AutoIt:
    $oVectorOfDMatch.Item( $vIndex ) = $$vItem
```

## VectorOfChar

### VectorOfChar::create

```cpp
static VectorOfChar VectorOfChar::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfChar").create() -> <VectorOfChar object>
```

```cpp
static VectorOfChar VectorOfChar::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfChar").create( $size ) -> <VectorOfChar object>
```

```cpp
static VectorOfChar VectorOfChar::create( VectorOfChar other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfChar").create( $other ) -> <VectorOfChar object>
```

### VectorOfChar::Keys

```cpp
std::vector<int> VectorOfChar::Keys()

AutoIt:
    $oVectorOfChar.Keys() -> retval
```

### VectorOfChar::Items

```cpp
VectorOfChar VectorOfChar::Items()

AutoIt:
    $oVectorOfChar.Items() -> retval
```

### VectorOfChar::push_back

```cpp
void VectorOfChar::push_back( char value )

AutoIt:
    $oVectorOfChar.push_back( $value ) -> None
```

### VectorOfChar::Add

```cpp
void VectorOfChar::Add( char value )

AutoIt:
    $oVectorOfChar.Add( $value ) -> None
```

### VectorOfChar::Remove

```cpp
void VectorOfChar::Remove( size_t index )

AutoIt:
    $oVectorOfChar.Remove( $index ) -> None
```

### VectorOfChar::at

```cpp
char VectorOfChar::at( size_t index )

AutoIt:
    $oVectorOfChar.at( $index ) -> retval
```

```cpp
void VectorOfChar::at( size_t index,
                       char   value )

AutoIt:
    $oVectorOfChar.at( $index, $value ) -> None
```

### VectorOfChar::size

```cpp
size_t VectorOfChar::size()

AutoIt:
    $oVectorOfChar.size() -> retval
```

### VectorOfChar::empty

```cpp
bool VectorOfChar::empty()

AutoIt:
    $oVectorOfChar.empty() -> retval
```

### VectorOfChar::clear

```cpp
void VectorOfChar::clear()

AutoIt:
    $oVectorOfChar.clear() -> None
```

### VectorOfChar::push_vector

```cpp
void VectorOfChar::push_vector( VectorOfChar other )

AutoIt:
    $oVectorOfChar.push_vector( $other ) -> None
```

```cpp
void VectorOfChar::push_vector( VectorOfChar other,
                                size_t       count,
                                size_t       start = 0 )

AutoIt:
    $oVectorOfChar.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfChar::slice

```cpp
VectorOfChar VectorOfChar::slice( size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfChar.slice( [$start[, $count]] ) -> retval
```

### VectorOfChar::sort

```cpp
void VectorOfChar::sort( void*  comparator,
                         size_t start = 0,
                         size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfChar.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfChar::sort_variant

```cpp
void VectorOfChar::sort_variant( void*  comparator,
                                 size_t start = 0,
                                 size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfChar.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfChar::start

```cpp
void* VectorOfChar::start()

AutoIt:
    $oVectorOfChar.start() -> retval
```

### VectorOfChar::end

```cpp
void* VectorOfChar::end()

AutoIt:
    $oVectorOfChar.end() -> retval
```

### VectorOfChar::get_Item

```cpp
char VectorOfChar::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfChar.Item( $vIndex ) -> retval
    VectorOfChar( $vIndex ) -> retval
```

### VectorOfChar::put_Item

```cpp
void VectorOfChar::put_Item( size_t vIndex,
                             char   vItem )

AutoIt:
    $oVectorOfChar.Item( $vIndex ) = $$vItem
```

## VectorOfVectorOfDMatch

### VectorOfVectorOfDMatch::create

```cpp
static VectorOfVectorOfDMatch VectorOfVectorOfDMatch::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfDMatch").create() -> <VectorOfVectorOfDMatch object>
```

```cpp
static VectorOfVectorOfDMatch VectorOfVectorOfDMatch::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfDMatch").create( $size ) -> <VectorOfVectorOfDMatch object>
```

```cpp
static VectorOfVectorOfDMatch VectorOfVectorOfDMatch::create( VectorOfVectorOfDMatch other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfDMatch").create( $other ) -> <VectorOfVectorOfDMatch object>
```

### VectorOfVectorOfDMatch::Keys

```cpp
std::vector<int> VectorOfVectorOfDMatch::Keys()

AutoIt:
    $oVectorOfVectorOfDMatch.Keys() -> retval
```

### VectorOfVectorOfDMatch::Items

```cpp
VectorOfVectorOfDMatch VectorOfVectorOfDMatch::Items()

AutoIt:
    $oVectorOfVectorOfDMatch.Items() -> retval
```

### VectorOfVectorOfDMatch::push_back

```cpp
void VectorOfVectorOfDMatch::push_back( std::vector<cv::DMatch> value )

AutoIt:
    $oVectorOfVectorOfDMatch.push_back( $value ) -> None
```

### VectorOfVectorOfDMatch::Add

```cpp
void VectorOfVectorOfDMatch::Add( std::vector<cv::DMatch> value )

AutoIt:
    $oVectorOfVectorOfDMatch.Add( $value ) -> None
```

### VectorOfVectorOfDMatch::Remove

```cpp
void VectorOfVectorOfDMatch::Remove( size_t index )

AutoIt:
    $oVectorOfVectorOfDMatch.Remove( $index ) -> None
```

### VectorOfVectorOfDMatch::at

```cpp
std::vector<cv::DMatch> VectorOfVectorOfDMatch::at( size_t index )

AutoIt:
    $oVectorOfVectorOfDMatch.at( $index ) -> retval
```

```cpp
void VectorOfVectorOfDMatch::at( size_t                  index,
                                 std::vector<cv::DMatch> value )

AutoIt:
    $oVectorOfVectorOfDMatch.at( $index, $value ) -> None
```

### VectorOfVectorOfDMatch::size

```cpp
size_t VectorOfVectorOfDMatch::size()

AutoIt:
    $oVectorOfVectorOfDMatch.size() -> retval
```

### VectorOfVectorOfDMatch::empty

```cpp
bool VectorOfVectorOfDMatch::empty()

AutoIt:
    $oVectorOfVectorOfDMatch.empty() -> retval
```

### VectorOfVectorOfDMatch::clear

```cpp
void VectorOfVectorOfDMatch::clear()

AutoIt:
    $oVectorOfVectorOfDMatch.clear() -> None
```

### VectorOfVectorOfDMatch::push_vector

```cpp
void VectorOfVectorOfDMatch::push_vector( VectorOfVectorOfDMatch other )

AutoIt:
    $oVectorOfVectorOfDMatch.push_vector( $other ) -> None
```

```cpp
void VectorOfVectorOfDMatch::push_vector( VectorOfVectorOfDMatch other,
                                          size_t                 count,
                                          size_t                 start = 0 )

AutoIt:
    $oVectorOfVectorOfDMatch.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVectorOfDMatch::slice

```cpp
VectorOfVectorOfDMatch VectorOfVectorOfDMatch::slice( size_t start = 0,
                                                      size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfDMatch.slice( [$start[, $count]] ) -> retval
```

### VectorOfVectorOfDMatch::sort

```cpp
void VectorOfVectorOfDMatch::sort( void*  comparator,
                                   size_t start = 0,
                                   size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfDMatch.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfDMatch::sort_variant

```cpp
void VectorOfVectorOfDMatch::sort_variant( void*  comparator,
                                           size_t start = 0,
                                           size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfDMatch.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfDMatch::start

```cpp
void* VectorOfVectorOfDMatch::start()

AutoIt:
    $oVectorOfVectorOfDMatch.start() -> retval
```

### VectorOfVectorOfDMatch::end

```cpp
void* VectorOfVectorOfDMatch::end()

AutoIt:
    $oVectorOfVectorOfDMatch.end() -> retval
```

### VectorOfVectorOfDMatch::get_Item

```cpp
std::vector<cv::DMatch> VectorOfVectorOfDMatch::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVectorOfDMatch.Item( $vIndex ) -> retval
    VectorOfVectorOfDMatch( $vIndex ) -> retval
```

### VectorOfVectorOfDMatch::put_Item

```cpp
void VectorOfVectorOfDMatch::put_Item( size_t                  vIndex,
                                       std::vector<cv::DMatch> vItem )

AutoIt:
    $oVectorOfVectorOfDMatch.Item( $vIndex ) = $$vItem
```

## VectorOfVectorOfChar

### VectorOfVectorOfChar::create

```cpp
static VectorOfVectorOfChar VectorOfVectorOfChar::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfChar").create() -> <VectorOfVectorOfChar object>
```

```cpp
static VectorOfVectorOfChar VectorOfVectorOfChar::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfChar").create( $size ) -> <VectorOfVectorOfChar object>
```

```cpp
static VectorOfVectorOfChar VectorOfVectorOfChar::create( VectorOfVectorOfChar other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfChar").create( $other ) -> <VectorOfVectorOfChar object>
```

### VectorOfVectorOfChar::Keys

```cpp
std::vector<int> VectorOfVectorOfChar::Keys()

AutoIt:
    $oVectorOfVectorOfChar.Keys() -> retval
```

### VectorOfVectorOfChar::Items

```cpp
VectorOfVectorOfChar VectorOfVectorOfChar::Items()

AutoIt:
    $oVectorOfVectorOfChar.Items() -> retval
```

### VectorOfVectorOfChar::push_back

```cpp
void VectorOfVectorOfChar::push_back( std::vector<char> value )

AutoIt:
    $oVectorOfVectorOfChar.push_back( $value ) -> None
```

### VectorOfVectorOfChar::Add

```cpp
void VectorOfVectorOfChar::Add( std::vector<char> value )

AutoIt:
    $oVectorOfVectorOfChar.Add( $value ) -> None
```

### VectorOfVectorOfChar::Remove

```cpp
void VectorOfVectorOfChar::Remove( size_t index )

AutoIt:
    $oVectorOfVectorOfChar.Remove( $index ) -> None
```

### VectorOfVectorOfChar::at

```cpp
std::vector<char> VectorOfVectorOfChar::at( size_t index )

AutoIt:
    $oVectorOfVectorOfChar.at( $index ) -> retval
```

```cpp
void VectorOfVectorOfChar::at( size_t            index,
                               std::vector<char> value )

AutoIt:
    $oVectorOfVectorOfChar.at( $index, $value ) -> None
```

### VectorOfVectorOfChar::size

```cpp
size_t VectorOfVectorOfChar::size()

AutoIt:
    $oVectorOfVectorOfChar.size() -> retval
```

### VectorOfVectorOfChar::empty

```cpp
bool VectorOfVectorOfChar::empty()

AutoIt:
    $oVectorOfVectorOfChar.empty() -> retval
```

### VectorOfVectorOfChar::clear

```cpp
void VectorOfVectorOfChar::clear()

AutoIt:
    $oVectorOfVectorOfChar.clear() -> None
```

### VectorOfVectorOfChar::push_vector

```cpp
void VectorOfVectorOfChar::push_vector( VectorOfVectorOfChar other )

AutoIt:
    $oVectorOfVectorOfChar.push_vector( $other ) -> None
```

```cpp
void VectorOfVectorOfChar::push_vector( VectorOfVectorOfChar other,
                                        size_t               count,
                                        size_t               start = 0 )

AutoIt:
    $oVectorOfVectorOfChar.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVectorOfChar::slice

```cpp
VectorOfVectorOfChar VectorOfVectorOfChar::slice( size_t start = 0,
                                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfChar.slice( [$start[, $count]] ) -> retval
```

### VectorOfVectorOfChar::sort

```cpp
void VectorOfVectorOfChar::sort( void*  comparator,
                                 size_t start = 0,
                                 size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfChar.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfChar::sort_variant

```cpp
void VectorOfVectorOfChar::sort_variant( void*  comparator,
                                         size_t start = 0,
                                         size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfChar.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfChar::start

```cpp
void* VectorOfVectorOfChar::start()

AutoIt:
    $oVectorOfVectorOfChar.start() -> retval
```

### VectorOfVectorOfChar::end

```cpp
void* VectorOfVectorOfChar::end()

AutoIt:
    $oVectorOfVectorOfChar.end() -> retval
```

### VectorOfVectorOfChar::get_Item

```cpp
std::vector<char> VectorOfVectorOfChar::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVectorOfChar.Item( $vIndex ) -> retval
    VectorOfVectorOfChar( $vIndex ) -> retval
```

### VectorOfVectorOfChar::put_Item

```cpp
void VectorOfVectorOfChar::put_Item( size_t            vIndex,
                                     std::vector<char> vItem )

AutoIt:
    $oVectorOfVectorOfChar.Item( $vIndex ) = $$vItem
```

## VectorOfUchar

### VectorOfUchar::create

```cpp
static VectorOfUchar VectorOfUchar::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfUchar").create() -> <VectorOfUchar object>
```

```cpp
static VectorOfUchar VectorOfUchar::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfUchar").create( $size ) -> <VectorOfUchar object>
```

```cpp
static VectorOfUchar VectorOfUchar::create( VectorOfUchar other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfUchar").create( $other ) -> <VectorOfUchar object>
```

### VectorOfUchar::Keys

```cpp
std::vector<int> VectorOfUchar::Keys()

AutoIt:
    $oVectorOfUchar.Keys() -> retval
```

### VectorOfUchar::Items

```cpp
VectorOfUchar VectorOfUchar::Items()

AutoIt:
    $oVectorOfUchar.Items() -> retval
```

### VectorOfUchar::push_back

```cpp
void VectorOfUchar::push_back( uchar value )

AutoIt:
    $oVectorOfUchar.push_back( $value ) -> None
```

### VectorOfUchar::Add

```cpp
void VectorOfUchar::Add( uchar value )

AutoIt:
    $oVectorOfUchar.Add( $value ) -> None
```

### VectorOfUchar::Remove

```cpp
void VectorOfUchar::Remove( size_t index )

AutoIt:
    $oVectorOfUchar.Remove( $index ) -> None
```

### VectorOfUchar::at

```cpp
uchar VectorOfUchar::at( size_t index )

AutoIt:
    $oVectorOfUchar.at( $index ) -> retval
```

```cpp
void VectorOfUchar::at( size_t index,
                        uchar  value )

AutoIt:
    $oVectorOfUchar.at( $index, $value ) -> None
```

### VectorOfUchar::size

```cpp
size_t VectorOfUchar::size()

AutoIt:
    $oVectorOfUchar.size() -> retval
```

### VectorOfUchar::empty

```cpp
bool VectorOfUchar::empty()

AutoIt:
    $oVectorOfUchar.empty() -> retval
```

### VectorOfUchar::clear

```cpp
void VectorOfUchar::clear()

AutoIt:
    $oVectorOfUchar.clear() -> None
```

### VectorOfUchar::push_vector

```cpp
void VectorOfUchar::push_vector( VectorOfUchar other )

AutoIt:
    $oVectorOfUchar.push_vector( $other ) -> None
```

```cpp
void VectorOfUchar::push_vector( VectorOfUchar other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfUchar.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfUchar::slice

```cpp
VectorOfUchar VectorOfUchar::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfUchar.slice( [$start[, $count]] ) -> retval
```

### VectorOfUchar::sort

```cpp
void VectorOfUchar::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfUchar.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfUchar::sort_variant

```cpp
void VectorOfUchar::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfUchar.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfUchar::start

```cpp
void* VectorOfUchar::start()

AutoIt:
    $oVectorOfUchar.start() -> retval
```

### VectorOfUchar::end

```cpp
void* VectorOfUchar::end()

AutoIt:
    $oVectorOfUchar.end() -> retval
```

### VectorOfUchar::get_Item

```cpp
uchar VectorOfUchar::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfUchar.Item( $vIndex ) -> retval
    VectorOfUchar( $vIndex ) -> retval
```

### VectorOfUchar::put_Item

```cpp
void VectorOfUchar::put_Item( size_t vIndex,
                              uchar  vItem )

AutoIt:
    $oVectorOfUchar.Item( $vIndex ) = $$vItem
```

## VectorOfRect

### VectorOfRect::create

```cpp
static VectorOfRect VectorOfRect::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfRect").create() -> <VectorOfRect object>
```

```cpp
static VectorOfRect VectorOfRect::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfRect").create( $size ) -> <VectorOfRect object>
```

```cpp
static VectorOfRect VectorOfRect::create( VectorOfRect other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfRect").create( $other ) -> <VectorOfRect object>
```

### VectorOfRect::Keys

```cpp
std::vector<int> VectorOfRect::Keys()

AutoIt:
    $oVectorOfRect.Keys() -> retval
```

### VectorOfRect::Items

```cpp
VectorOfRect VectorOfRect::Items()

AutoIt:
    $oVectorOfRect.Items() -> retval
```

### VectorOfRect::push_back

```cpp
void VectorOfRect::push_back( cv::Rect value )

AutoIt:
    $oVectorOfRect.push_back( $value ) -> None
```

### VectorOfRect::Add

```cpp
void VectorOfRect::Add( cv::Rect value )

AutoIt:
    $oVectorOfRect.Add( $value ) -> None
```

### VectorOfRect::Remove

```cpp
void VectorOfRect::Remove( size_t index )

AutoIt:
    $oVectorOfRect.Remove( $index ) -> None
```

### VectorOfRect::at

```cpp
cv::Rect VectorOfRect::at( size_t index )

AutoIt:
    $oVectorOfRect.at( $index ) -> retval
```

```cpp
void VectorOfRect::at( size_t   index,
                       cv::Rect value )

AutoIt:
    $oVectorOfRect.at( $index, $value ) -> None
```

### VectorOfRect::size

```cpp
size_t VectorOfRect::size()

AutoIt:
    $oVectorOfRect.size() -> retval
```

### VectorOfRect::empty

```cpp
bool VectorOfRect::empty()

AutoIt:
    $oVectorOfRect.empty() -> retval
```

### VectorOfRect::clear

```cpp
void VectorOfRect::clear()

AutoIt:
    $oVectorOfRect.clear() -> None
```

### VectorOfRect::push_vector

```cpp
void VectorOfRect::push_vector( VectorOfRect other )

AutoIt:
    $oVectorOfRect.push_vector( $other ) -> None
```

```cpp
void VectorOfRect::push_vector( VectorOfRect other,
                                size_t       count,
                                size_t       start = 0 )

AutoIt:
    $oVectorOfRect.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfRect::slice

```cpp
VectorOfRect VectorOfRect::slice( size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfRect.slice( [$start[, $count]] ) -> retval
```

### VectorOfRect::sort

```cpp
void VectorOfRect::sort( void*  comparator,
                         size_t start = 0,
                         size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfRect.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfRect::sort_variant

```cpp
void VectorOfRect::sort_variant( void*  comparator,
                                 size_t start = 0,
                                 size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfRect.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfRect::start

```cpp
void* VectorOfRect::start()

AutoIt:
    $oVectorOfRect.start() -> retval
```

### VectorOfRect::end

```cpp
void* VectorOfRect::end()

AutoIt:
    $oVectorOfRect.end() -> retval
```

### VectorOfRect::get_Item

```cpp
cv::Rect VectorOfRect::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfRect.Item( $vIndex ) -> retval
    VectorOfRect( $vIndex ) -> retval
```

### VectorOfRect::put_Item

```cpp
void VectorOfRect::put_Item( size_t   vIndex,
                             cv::Rect vItem )

AutoIt:
    $oVectorOfRect.Item( $vIndex ) = $$vItem
```

## VectorOfRotatedRect

### VectorOfRotatedRect::create

```cpp
static VectorOfRotatedRect VectorOfRotatedRect::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfRotatedRect").create() -> <VectorOfRotatedRect object>
```

```cpp
static VectorOfRotatedRect VectorOfRotatedRect::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfRotatedRect").create( $size ) -> <VectorOfRotatedRect object>
```

```cpp
static VectorOfRotatedRect VectorOfRotatedRect::create( VectorOfRotatedRect other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfRotatedRect").create( $other ) -> <VectorOfRotatedRect object>
```

### VectorOfRotatedRect::Keys

```cpp
std::vector<int> VectorOfRotatedRect::Keys()

AutoIt:
    $oVectorOfRotatedRect.Keys() -> retval
```

### VectorOfRotatedRect::Items

```cpp
VectorOfRotatedRect VectorOfRotatedRect::Items()

AutoIt:
    $oVectorOfRotatedRect.Items() -> retval
```

### VectorOfRotatedRect::push_back

```cpp
void VectorOfRotatedRect::push_back( cv::RotatedRect value )

AutoIt:
    $oVectorOfRotatedRect.push_back( $value ) -> None
```

### VectorOfRotatedRect::Add

```cpp
void VectorOfRotatedRect::Add( cv::RotatedRect value )

AutoIt:
    $oVectorOfRotatedRect.Add( $value ) -> None
```

### VectorOfRotatedRect::Remove

```cpp
void VectorOfRotatedRect::Remove( size_t index )

AutoIt:
    $oVectorOfRotatedRect.Remove( $index ) -> None
```

### VectorOfRotatedRect::at

```cpp
cv::RotatedRect VectorOfRotatedRect::at( size_t index )

AutoIt:
    $oVectorOfRotatedRect.at( $index ) -> retval
```

```cpp
void VectorOfRotatedRect::at( size_t          index,
                              cv::RotatedRect value )

AutoIt:
    $oVectorOfRotatedRect.at( $index, $value ) -> None
```

### VectorOfRotatedRect::size

```cpp
size_t VectorOfRotatedRect::size()

AutoIt:
    $oVectorOfRotatedRect.size() -> retval
```

### VectorOfRotatedRect::empty

```cpp
bool VectorOfRotatedRect::empty()

AutoIt:
    $oVectorOfRotatedRect.empty() -> retval
```

### VectorOfRotatedRect::clear

```cpp
void VectorOfRotatedRect::clear()

AutoIt:
    $oVectorOfRotatedRect.clear() -> None
```

### VectorOfRotatedRect::push_vector

```cpp
void VectorOfRotatedRect::push_vector( VectorOfRotatedRect other )

AutoIt:
    $oVectorOfRotatedRect.push_vector( $other ) -> None
```

```cpp
void VectorOfRotatedRect::push_vector( VectorOfRotatedRect other,
                                       size_t              count,
                                       size_t              start = 0 )

AutoIt:
    $oVectorOfRotatedRect.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfRotatedRect::slice

```cpp
VectorOfRotatedRect VectorOfRotatedRect::slice( size_t start = 0,
                                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfRotatedRect.slice( [$start[, $count]] ) -> retval
```

### VectorOfRotatedRect::sort

```cpp
void VectorOfRotatedRect::sort( void*  comparator,
                                size_t start = 0,
                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfRotatedRect.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfRotatedRect::sort_variant

```cpp
void VectorOfRotatedRect::sort_variant( void*  comparator,
                                        size_t start = 0,
                                        size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfRotatedRect.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfRotatedRect::start

```cpp
void* VectorOfRotatedRect::start()

AutoIt:
    $oVectorOfRotatedRect.start() -> retval
```

### VectorOfRotatedRect::end

```cpp
void* VectorOfRotatedRect::end()

AutoIt:
    $oVectorOfRotatedRect.end() -> retval
```

### VectorOfRotatedRect::get_Item

```cpp
cv::RotatedRect VectorOfRotatedRect::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfRotatedRect.Item( $vIndex ) -> retval
    VectorOfRotatedRect( $vIndex ) -> retval
```

### VectorOfRotatedRect::put_Item

```cpp
void VectorOfRotatedRect::put_Item( size_t          vIndex,
                                    cv::RotatedRect vItem )

AutoIt:
    $oVectorOfRotatedRect.Item( $vIndex ) = $$vItem
```

## VectorOfDouble

### VectorOfDouble::create

```cpp
static VectorOfDouble VectorOfDouble::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfDouble").create() -> <VectorOfDouble object>
```

```cpp
static VectorOfDouble VectorOfDouble::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfDouble").create( $size ) -> <VectorOfDouble object>
```

```cpp
static VectorOfDouble VectorOfDouble::create( VectorOfDouble other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfDouble").create( $other ) -> <VectorOfDouble object>
```

### VectorOfDouble::Keys

```cpp
std::vector<int> VectorOfDouble::Keys()

AutoIt:
    $oVectorOfDouble.Keys() -> retval
```

### VectorOfDouble::Items

```cpp
VectorOfDouble VectorOfDouble::Items()

AutoIt:
    $oVectorOfDouble.Items() -> retval
```

### VectorOfDouble::push_back

```cpp
void VectorOfDouble::push_back( double value )

AutoIt:
    $oVectorOfDouble.push_back( $value ) -> None
```

### VectorOfDouble::Add

```cpp
void VectorOfDouble::Add( double value )

AutoIt:
    $oVectorOfDouble.Add( $value ) -> None
```

### VectorOfDouble::Remove

```cpp
void VectorOfDouble::Remove( size_t index )

AutoIt:
    $oVectorOfDouble.Remove( $index ) -> None
```

### VectorOfDouble::at

```cpp
double VectorOfDouble::at( size_t index )

AutoIt:
    $oVectorOfDouble.at( $index ) -> retval
```

```cpp
void VectorOfDouble::at( size_t index,
                         double value )

AutoIt:
    $oVectorOfDouble.at( $index, $value ) -> None
```

### VectorOfDouble::size

```cpp
size_t VectorOfDouble::size()

AutoIt:
    $oVectorOfDouble.size() -> retval
```

### VectorOfDouble::empty

```cpp
bool VectorOfDouble::empty()

AutoIt:
    $oVectorOfDouble.empty() -> retval
```

### VectorOfDouble::clear

```cpp
void VectorOfDouble::clear()

AutoIt:
    $oVectorOfDouble.clear() -> None
```

### VectorOfDouble::push_vector

```cpp
void VectorOfDouble::push_vector( VectorOfDouble other )

AutoIt:
    $oVectorOfDouble.push_vector( $other ) -> None
```

```cpp
void VectorOfDouble::push_vector( VectorOfDouble other,
                                  size_t         count,
                                  size_t         start = 0 )

AutoIt:
    $oVectorOfDouble.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfDouble::slice

```cpp
VectorOfDouble VectorOfDouble::slice( size_t start = 0,
                                      size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfDouble.slice( [$start[, $count]] ) -> retval
```

### VectorOfDouble::sort

```cpp
void VectorOfDouble::sort( void*  comparator,
                           size_t start = 0,
                           size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfDouble.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfDouble::sort_variant

```cpp
void VectorOfDouble::sort_variant( void*  comparator,
                                   size_t start = 0,
                                   size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfDouble.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfDouble::start

```cpp
void* VectorOfDouble::start()

AutoIt:
    $oVectorOfDouble.start() -> retval
```

### VectorOfDouble::end

```cpp
void* VectorOfDouble::end()

AutoIt:
    $oVectorOfDouble.end() -> retval
```

### VectorOfDouble::get_Item

```cpp
double VectorOfDouble::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfDouble.Item( $vIndex ) -> retval
    VectorOfDouble( $vIndex ) -> retval
```

### VectorOfDouble::put_Item

```cpp
void VectorOfDouble::put_Item( size_t vIndex,
                               double vItem )

AutoIt:
    $oVectorOfDouble.Item( $vIndex ) = $$vItem
```

## VectorOfUMat

### VectorOfUMat::create

```cpp
static VectorOfUMat VectorOfUMat::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfUMat").create() -> <VectorOfUMat object>
```

```cpp
static VectorOfUMat VectorOfUMat::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfUMat").create( $size ) -> <VectorOfUMat object>
```

```cpp
static VectorOfUMat VectorOfUMat::create( VectorOfUMat other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfUMat").create( $other ) -> <VectorOfUMat object>
```

### VectorOfUMat::Keys

```cpp
std::vector<int> VectorOfUMat::Keys()

AutoIt:
    $oVectorOfUMat.Keys() -> retval
```

### VectorOfUMat::Items

```cpp
VectorOfUMat VectorOfUMat::Items()

AutoIt:
    $oVectorOfUMat.Items() -> retval
```

### VectorOfUMat::push_back

```cpp
void VectorOfUMat::push_back( cv::UMat value )

AutoIt:
    $oVectorOfUMat.push_back( $value ) -> None
```

### VectorOfUMat::Add

```cpp
void VectorOfUMat::Add( cv::UMat value )

AutoIt:
    $oVectorOfUMat.Add( $value ) -> None
```

### VectorOfUMat::Remove

```cpp
void VectorOfUMat::Remove( size_t index )

AutoIt:
    $oVectorOfUMat.Remove( $index ) -> None
```

### VectorOfUMat::at

```cpp
cv::UMat VectorOfUMat::at( size_t index )

AutoIt:
    $oVectorOfUMat.at( $index ) -> retval
```

```cpp
void VectorOfUMat::at( size_t   index,
                       cv::UMat value )

AutoIt:
    $oVectorOfUMat.at( $index, $value ) -> None
```

### VectorOfUMat::size

```cpp
size_t VectorOfUMat::size()

AutoIt:
    $oVectorOfUMat.size() -> retval
```

### VectorOfUMat::empty

```cpp
bool VectorOfUMat::empty()

AutoIt:
    $oVectorOfUMat.empty() -> retval
```

### VectorOfUMat::clear

```cpp
void VectorOfUMat::clear()

AutoIt:
    $oVectorOfUMat.clear() -> None
```

### VectorOfUMat::push_vector

```cpp
void VectorOfUMat::push_vector( VectorOfUMat other )

AutoIt:
    $oVectorOfUMat.push_vector( $other ) -> None
```

```cpp
void VectorOfUMat::push_vector( VectorOfUMat other,
                                size_t       count,
                                size_t       start = 0 )

AutoIt:
    $oVectorOfUMat.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfUMat::slice

```cpp
VectorOfUMat VectorOfUMat::slice( size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfUMat.slice( [$start[, $count]] ) -> retval
```

### VectorOfUMat::sort

```cpp
void VectorOfUMat::sort( void*  comparator,
                         size_t start = 0,
                         size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfUMat.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfUMat::sort_variant

```cpp
void VectorOfUMat::sort_variant( void*  comparator,
                                 size_t start = 0,
                                 size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfUMat.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfUMat::start

```cpp
void* VectorOfUMat::start()

AutoIt:
    $oVectorOfUMat.start() -> retval
```

### VectorOfUMat::end

```cpp
void* VectorOfUMat::end()

AutoIt:
    $oVectorOfUMat.end() -> retval
```

### VectorOfUMat::get_Item

```cpp
cv::UMat VectorOfUMat::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfUMat.Item( $vIndex ) -> retval
    VectorOfUMat( $vIndex ) -> retval
```

### VectorOfUMat::put_Item

```cpp
void VectorOfUMat::put_Item( size_t   vIndex,
                             cv::UMat vItem )

AutoIt:
    $oVectorOfUMat.Item( $vIndex ) = $$vItem
```

## VectorOfImageFeatures

### VectorOfImageFeatures::create

```cpp
static VectorOfImageFeatures VectorOfImageFeatures::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfImageFeatures").create() -> <VectorOfImageFeatures object>
```

```cpp
static VectorOfImageFeatures VectorOfImageFeatures::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfImageFeatures").create( $size ) -> <VectorOfImageFeatures object>
```

```cpp
static VectorOfImageFeatures VectorOfImageFeatures::create( VectorOfImageFeatures other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfImageFeatures").create( $other ) -> <VectorOfImageFeatures object>
```

### VectorOfImageFeatures::Keys

```cpp
std::vector<int> VectorOfImageFeatures::Keys()

AutoIt:
    $oVectorOfImageFeatures.Keys() -> retval
```

### VectorOfImageFeatures::Items

```cpp
VectorOfImageFeatures VectorOfImageFeatures::Items()

AutoIt:
    $oVectorOfImageFeatures.Items() -> retval
```

### VectorOfImageFeatures::push_back

```cpp
void VectorOfImageFeatures::push_back( cv::detail::ImageFeatures value )

AutoIt:
    $oVectorOfImageFeatures.push_back( $value ) -> None
```

### VectorOfImageFeatures::Add

```cpp
void VectorOfImageFeatures::Add( cv::detail::ImageFeatures value )

AutoIt:
    $oVectorOfImageFeatures.Add( $value ) -> None
```

### VectorOfImageFeatures::Remove

```cpp
void VectorOfImageFeatures::Remove( size_t index )

AutoIt:
    $oVectorOfImageFeatures.Remove( $index ) -> None
```

### VectorOfImageFeatures::at

```cpp
cv::detail::ImageFeatures VectorOfImageFeatures::at( size_t index )

AutoIt:
    $oVectorOfImageFeatures.at( $index ) -> retval
```

```cpp
void VectorOfImageFeatures::at( size_t                    index,
                                cv::detail::ImageFeatures value )

AutoIt:
    $oVectorOfImageFeatures.at( $index, $value ) -> None
```

### VectorOfImageFeatures::size

```cpp
size_t VectorOfImageFeatures::size()

AutoIt:
    $oVectorOfImageFeatures.size() -> retval
```

### VectorOfImageFeatures::empty

```cpp
bool VectorOfImageFeatures::empty()

AutoIt:
    $oVectorOfImageFeatures.empty() -> retval
```

### VectorOfImageFeatures::clear

```cpp
void VectorOfImageFeatures::clear()

AutoIt:
    $oVectorOfImageFeatures.clear() -> None
```

### VectorOfImageFeatures::push_vector

```cpp
void VectorOfImageFeatures::push_vector( VectorOfImageFeatures other )

AutoIt:
    $oVectorOfImageFeatures.push_vector( $other ) -> None
```

```cpp
void VectorOfImageFeatures::push_vector( VectorOfImageFeatures other,
                                         size_t                count,
                                         size_t                start = 0 )

AutoIt:
    $oVectorOfImageFeatures.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfImageFeatures::slice

```cpp
VectorOfImageFeatures VectorOfImageFeatures::slice( size_t start = 0,
                                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfImageFeatures.slice( [$start[, $count]] ) -> retval
```

### VectorOfImageFeatures::sort

```cpp
void VectorOfImageFeatures::sort( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfImageFeatures.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfImageFeatures::sort_variant

```cpp
void VectorOfImageFeatures::sort_variant( void*  comparator,
                                          size_t start = 0,
                                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfImageFeatures.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfImageFeatures::start

```cpp
void* VectorOfImageFeatures::start()

AutoIt:
    $oVectorOfImageFeatures.start() -> retval
```

### VectorOfImageFeatures::end

```cpp
void* VectorOfImageFeatures::end()

AutoIt:
    $oVectorOfImageFeatures.end() -> retval
```

### VectorOfImageFeatures::get_Item

```cpp
cv::detail::ImageFeatures VectorOfImageFeatures::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfImageFeatures.Item( $vIndex ) -> retval
    VectorOfImageFeatures( $vIndex ) -> retval
```

### VectorOfImageFeatures::put_Item

```cpp
void VectorOfImageFeatures::put_Item( size_t                    vIndex,
                                      cv::detail::ImageFeatures vItem )

AutoIt:
    $oVectorOfImageFeatures.Item( $vIndex ) = $$vItem
```

## VectorOfString

### VectorOfString::create

```cpp
static VectorOfString VectorOfString::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfString").create() -> <VectorOfString object>
```

```cpp
static VectorOfString VectorOfString::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfString").create( $size ) -> <VectorOfString object>
```

```cpp
static VectorOfString VectorOfString::create( VectorOfString other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfString").create( $other ) -> <VectorOfString object>
```

### VectorOfString::Keys

```cpp
std::vector<int> VectorOfString::Keys()

AutoIt:
    $oVectorOfString.Keys() -> retval
```

### VectorOfString::Items

```cpp
VectorOfString VectorOfString::Items()

AutoIt:
    $oVectorOfString.Items() -> retval
```

### VectorOfString::push_back

```cpp
void VectorOfString::push_back( std::string value )

AutoIt:
    $oVectorOfString.push_back( $value ) -> None
```

### VectorOfString::Add

```cpp
void VectorOfString::Add( std::string value )

AutoIt:
    $oVectorOfString.Add( $value ) -> None
```

### VectorOfString::Remove

```cpp
void VectorOfString::Remove( size_t index )

AutoIt:
    $oVectorOfString.Remove( $index ) -> None
```

### VectorOfString::at

```cpp
std::string VectorOfString::at( size_t index )

AutoIt:
    $oVectorOfString.at( $index ) -> retval
```

```cpp
void VectorOfString::at( size_t      index,
                         std::string value )

AutoIt:
    $oVectorOfString.at( $index, $value ) -> None
```

### VectorOfString::size

```cpp
size_t VectorOfString::size()

AutoIt:
    $oVectorOfString.size() -> retval
```

### VectorOfString::empty

```cpp
bool VectorOfString::empty()

AutoIt:
    $oVectorOfString.empty() -> retval
```

### VectorOfString::clear

```cpp
void VectorOfString::clear()

AutoIt:
    $oVectorOfString.clear() -> None
```

### VectorOfString::push_vector

```cpp
void VectorOfString::push_vector( VectorOfString other )

AutoIt:
    $oVectorOfString.push_vector( $other ) -> None
```

```cpp
void VectorOfString::push_vector( VectorOfString other,
                                  size_t         count,
                                  size_t         start = 0 )

AutoIt:
    $oVectorOfString.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfString::slice

```cpp
VectorOfString VectorOfString::slice( size_t start = 0,
                                      size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfString.slice( [$start[, $count]] ) -> retval
```

### VectorOfString::sort

```cpp
void VectorOfString::sort( void*  comparator,
                           size_t start = 0,
                           size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfString.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfString::sort_variant

```cpp
void VectorOfString::sort_variant( void*  comparator,
                                   size_t start = 0,
                                   size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfString.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfString::start

```cpp
void* VectorOfString::start()

AutoIt:
    $oVectorOfString.start() -> retval
```

### VectorOfString::end

```cpp
void* VectorOfString::end()

AutoIt:
    $oVectorOfString.end() -> retval
```

### VectorOfString::get_Item

```cpp
std::string VectorOfString::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfString.Item( $vIndex ) -> retval
    VectorOfString( $vIndex ) -> retval
```

### VectorOfString::put_Item

```cpp
void VectorOfString::put_Item( size_t      vIndex,
                               std::string vItem )

AutoIt:
    $oVectorOfString.Item( $vIndex ) = $$vItem
```

## VectorOfMatchesInfo

### VectorOfMatchesInfo::create

```cpp
static VectorOfMatchesInfo VectorOfMatchesInfo::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfMatchesInfo").create() -> <VectorOfMatchesInfo object>
```

```cpp
static VectorOfMatchesInfo VectorOfMatchesInfo::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfMatchesInfo").create( $size ) -> <VectorOfMatchesInfo object>
```

```cpp
static VectorOfMatchesInfo VectorOfMatchesInfo::create( VectorOfMatchesInfo other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfMatchesInfo").create( $other ) -> <VectorOfMatchesInfo object>
```

### VectorOfMatchesInfo::Keys

```cpp
std::vector<int> VectorOfMatchesInfo::Keys()

AutoIt:
    $oVectorOfMatchesInfo.Keys() -> retval
```

### VectorOfMatchesInfo::Items

```cpp
VectorOfMatchesInfo VectorOfMatchesInfo::Items()

AutoIt:
    $oVectorOfMatchesInfo.Items() -> retval
```

### VectorOfMatchesInfo::push_back

```cpp
void VectorOfMatchesInfo::push_back( cv::detail::MatchesInfo value )

AutoIt:
    $oVectorOfMatchesInfo.push_back( $value ) -> None
```

### VectorOfMatchesInfo::Add

```cpp
void VectorOfMatchesInfo::Add( cv::detail::MatchesInfo value )

AutoIt:
    $oVectorOfMatchesInfo.Add( $value ) -> None
```

### VectorOfMatchesInfo::Remove

```cpp
void VectorOfMatchesInfo::Remove( size_t index )

AutoIt:
    $oVectorOfMatchesInfo.Remove( $index ) -> None
```

### VectorOfMatchesInfo::at

```cpp
cv::detail::MatchesInfo VectorOfMatchesInfo::at( size_t index )

AutoIt:
    $oVectorOfMatchesInfo.at( $index ) -> retval
```

```cpp
void VectorOfMatchesInfo::at( size_t                  index,
                              cv::detail::MatchesInfo value )

AutoIt:
    $oVectorOfMatchesInfo.at( $index, $value ) -> None
```

### VectorOfMatchesInfo::size

```cpp
size_t VectorOfMatchesInfo::size()

AutoIt:
    $oVectorOfMatchesInfo.size() -> retval
```

### VectorOfMatchesInfo::empty

```cpp
bool VectorOfMatchesInfo::empty()

AutoIt:
    $oVectorOfMatchesInfo.empty() -> retval
```

### VectorOfMatchesInfo::clear

```cpp
void VectorOfMatchesInfo::clear()

AutoIt:
    $oVectorOfMatchesInfo.clear() -> None
```

### VectorOfMatchesInfo::push_vector

```cpp
void VectorOfMatchesInfo::push_vector( VectorOfMatchesInfo other )

AutoIt:
    $oVectorOfMatchesInfo.push_vector( $other ) -> None
```

```cpp
void VectorOfMatchesInfo::push_vector( VectorOfMatchesInfo other,
                                       size_t              count,
                                       size_t              start = 0 )

AutoIt:
    $oVectorOfMatchesInfo.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfMatchesInfo::slice

```cpp
VectorOfMatchesInfo VectorOfMatchesInfo::slice( size_t start = 0,
                                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfMatchesInfo.slice( [$start[, $count]] ) -> retval
```

### VectorOfMatchesInfo::sort

```cpp
void VectorOfMatchesInfo::sort( void*  comparator,
                                size_t start = 0,
                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfMatchesInfo.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfMatchesInfo::sort_variant

```cpp
void VectorOfMatchesInfo::sort_variant( void*  comparator,
                                        size_t start = 0,
                                        size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfMatchesInfo.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfMatchesInfo::start

```cpp
void* VectorOfMatchesInfo::start()

AutoIt:
    $oVectorOfMatchesInfo.start() -> retval
```

### VectorOfMatchesInfo::end

```cpp
void* VectorOfMatchesInfo::end()

AutoIt:
    $oVectorOfMatchesInfo.end() -> retval
```

### VectorOfMatchesInfo::get_Item

```cpp
cv::detail::MatchesInfo VectorOfMatchesInfo::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfMatchesInfo.Item( $vIndex ) -> retval
    VectorOfMatchesInfo( $vIndex ) -> retval
```

### VectorOfMatchesInfo::put_Item

```cpp
void VectorOfMatchesInfo::put_Item( size_t                  vIndex,
                                    cv::detail::MatchesInfo vItem )

AutoIt:
    $oVectorOfMatchesInfo.Item( $vIndex ) = $$vItem
```

## VectorOfSize

### VectorOfSize::create

```cpp
static VectorOfSize VectorOfSize::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfSize").create() -> <VectorOfSize object>
```

```cpp
static VectorOfSize VectorOfSize::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfSize").create( $size ) -> <VectorOfSize object>
```

```cpp
static VectorOfSize VectorOfSize::create( VectorOfSize other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfSize").create( $other ) -> <VectorOfSize object>
```

### VectorOfSize::Keys

```cpp
std::vector<int> VectorOfSize::Keys()

AutoIt:
    $oVectorOfSize.Keys() -> retval
```

### VectorOfSize::Items

```cpp
VectorOfSize VectorOfSize::Items()

AutoIt:
    $oVectorOfSize.Items() -> retval
```

### VectorOfSize::push_back

```cpp
void VectorOfSize::push_back( cv::Size value )

AutoIt:
    $oVectorOfSize.push_back( $value ) -> None
```

### VectorOfSize::Add

```cpp
void VectorOfSize::Add( cv::Size value )

AutoIt:
    $oVectorOfSize.Add( $value ) -> None
```

### VectorOfSize::Remove

```cpp
void VectorOfSize::Remove( size_t index )

AutoIt:
    $oVectorOfSize.Remove( $index ) -> None
```

### VectorOfSize::at

```cpp
cv::Size VectorOfSize::at( size_t index )

AutoIt:
    $oVectorOfSize.at( $index ) -> retval
```

```cpp
void VectorOfSize::at( size_t   index,
                       cv::Size value )

AutoIt:
    $oVectorOfSize.at( $index, $value ) -> None
```

### VectorOfSize::size

```cpp
size_t VectorOfSize::size()

AutoIt:
    $oVectorOfSize.size() -> retval
```

### VectorOfSize::empty

```cpp
bool VectorOfSize::empty()

AutoIt:
    $oVectorOfSize.empty() -> retval
```

### VectorOfSize::clear

```cpp
void VectorOfSize::clear()

AutoIt:
    $oVectorOfSize.clear() -> None
```

### VectorOfSize::push_vector

```cpp
void VectorOfSize::push_vector( VectorOfSize other )

AutoIt:
    $oVectorOfSize.push_vector( $other ) -> None
```

```cpp
void VectorOfSize::push_vector( VectorOfSize other,
                                size_t       count,
                                size_t       start = 0 )

AutoIt:
    $oVectorOfSize.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfSize::slice

```cpp
VectorOfSize VectorOfSize::slice( size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfSize.slice( [$start[, $count]] ) -> retval
```

### VectorOfSize::sort

```cpp
void VectorOfSize::sort( void*  comparator,
                         size_t start = 0,
                         size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfSize.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfSize::sort_variant

```cpp
void VectorOfSize::sort_variant( void*  comparator,
                                 size_t start = 0,
                                 size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfSize.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfSize::start

```cpp
void* VectorOfSize::start()

AutoIt:
    $oVectorOfSize.start() -> retval
```

### VectorOfSize::end

```cpp
void* VectorOfSize::end()

AutoIt:
    $oVectorOfSize.end() -> retval
```

### VectorOfSize::get_Item

```cpp
cv::Size VectorOfSize::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfSize.Item( $vIndex ) -> retval
    VectorOfSize( $vIndex ) -> retval
```

### VectorOfSize::put_Item

```cpp
void VectorOfSize::put_Item( size_t   vIndex,
                             cv::Size vItem )

AutoIt:
    $oVectorOfSize.Item( $vIndex ) = $$vItem
```

## VectorOfVec2b

### VectorOfVec2b::create

```cpp
static VectorOfVec2b VectorOfVec2b::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2b").create() -> <VectorOfVec2b object>
```

```cpp
static VectorOfVec2b VectorOfVec2b::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2b").create( $size ) -> <VectorOfVec2b object>
```

```cpp
static VectorOfVec2b VectorOfVec2b::create( VectorOfVec2b other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2b").create( $other ) -> <VectorOfVec2b object>
```

### VectorOfVec2b::Keys

```cpp
std::vector<int> VectorOfVec2b::Keys()

AutoIt:
    $oVectorOfVec2b.Keys() -> retval
```

### VectorOfVec2b::Items

```cpp
VectorOfVec2b VectorOfVec2b::Items()

AutoIt:
    $oVectorOfVec2b.Items() -> retval
```

### VectorOfVec2b::push_back

```cpp
void VectorOfVec2b::push_back( cv::Vec2b value )

AutoIt:
    $oVectorOfVec2b.push_back( $value ) -> None
```

### VectorOfVec2b::Add

```cpp
void VectorOfVec2b::Add( cv::Vec2b value )

AutoIt:
    $oVectorOfVec2b.Add( $value ) -> None
```

### VectorOfVec2b::Remove

```cpp
void VectorOfVec2b::Remove( size_t index )

AutoIt:
    $oVectorOfVec2b.Remove( $index ) -> None
```

### VectorOfVec2b::at

```cpp
cv::Vec2b VectorOfVec2b::at( size_t index )

AutoIt:
    $oVectorOfVec2b.at( $index ) -> retval
```

```cpp
void VectorOfVec2b::at( size_t    index,
                        cv::Vec2b value )

AutoIt:
    $oVectorOfVec2b.at( $index, $value ) -> None
```

### VectorOfVec2b::size

```cpp
size_t VectorOfVec2b::size()

AutoIt:
    $oVectorOfVec2b.size() -> retval
```

### VectorOfVec2b::empty

```cpp
bool VectorOfVec2b::empty()

AutoIt:
    $oVectorOfVec2b.empty() -> retval
```

### VectorOfVec2b::clear

```cpp
void VectorOfVec2b::clear()

AutoIt:
    $oVectorOfVec2b.clear() -> None
```

### VectorOfVec2b::push_vector

```cpp
void VectorOfVec2b::push_vector( VectorOfVec2b other )

AutoIt:
    $oVectorOfVec2b.push_vector( $other ) -> None
```

```cpp
void VectorOfVec2b::push_vector( VectorOfVec2b other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec2b.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec2b::slice

```cpp
VectorOfVec2b VectorOfVec2b::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2b.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec2b::sort

```cpp
void VectorOfVec2b::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2b.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec2b::sort_variant

```cpp
void VectorOfVec2b::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2b.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec2b::start

```cpp
void* VectorOfVec2b::start()

AutoIt:
    $oVectorOfVec2b.start() -> retval
```

### VectorOfVec2b::end

```cpp
void* VectorOfVec2b::end()

AutoIt:
    $oVectorOfVec2b.end() -> retval
```

### VectorOfVec2b::get_Item

```cpp
cv::Vec2b VectorOfVec2b::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec2b.Item( $vIndex ) -> retval
    VectorOfVec2b( $vIndex ) -> retval
```

### VectorOfVec2b::put_Item

```cpp
void VectorOfVec2b::put_Item( size_t    vIndex,
                              cv::Vec2b vItem )

AutoIt:
    $oVectorOfVec2b.Item( $vIndex ) = $$vItem
```

## VectorOfVec3b

### VectorOfVec3b::create

```cpp
static VectorOfVec3b VectorOfVec3b::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3b").create() -> <VectorOfVec3b object>
```

```cpp
static VectorOfVec3b VectorOfVec3b::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3b").create( $size ) -> <VectorOfVec3b object>
```

```cpp
static VectorOfVec3b VectorOfVec3b::create( VectorOfVec3b other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3b").create( $other ) -> <VectorOfVec3b object>
```

### VectorOfVec3b::Keys

```cpp
std::vector<int> VectorOfVec3b::Keys()

AutoIt:
    $oVectorOfVec3b.Keys() -> retval
```

### VectorOfVec3b::Items

```cpp
VectorOfVec3b VectorOfVec3b::Items()

AutoIt:
    $oVectorOfVec3b.Items() -> retval
```

### VectorOfVec3b::push_back

```cpp
void VectorOfVec3b::push_back( cv::Vec3b value )

AutoIt:
    $oVectorOfVec3b.push_back( $value ) -> None
```

### VectorOfVec3b::Add

```cpp
void VectorOfVec3b::Add( cv::Vec3b value )

AutoIt:
    $oVectorOfVec3b.Add( $value ) -> None
```

### VectorOfVec3b::Remove

```cpp
void VectorOfVec3b::Remove( size_t index )

AutoIt:
    $oVectorOfVec3b.Remove( $index ) -> None
```

### VectorOfVec3b::at

```cpp
cv::Vec3b VectorOfVec3b::at( size_t index )

AutoIt:
    $oVectorOfVec3b.at( $index ) -> retval
```

```cpp
void VectorOfVec3b::at( size_t    index,
                        cv::Vec3b value )

AutoIt:
    $oVectorOfVec3b.at( $index, $value ) -> None
```

### VectorOfVec3b::size

```cpp
size_t VectorOfVec3b::size()

AutoIt:
    $oVectorOfVec3b.size() -> retval
```

### VectorOfVec3b::empty

```cpp
bool VectorOfVec3b::empty()

AutoIt:
    $oVectorOfVec3b.empty() -> retval
```

### VectorOfVec3b::clear

```cpp
void VectorOfVec3b::clear()

AutoIt:
    $oVectorOfVec3b.clear() -> None
```

### VectorOfVec3b::push_vector

```cpp
void VectorOfVec3b::push_vector( VectorOfVec3b other )

AutoIt:
    $oVectorOfVec3b.push_vector( $other ) -> None
```

```cpp
void VectorOfVec3b::push_vector( VectorOfVec3b other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec3b.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec3b::slice

```cpp
VectorOfVec3b VectorOfVec3b::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3b.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec3b::sort

```cpp
void VectorOfVec3b::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3b.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec3b::sort_variant

```cpp
void VectorOfVec3b::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3b.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec3b::start

```cpp
void* VectorOfVec3b::start()

AutoIt:
    $oVectorOfVec3b.start() -> retval
```

### VectorOfVec3b::end

```cpp
void* VectorOfVec3b::end()

AutoIt:
    $oVectorOfVec3b.end() -> retval
```

### VectorOfVec3b::get_Item

```cpp
cv::Vec3b VectorOfVec3b::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec3b.Item( $vIndex ) -> retval
    VectorOfVec3b( $vIndex ) -> retval
```

### VectorOfVec3b::put_Item

```cpp
void VectorOfVec3b::put_Item( size_t    vIndex,
                              cv::Vec3b vItem )

AutoIt:
    $oVectorOfVec3b.Item( $vIndex ) = $$vItem
```

## VectorOfVec4b

### VectorOfVec4b::create

```cpp
static VectorOfVec4b VectorOfVec4b::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4b").create() -> <VectorOfVec4b object>
```

```cpp
static VectorOfVec4b VectorOfVec4b::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4b").create( $size ) -> <VectorOfVec4b object>
```

```cpp
static VectorOfVec4b VectorOfVec4b::create( VectorOfVec4b other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4b").create( $other ) -> <VectorOfVec4b object>
```

### VectorOfVec4b::Keys

```cpp
std::vector<int> VectorOfVec4b::Keys()

AutoIt:
    $oVectorOfVec4b.Keys() -> retval
```

### VectorOfVec4b::Items

```cpp
VectorOfVec4b VectorOfVec4b::Items()

AutoIt:
    $oVectorOfVec4b.Items() -> retval
```

### VectorOfVec4b::push_back

```cpp
void VectorOfVec4b::push_back( cv::Vec4b value )

AutoIt:
    $oVectorOfVec4b.push_back( $value ) -> None
```

### VectorOfVec4b::Add

```cpp
void VectorOfVec4b::Add( cv::Vec4b value )

AutoIt:
    $oVectorOfVec4b.Add( $value ) -> None
```

### VectorOfVec4b::Remove

```cpp
void VectorOfVec4b::Remove( size_t index )

AutoIt:
    $oVectorOfVec4b.Remove( $index ) -> None
```

### VectorOfVec4b::at

```cpp
cv::Vec4b VectorOfVec4b::at( size_t index )

AutoIt:
    $oVectorOfVec4b.at( $index ) -> retval
```

```cpp
void VectorOfVec4b::at( size_t    index,
                        cv::Vec4b value )

AutoIt:
    $oVectorOfVec4b.at( $index, $value ) -> None
```

### VectorOfVec4b::size

```cpp
size_t VectorOfVec4b::size()

AutoIt:
    $oVectorOfVec4b.size() -> retval
```

### VectorOfVec4b::empty

```cpp
bool VectorOfVec4b::empty()

AutoIt:
    $oVectorOfVec4b.empty() -> retval
```

### VectorOfVec4b::clear

```cpp
void VectorOfVec4b::clear()

AutoIt:
    $oVectorOfVec4b.clear() -> None
```

### VectorOfVec4b::push_vector

```cpp
void VectorOfVec4b::push_vector( VectorOfVec4b other )

AutoIt:
    $oVectorOfVec4b.push_vector( $other ) -> None
```

```cpp
void VectorOfVec4b::push_vector( VectorOfVec4b other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec4b.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec4b::slice

```cpp
VectorOfVec4b VectorOfVec4b::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4b.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec4b::sort

```cpp
void VectorOfVec4b::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4b.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec4b::sort_variant

```cpp
void VectorOfVec4b::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4b.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec4b::start

```cpp
void* VectorOfVec4b::start()

AutoIt:
    $oVectorOfVec4b.start() -> retval
```

### VectorOfVec4b::end

```cpp
void* VectorOfVec4b::end()

AutoIt:
    $oVectorOfVec4b.end() -> retval
```

### VectorOfVec4b::get_Item

```cpp
cv::Vec4b VectorOfVec4b::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec4b.Item( $vIndex ) -> retval
    VectorOfVec4b( $vIndex ) -> retval
```

### VectorOfVec4b::put_Item

```cpp
void VectorOfVec4b::put_Item( size_t    vIndex,
                              cv::Vec4b vItem )

AutoIt:
    $oVectorOfVec4b.Item( $vIndex ) = $$vItem
```

## VectorOfVec2s

### VectorOfVec2s::create

```cpp
static VectorOfVec2s VectorOfVec2s::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2s").create() -> <VectorOfVec2s object>
```

```cpp
static VectorOfVec2s VectorOfVec2s::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2s").create( $size ) -> <VectorOfVec2s object>
```

```cpp
static VectorOfVec2s VectorOfVec2s::create( VectorOfVec2s other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2s").create( $other ) -> <VectorOfVec2s object>
```

### VectorOfVec2s::Keys

```cpp
std::vector<int> VectorOfVec2s::Keys()

AutoIt:
    $oVectorOfVec2s.Keys() -> retval
```

### VectorOfVec2s::Items

```cpp
VectorOfVec2s VectorOfVec2s::Items()

AutoIt:
    $oVectorOfVec2s.Items() -> retval
```

### VectorOfVec2s::push_back

```cpp
void VectorOfVec2s::push_back( cv::Vec2s value )

AutoIt:
    $oVectorOfVec2s.push_back( $value ) -> None
```

### VectorOfVec2s::Add

```cpp
void VectorOfVec2s::Add( cv::Vec2s value )

AutoIt:
    $oVectorOfVec2s.Add( $value ) -> None
```

### VectorOfVec2s::Remove

```cpp
void VectorOfVec2s::Remove( size_t index )

AutoIt:
    $oVectorOfVec2s.Remove( $index ) -> None
```

### VectorOfVec2s::at

```cpp
cv::Vec2s VectorOfVec2s::at( size_t index )

AutoIt:
    $oVectorOfVec2s.at( $index ) -> retval
```

```cpp
void VectorOfVec2s::at( size_t    index,
                        cv::Vec2s value )

AutoIt:
    $oVectorOfVec2s.at( $index, $value ) -> None
```

### VectorOfVec2s::size

```cpp
size_t VectorOfVec2s::size()

AutoIt:
    $oVectorOfVec2s.size() -> retval
```

### VectorOfVec2s::empty

```cpp
bool VectorOfVec2s::empty()

AutoIt:
    $oVectorOfVec2s.empty() -> retval
```

### VectorOfVec2s::clear

```cpp
void VectorOfVec2s::clear()

AutoIt:
    $oVectorOfVec2s.clear() -> None
```

### VectorOfVec2s::push_vector

```cpp
void VectorOfVec2s::push_vector( VectorOfVec2s other )

AutoIt:
    $oVectorOfVec2s.push_vector( $other ) -> None
```

```cpp
void VectorOfVec2s::push_vector( VectorOfVec2s other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec2s.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec2s::slice

```cpp
VectorOfVec2s VectorOfVec2s::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2s.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec2s::sort

```cpp
void VectorOfVec2s::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2s.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec2s::sort_variant

```cpp
void VectorOfVec2s::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2s.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec2s::start

```cpp
void* VectorOfVec2s::start()

AutoIt:
    $oVectorOfVec2s.start() -> retval
```

### VectorOfVec2s::end

```cpp
void* VectorOfVec2s::end()

AutoIt:
    $oVectorOfVec2s.end() -> retval
```

### VectorOfVec2s::get_Item

```cpp
cv::Vec2s VectorOfVec2s::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec2s.Item( $vIndex ) -> retval
    VectorOfVec2s( $vIndex ) -> retval
```

### VectorOfVec2s::put_Item

```cpp
void VectorOfVec2s::put_Item( size_t    vIndex,
                              cv::Vec2s vItem )

AutoIt:
    $oVectorOfVec2s.Item( $vIndex ) = $$vItem
```

## VectorOfVec3s

### VectorOfVec3s::create

```cpp
static VectorOfVec3s VectorOfVec3s::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3s").create() -> <VectorOfVec3s object>
```

```cpp
static VectorOfVec3s VectorOfVec3s::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3s").create( $size ) -> <VectorOfVec3s object>
```

```cpp
static VectorOfVec3s VectorOfVec3s::create( VectorOfVec3s other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3s").create( $other ) -> <VectorOfVec3s object>
```

### VectorOfVec3s::Keys

```cpp
std::vector<int> VectorOfVec3s::Keys()

AutoIt:
    $oVectorOfVec3s.Keys() -> retval
```

### VectorOfVec3s::Items

```cpp
VectorOfVec3s VectorOfVec3s::Items()

AutoIt:
    $oVectorOfVec3s.Items() -> retval
```

### VectorOfVec3s::push_back

```cpp
void VectorOfVec3s::push_back( cv::Vec3s value )

AutoIt:
    $oVectorOfVec3s.push_back( $value ) -> None
```

### VectorOfVec3s::Add

```cpp
void VectorOfVec3s::Add( cv::Vec3s value )

AutoIt:
    $oVectorOfVec3s.Add( $value ) -> None
```

### VectorOfVec3s::Remove

```cpp
void VectorOfVec3s::Remove( size_t index )

AutoIt:
    $oVectorOfVec3s.Remove( $index ) -> None
```

### VectorOfVec3s::at

```cpp
cv::Vec3s VectorOfVec3s::at( size_t index )

AutoIt:
    $oVectorOfVec3s.at( $index ) -> retval
```

```cpp
void VectorOfVec3s::at( size_t    index,
                        cv::Vec3s value )

AutoIt:
    $oVectorOfVec3s.at( $index, $value ) -> None
```

### VectorOfVec3s::size

```cpp
size_t VectorOfVec3s::size()

AutoIt:
    $oVectorOfVec3s.size() -> retval
```

### VectorOfVec3s::empty

```cpp
bool VectorOfVec3s::empty()

AutoIt:
    $oVectorOfVec3s.empty() -> retval
```

### VectorOfVec3s::clear

```cpp
void VectorOfVec3s::clear()

AutoIt:
    $oVectorOfVec3s.clear() -> None
```

### VectorOfVec3s::push_vector

```cpp
void VectorOfVec3s::push_vector( VectorOfVec3s other )

AutoIt:
    $oVectorOfVec3s.push_vector( $other ) -> None
```

```cpp
void VectorOfVec3s::push_vector( VectorOfVec3s other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec3s.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec3s::slice

```cpp
VectorOfVec3s VectorOfVec3s::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3s.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec3s::sort

```cpp
void VectorOfVec3s::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3s.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec3s::sort_variant

```cpp
void VectorOfVec3s::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3s.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec3s::start

```cpp
void* VectorOfVec3s::start()

AutoIt:
    $oVectorOfVec3s.start() -> retval
```

### VectorOfVec3s::end

```cpp
void* VectorOfVec3s::end()

AutoIt:
    $oVectorOfVec3s.end() -> retval
```

### VectorOfVec3s::get_Item

```cpp
cv::Vec3s VectorOfVec3s::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec3s.Item( $vIndex ) -> retval
    VectorOfVec3s( $vIndex ) -> retval
```

### VectorOfVec3s::put_Item

```cpp
void VectorOfVec3s::put_Item( size_t    vIndex,
                              cv::Vec3s vItem )

AutoIt:
    $oVectorOfVec3s.Item( $vIndex ) = $$vItem
```

## VectorOfVec4s

### VectorOfVec4s::create

```cpp
static VectorOfVec4s VectorOfVec4s::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4s").create() -> <VectorOfVec4s object>
```

```cpp
static VectorOfVec4s VectorOfVec4s::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4s").create( $size ) -> <VectorOfVec4s object>
```

```cpp
static VectorOfVec4s VectorOfVec4s::create( VectorOfVec4s other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4s").create( $other ) -> <VectorOfVec4s object>
```

### VectorOfVec4s::Keys

```cpp
std::vector<int> VectorOfVec4s::Keys()

AutoIt:
    $oVectorOfVec4s.Keys() -> retval
```

### VectorOfVec4s::Items

```cpp
VectorOfVec4s VectorOfVec4s::Items()

AutoIt:
    $oVectorOfVec4s.Items() -> retval
```

### VectorOfVec4s::push_back

```cpp
void VectorOfVec4s::push_back( cv::Vec4s value )

AutoIt:
    $oVectorOfVec4s.push_back( $value ) -> None
```

### VectorOfVec4s::Add

```cpp
void VectorOfVec4s::Add( cv::Vec4s value )

AutoIt:
    $oVectorOfVec4s.Add( $value ) -> None
```

### VectorOfVec4s::Remove

```cpp
void VectorOfVec4s::Remove( size_t index )

AutoIt:
    $oVectorOfVec4s.Remove( $index ) -> None
```

### VectorOfVec4s::at

```cpp
cv::Vec4s VectorOfVec4s::at( size_t index )

AutoIt:
    $oVectorOfVec4s.at( $index ) -> retval
```

```cpp
void VectorOfVec4s::at( size_t    index,
                        cv::Vec4s value )

AutoIt:
    $oVectorOfVec4s.at( $index, $value ) -> None
```

### VectorOfVec4s::size

```cpp
size_t VectorOfVec4s::size()

AutoIt:
    $oVectorOfVec4s.size() -> retval
```

### VectorOfVec4s::empty

```cpp
bool VectorOfVec4s::empty()

AutoIt:
    $oVectorOfVec4s.empty() -> retval
```

### VectorOfVec4s::clear

```cpp
void VectorOfVec4s::clear()

AutoIt:
    $oVectorOfVec4s.clear() -> None
```

### VectorOfVec4s::push_vector

```cpp
void VectorOfVec4s::push_vector( VectorOfVec4s other )

AutoIt:
    $oVectorOfVec4s.push_vector( $other ) -> None
```

```cpp
void VectorOfVec4s::push_vector( VectorOfVec4s other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec4s.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec4s::slice

```cpp
VectorOfVec4s VectorOfVec4s::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4s.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec4s::sort

```cpp
void VectorOfVec4s::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4s.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec4s::sort_variant

```cpp
void VectorOfVec4s::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4s.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec4s::start

```cpp
void* VectorOfVec4s::start()

AutoIt:
    $oVectorOfVec4s.start() -> retval
```

### VectorOfVec4s::end

```cpp
void* VectorOfVec4s::end()

AutoIt:
    $oVectorOfVec4s.end() -> retval
```

### VectorOfVec4s::get_Item

```cpp
cv::Vec4s VectorOfVec4s::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec4s.Item( $vIndex ) -> retval
    VectorOfVec4s( $vIndex ) -> retval
```

### VectorOfVec4s::put_Item

```cpp
void VectorOfVec4s::put_Item( size_t    vIndex,
                              cv::Vec4s vItem )

AutoIt:
    $oVectorOfVec4s.Item( $vIndex ) = $$vItem
```

## VectorOfVec2w

### VectorOfVec2w::create

```cpp
static VectorOfVec2w VectorOfVec2w::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2w").create() -> <VectorOfVec2w object>
```

```cpp
static VectorOfVec2w VectorOfVec2w::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2w").create( $size ) -> <VectorOfVec2w object>
```

```cpp
static VectorOfVec2w VectorOfVec2w::create( VectorOfVec2w other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2w").create( $other ) -> <VectorOfVec2w object>
```

### VectorOfVec2w::Keys

```cpp
std::vector<int> VectorOfVec2w::Keys()

AutoIt:
    $oVectorOfVec2w.Keys() -> retval
```

### VectorOfVec2w::Items

```cpp
VectorOfVec2w VectorOfVec2w::Items()

AutoIt:
    $oVectorOfVec2w.Items() -> retval
```

### VectorOfVec2w::push_back

```cpp
void VectorOfVec2w::push_back( cv::Vec2w value )

AutoIt:
    $oVectorOfVec2w.push_back( $value ) -> None
```

### VectorOfVec2w::Add

```cpp
void VectorOfVec2w::Add( cv::Vec2w value )

AutoIt:
    $oVectorOfVec2w.Add( $value ) -> None
```

### VectorOfVec2w::Remove

```cpp
void VectorOfVec2w::Remove( size_t index )

AutoIt:
    $oVectorOfVec2w.Remove( $index ) -> None
```

### VectorOfVec2w::at

```cpp
cv::Vec2w VectorOfVec2w::at( size_t index )

AutoIt:
    $oVectorOfVec2w.at( $index ) -> retval
```

```cpp
void VectorOfVec2w::at( size_t    index,
                        cv::Vec2w value )

AutoIt:
    $oVectorOfVec2w.at( $index, $value ) -> None
```

### VectorOfVec2w::size

```cpp
size_t VectorOfVec2w::size()

AutoIt:
    $oVectorOfVec2w.size() -> retval
```

### VectorOfVec2w::empty

```cpp
bool VectorOfVec2w::empty()

AutoIt:
    $oVectorOfVec2w.empty() -> retval
```

### VectorOfVec2w::clear

```cpp
void VectorOfVec2w::clear()

AutoIt:
    $oVectorOfVec2w.clear() -> None
```

### VectorOfVec2w::push_vector

```cpp
void VectorOfVec2w::push_vector( VectorOfVec2w other )

AutoIt:
    $oVectorOfVec2w.push_vector( $other ) -> None
```

```cpp
void VectorOfVec2w::push_vector( VectorOfVec2w other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec2w.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec2w::slice

```cpp
VectorOfVec2w VectorOfVec2w::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2w.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec2w::sort

```cpp
void VectorOfVec2w::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2w.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec2w::sort_variant

```cpp
void VectorOfVec2w::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2w.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec2w::start

```cpp
void* VectorOfVec2w::start()

AutoIt:
    $oVectorOfVec2w.start() -> retval
```

### VectorOfVec2w::end

```cpp
void* VectorOfVec2w::end()

AutoIt:
    $oVectorOfVec2w.end() -> retval
```

### VectorOfVec2w::get_Item

```cpp
cv::Vec2w VectorOfVec2w::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec2w.Item( $vIndex ) -> retval
    VectorOfVec2w( $vIndex ) -> retval
```

### VectorOfVec2w::put_Item

```cpp
void VectorOfVec2w::put_Item( size_t    vIndex,
                              cv::Vec2w vItem )

AutoIt:
    $oVectorOfVec2w.Item( $vIndex ) = $$vItem
```

## VectorOfVec3w

### VectorOfVec3w::create

```cpp
static VectorOfVec3w VectorOfVec3w::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3w").create() -> <VectorOfVec3w object>
```

```cpp
static VectorOfVec3w VectorOfVec3w::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3w").create( $size ) -> <VectorOfVec3w object>
```

```cpp
static VectorOfVec3w VectorOfVec3w::create( VectorOfVec3w other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3w").create( $other ) -> <VectorOfVec3w object>
```

### VectorOfVec3w::Keys

```cpp
std::vector<int> VectorOfVec3w::Keys()

AutoIt:
    $oVectorOfVec3w.Keys() -> retval
```

### VectorOfVec3w::Items

```cpp
VectorOfVec3w VectorOfVec3w::Items()

AutoIt:
    $oVectorOfVec3w.Items() -> retval
```

### VectorOfVec3w::push_back

```cpp
void VectorOfVec3w::push_back( cv::Vec3w value )

AutoIt:
    $oVectorOfVec3w.push_back( $value ) -> None
```

### VectorOfVec3w::Add

```cpp
void VectorOfVec3w::Add( cv::Vec3w value )

AutoIt:
    $oVectorOfVec3w.Add( $value ) -> None
```

### VectorOfVec3w::Remove

```cpp
void VectorOfVec3w::Remove( size_t index )

AutoIt:
    $oVectorOfVec3w.Remove( $index ) -> None
```

### VectorOfVec3w::at

```cpp
cv::Vec3w VectorOfVec3w::at( size_t index )

AutoIt:
    $oVectorOfVec3w.at( $index ) -> retval
```

```cpp
void VectorOfVec3w::at( size_t    index,
                        cv::Vec3w value )

AutoIt:
    $oVectorOfVec3w.at( $index, $value ) -> None
```

### VectorOfVec3w::size

```cpp
size_t VectorOfVec3w::size()

AutoIt:
    $oVectorOfVec3w.size() -> retval
```

### VectorOfVec3w::empty

```cpp
bool VectorOfVec3w::empty()

AutoIt:
    $oVectorOfVec3w.empty() -> retval
```

### VectorOfVec3w::clear

```cpp
void VectorOfVec3w::clear()

AutoIt:
    $oVectorOfVec3w.clear() -> None
```

### VectorOfVec3w::push_vector

```cpp
void VectorOfVec3w::push_vector( VectorOfVec3w other )

AutoIt:
    $oVectorOfVec3w.push_vector( $other ) -> None
```

```cpp
void VectorOfVec3w::push_vector( VectorOfVec3w other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec3w.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec3w::slice

```cpp
VectorOfVec3w VectorOfVec3w::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3w.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec3w::sort

```cpp
void VectorOfVec3w::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3w.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec3w::sort_variant

```cpp
void VectorOfVec3w::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3w.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec3w::start

```cpp
void* VectorOfVec3w::start()

AutoIt:
    $oVectorOfVec3w.start() -> retval
```

### VectorOfVec3w::end

```cpp
void* VectorOfVec3w::end()

AutoIt:
    $oVectorOfVec3w.end() -> retval
```

### VectorOfVec3w::get_Item

```cpp
cv::Vec3w VectorOfVec3w::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec3w.Item( $vIndex ) -> retval
    VectorOfVec3w( $vIndex ) -> retval
```

### VectorOfVec3w::put_Item

```cpp
void VectorOfVec3w::put_Item( size_t    vIndex,
                              cv::Vec3w vItem )

AutoIt:
    $oVectorOfVec3w.Item( $vIndex ) = $$vItem
```

## VectorOfVec4w

### VectorOfVec4w::create

```cpp
static VectorOfVec4w VectorOfVec4w::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4w").create() -> <VectorOfVec4w object>
```

```cpp
static VectorOfVec4w VectorOfVec4w::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4w").create( $size ) -> <VectorOfVec4w object>
```

```cpp
static VectorOfVec4w VectorOfVec4w::create( VectorOfVec4w other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4w").create( $other ) -> <VectorOfVec4w object>
```

### VectorOfVec4w::Keys

```cpp
std::vector<int> VectorOfVec4w::Keys()

AutoIt:
    $oVectorOfVec4w.Keys() -> retval
```

### VectorOfVec4w::Items

```cpp
VectorOfVec4w VectorOfVec4w::Items()

AutoIt:
    $oVectorOfVec4w.Items() -> retval
```

### VectorOfVec4w::push_back

```cpp
void VectorOfVec4w::push_back( cv::Vec4w value )

AutoIt:
    $oVectorOfVec4w.push_back( $value ) -> None
```

### VectorOfVec4w::Add

```cpp
void VectorOfVec4w::Add( cv::Vec4w value )

AutoIt:
    $oVectorOfVec4w.Add( $value ) -> None
```

### VectorOfVec4w::Remove

```cpp
void VectorOfVec4w::Remove( size_t index )

AutoIt:
    $oVectorOfVec4w.Remove( $index ) -> None
```

### VectorOfVec4w::at

```cpp
cv::Vec4w VectorOfVec4w::at( size_t index )

AutoIt:
    $oVectorOfVec4w.at( $index ) -> retval
```

```cpp
void VectorOfVec4w::at( size_t    index,
                        cv::Vec4w value )

AutoIt:
    $oVectorOfVec4w.at( $index, $value ) -> None
```

### VectorOfVec4w::size

```cpp
size_t VectorOfVec4w::size()

AutoIt:
    $oVectorOfVec4w.size() -> retval
```

### VectorOfVec4w::empty

```cpp
bool VectorOfVec4w::empty()

AutoIt:
    $oVectorOfVec4w.empty() -> retval
```

### VectorOfVec4w::clear

```cpp
void VectorOfVec4w::clear()

AutoIt:
    $oVectorOfVec4w.clear() -> None
```

### VectorOfVec4w::push_vector

```cpp
void VectorOfVec4w::push_vector( VectorOfVec4w other )

AutoIt:
    $oVectorOfVec4w.push_vector( $other ) -> None
```

```cpp
void VectorOfVec4w::push_vector( VectorOfVec4w other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec4w.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec4w::slice

```cpp
VectorOfVec4w VectorOfVec4w::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4w.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec4w::sort

```cpp
void VectorOfVec4w::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4w.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec4w::sort_variant

```cpp
void VectorOfVec4w::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4w.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec4w::start

```cpp
void* VectorOfVec4w::start()

AutoIt:
    $oVectorOfVec4w.start() -> retval
```

### VectorOfVec4w::end

```cpp
void* VectorOfVec4w::end()

AutoIt:
    $oVectorOfVec4w.end() -> retval
```

### VectorOfVec4w::get_Item

```cpp
cv::Vec4w VectorOfVec4w::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec4w.Item( $vIndex ) -> retval
    VectorOfVec4w( $vIndex ) -> retval
```

### VectorOfVec4w::put_Item

```cpp
void VectorOfVec4w::put_Item( size_t    vIndex,
                              cv::Vec4w vItem )

AutoIt:
    $oVectorOfVec4w.Item( $vIndex ) = $$vItem
```

## VectorOfVec2i

### VectorOfVec2i::create

```cpp
static VectorOfVec2i VectorOfVec2i::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2i").create() -> <VectorOfVec2i object>
```

```cpp
static VectorOfVec2i VectorOfVec2i::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2i").create( $size ) -> <VectorOfVec2i object>
```

```cpp
static VectorOfVec2i VectorOfVec2i::create( VectorOfVec2i other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2i").create( $other ) -> <VectorOfVec2i object>
```

### VectorOfVec2i::Keys

```cpp
std::vector<int> VectorOfVec2i::Keys()

AutoIt:
    $oVectorOfVec2i.Keys() -> retval
```

### VectorOfVec2i::Items

```cpp
VectorOfVec2i VectorOfVec2i::Items()

AutoIt:
    $oVectorOfVec2i.Items() -> retval
```

### VectorOfVec2i::push_back

```cpp
void VectorOfVec2i::push_back( cv::Vec2i value )

AutoIt:
    $oVectorOfVec2i.push_back( $value ) -> None
```

### VectorOfVec2i::Add

```cpp
void VectorOfVec2i::Add( cv::Vec2i value )

AutoIt:
    $oVectorOfVec2i.Add( $value ) -> None
```

### VectorOfVec2i::Remove

```cpp
void VectorOfVec2i::Remove( size_t index )

AutoIt:
    $oVectorOfVec2i.Remove( $index ) -> None
```

### VectorOfVec2i::at

```cpp
cv::Vec2i VectorOfVec2i::at( size_t index )

AutoIt:
    $oVectorOfVec2i.at( $index ) -> retval
```

```cpp
void VectorOfVec2i::at( size_t    index,
                        cv::Vec2i value )

AutoIt:
    $oVectorOfVec2i.at( $index, $value ) -> None
```

### VectorOfVec2i::size

```cpp
size_t VectorOfVec2i::size()

AutoIt:
    $oVectorOfVec2i.size() -> retval
```

### VectorOfVec2i::empty

```cpp
bool VectorOfVec2i::empty()

AutoIt:
    $oVectorOfVec2i.empty() -> retval
```

### VectorOfVec2i::clear

```cpp
void VectorOfVec2i::clear()

AutoIt:
    $oVectorOfVec2i.clear() -> None
```

### VectorOfVec2i::push_vector

```cpp
void VectorOfVec2i::push_vector( VectorOfVec2i other )

AutoIt:
    $oVectorOfVec2i.push_vector( $other ) -> None
```

```cpp
void VectorOfVec2i::push_vector( VectorOfVec2i other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec2i.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec2i::slice

```cpp
VectorOfVec2i VectorOfVec2i::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2i.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec2i::sort

```cpp
void VectorOfVec2i::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2i.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec2i::sort_variant

```cpp
void VectorOfVec2i::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2i.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec2i::start

```cpp
void* VectorOfVec2i::start()

AutoIt:
    $oVectorOfVec2i.start() -> retval
```

### VectorOfVec2i::end

```cpp
void* VectorOfVec2i::end()

AutoIt:
    $oVectorOfVec2i.end() -> retval
```

### VectorOfVec2i::get_Item

```cpp
cv::Vec2i VectorOfVec2i::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec2i.Item( $vIndex ) -> retval
    VectorOfVec2i( $vIndex ) -> retval
```

### VectorOfVec2i::put_Item

```cpp
void VectorOfVec2i::put_Item( size_t    vIndex,
                              cv::Vec2i vItem )

AutoIt:
    $oVectorOfVec2i.Item( $vIndex ) = $$vItem
```

## VectorOfVec3i

### VectorOfVec3i::create

```cpp
static VectorOfVec3i VectorOfVec3i::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3i").create() -> <VectorOfVec3i object>
```

```cpp
static VectorOfVec3i VectorOfVec3i::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3i").create( $size ) -> <VectorOfVec3i object>
```

```cpp
static VectorOfVec3i VectorOfVec3i::create( VectorOfVec3i other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3i").create( $other ) -> <VectorOfVec3i object>
```

### VectorOfVec3i::Keys

```cpp
std::vector<int> VectorOfVec3i::Keys()

AutoIt:
    $oVectorOfVec3i.Keys() -> retval
```

### VectorOfVec3i::Items

```cpp
VectorOfVec3i VectorOfVec3i::Items()

AutoIt:
    $oVectorOfVec3i.Items() -> retval
```

### VectorOfVec3i::push_back

```cpp
void VectorOfVec3i::push_back( cv::Vec3i value )

AutoIt:
    $oVectorOfVec3i.push_back( $value ) -> None
```

### VectorOfVec3i::Add

```cpp
void VectorOfVec3i::Add( cv::Vec3i value )

AutoIt:
    $oVectorOfVec3i.Add( $value ) -> None
```

### VectorOfVec3i::Remove

```cpp
void VectorOfVec3i::Remove( size_t index )

AutoIt:
    $oVectorOfVec3i.Remove( $index ) -> None
```

### VectorOfVec3i::at

```cpp
cv::Vec3i VectorOfVec3i::at( size_t index )

AutoIt:
    $oVectorOfVec3i.at( $index ) -> retval
```

```cpp
void VectorOfVec3i::at( size_t    index,
                        cv::Vec3i value )

AutoIt:
    $oVectorOfVec3i.at( $index, $value ) -> None
```

### VectorOfVec3i::size

```cpp
size_t VectorOfVec3i::size()

AutoIt:
    $oVectorOfVec3i.size() -> retval
```

### VectorOfVec3i::empty

```cpp
bool VectorOfVec3i::empty()

AutoIt:
    $oVectorOfVec3i.empty() -> retval
```

### VectorOfVec3i::clear

```cpp
void VectorOfVec3i::clear()

AutoIt:
    $oVectorOfVec3i.clear() -> None
```

### VectorOfVec3i::push_vector

```cpp
void VectorOfVec3i::push_vector( VectorOfVec3i other )

AutoIt:
    $oVectorOfVec3i.push_vector( $other ) -> None
```

```cpp
void VectorOfVec3i::push_vector( VectorOfVec3i other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec3i.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec3i::slice

```cpp
VectorOfVec3i VectorOfVec3i::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3i.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec3i::sort

```cpp
void VectorOfVec3i::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3i.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec3i::sort_variant

```cpp
void VectorOfVec3i::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3i.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec3i::start

```cpp
void* VectorOfVec3i::start()

AutoIt:
    $oVectorOfVec3i.start() -> retval
```

### VectorOfVec3i::end

```cpp
void* VectorOfVec3i::end()

AutoIt:
    $oVectorOfVec3i.end() -> retval
```

### VectorOfVec3i::get_Item

```cpp
cv::Vec3i VectorOfVec3i::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec3i.Item( $vIndex ) -> retval
    VectorOfVec3i( $vIndex ) -> retval
```

### VectorOfVec3i::put_Item

```cpp
void VectorOfVec3i::put_Item( size_t    vIndex,
                              cv::Vec3i vItem )

AutoIt:
    $oVectorOfVec3i.Item( $vIndex ) = $$vItem
```

## VectorOfVec4i

### VectorOfVec4i::create

```cpp
static VectorOfVec4i VectorOfVec4i::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4i").create() -> <VectorOfVec4i object>
```

```cpp
static VectorOfVec4i VectorOfVec4i::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4i").create( $size ) -> <VectorOfVec4i object>
```

```cpp
static VectorOfVec4i VectorOfVec4i::create( VectorOfVec4i other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4i").create( $other ) -> <VectorOfVec4i object>
```

### VectorOfVec4i::Keys

```cpp
std::vector<int> VectorOfVec4i::Keys()

AutoIt:
    $oVectorOfVec4i.Keys() -> retval
```

### VectorOfVec4i::Items

```cpp
VectorOfVec4i VectorOfVec4i::Items()

AutoIt:
    $oVectorOfVec4i.Items() -> retval
```

### VectorOfVec4i::push_back

```cpp
void VectorOfVec4i::push_back( cv::Vec4i value )

AutoIt:
    $oVectorOfVec4i.push_back( $value ) -> None
```

### VectorOfVec4i::Add

```cpp
void VectorOfVec4i::Add( cv::Vec4i value )

AutoIt:
    $oVectorOfVec4i.Add( $value ) -> None
```

### VectorOfVec4i::Remove

```cpp
void VectorOfVec4i::Remove( size_t index )

AutoIt:
    $oVectorOfVec4i.Remove( $index ) -> None
```

### VectorOfVec4i::at

```cpp
cv::Vec4i VectorOfVec4i::at( size_t index )

AutoIt:
    $oVectorOfVec4i.at( $index ) -> retval
```

```cpp
void VectorOfVec4i::at( size_t    index,
                        cv::Vec4i value )

AutoIt:
    $oVectorOfVec4i.at( $index, $value ) -> None
```

### VectorOfVec4i::size

```cpp
size_t VectorOfVec4i::size()

AutoIt:
    $oVectorOfVec4i.size() -> retval
```

### VectorOfVec4i::empty

```cpp
bool VectorOfVec4i::empty()

AutoIt:
    $oVectorOfVec4i.empty() -> retval
```

### VectorOfVec4i::clear

```cpp
void VectorOfVec4i::clear()

AutoIt:
    $oVectorOfVec4i.clear() -> None
```

### VectorOfVec4i::push_vector

```cpp
void VectorOfVec4i::push_vector( VectorOfVec4i other )

AutoIt:
    $oVectorOfVec4i.push_vector( $other ) -> None
```

```cpp
void VectorOfVec4i::push_vector( VectorOfVec4i other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec4i.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec4i::slice

```cpp
VectorOfVec4i VectorOfVec4i::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4i.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec4i::sort

```cpp
void VectorOfVec4i::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4i.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec4i::sort_variant

```cpp
void VectorOfVec4i::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4i.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec4i::start

```cpp
void* VectorOfVec4i::start()

AutoIt:
    $oVectorOfVec4i.start() -> retval
```

### VectorOfVec4i::end

```cpp
void* VectorOfVec4i::end()

AutoIt:
    $oVectorOfVec4i.end() -> retval
```

### VectorOfVec4i::get_Item

```cpp
cv::Vec4i VectorOfVec4i::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec4i.Item( $vIndex ) -> retval
    VectorOfVec4i( $vIndex ) -> retval
```

### VectorOfVec4i::put_Item

```cpp
void VectorOfVec4i::put_Item( size_t    vIndex,
                              cv::Vec4i vItem )

AutoIt:
    $oVectorOfVec4i.Item( $vIndex ) = $$vItem
```

## VectorOfVec6i

### VectorOfVec6i::create

```cpp
static VectorOfVec6i VectorOfVec6i::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec6i").create() -> <VectorOfVec6i object>
```

```cpp
static VectorOfVec6i VectorOfVec6i::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec6i").create( $size ) -> <VectorOfVec6i object>
```

```cpp
static VectorOfVec6i VectorOfVec6i::create( VectorOfVec6i other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec6i").create( $other ) -> <VectorOfVec6i object>
```

### VectorOfVec6i::Keys

```cpp
std::vector<int> VectorOfVec6i::Keys()

AutoIt:
    $oVectorOfVec6i.Keys() -> retval
```

### VectorOfVec6i::Items

```cpp
VectorOfVec6i VectorOfVec6i::Items()

AutoIt:
    $oVectorOfVec6i.Items() -> retval
```

### VectorOfVec6i::push_back

```cpp
void VectorOfVec6i::push_back( cv::Vec6i value )

AutoIt:
    $oVectorOfVec6i.push_back( $value ) -> None
```

### VectorOfVec6i::Add

```cpp
void VectorOfVec6i::Add( cv::Vec6i value )

AutoIt:
    $oVectorOfVec6i.Add( $value ) -> None
```

### VectorOfVec6i::Remove

```cpp
void VectorOfVec6i::Remove( size_t index )

AutoIt:
    $oVectorOfVec6i.Remove( $index ) -> None
```

### VectorOfVec6i::at

```cpp
cv::Vec6i VectorOfVec6i::at( size_t index )

AutoIt:
    $oVectorOfVec6i.at( $index ) -> retval
```

```cpp
void VectorOfVec6i::at( size_t    index,
                        cv::Vec6i value )

AutoIt:
    $oVectorOfVec6i.at( $index, $value ) -> None
```

### VectorOfVec6i::size

```cpp
size_t VectorOfVec6i::size()

AutoIt:
    $oVectorOfVec6i.size() -> retval
```

### VectorOfVec6i::empty

```cpp
bool VectorOfVec6i::empty()

AutoIt:
    $oVectorOfVec6i.empty() -> retval
```

### VectorOfVec6i::clear

```cpp
void VectorOfVec6i::clear()

AutoIt:
    $oVectorOfVec6i.clear() -> None
```

### VectorOfVec6i::push_vector

```cpp
void VectorOfVec6i::push_vector( VectorOfVec6i other )

AutoIt:
    $oVectorOfVec6i.push_vector( $other ) -> None
```

```cpp
void VectorOfVec6i::push_vector( VectorOfVec6i other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec6i.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec6i::slice

```cpp
VectorOfVec6i VectorOfVec6i::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec6i.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec6i::sort

```cpp
void VectorOfVec6i::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec6i.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec6i::sort_variant

```cpp
void VectorOfVec6i::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec6i.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec6i::start

```cpp
void* VectorOfVec6i::start()

AutoIt:
    $oVectorOfVec6i.start() -> retval
```

### VectorOfVec6i::end

```cpp
void* VectorOfVec6i::end()

AutoIt:
    $oVectorOfVec6i.end() -> retval
```

### VectorOfVec6i::get_Item

```cpp
cv::Vec6i VectorOfVec6i::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec6i.Item( $vIndex ) -> retval
    VectorOfVec6i( $vIndex ) -> retval
```

### VectorOfVec6i::put_Item

```cpp
void VectorOfVec6i::put_Item( size_t    vIndex,
                              cv::Vec6i vItem )

AutoIt:
    $oVectorOfVec6i.Item( $vIndex ) = $$vItem
```

## VectorOfVec8i

### VectorOfVec8i::create

```cpp
static VectorOfVec8i VectorOfVec8i::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec8i").create() -> <VectorOfVec8i object>
```

```cpp
static VectorOfVec8i VectorOfVec8i::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec8i").create( $size ) -> <VectorOfVec8i object>
```

```cpp
static VectorOfVec8i VectorOfVec8i::create( VectorOfVec8i other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec8i").create( $other ) -> <VectorOfVec8i object>
```

### VectorOfVec8i::Keys

```cpp
std::vector<int> VectorOfVec8i::Keys()

AutoIt:
    $oVectorOfVec8i.Keys() -> retval
```

### VectorOfVec8i::Items

```cpp
VectorOfVec8i VectorOfVec8i::Items()

AutoIt:
    $oVectorOfVec8i.Items() -> retval
```

### VectorOfVec8i::push_back

```cpp
void VectorOfVec8i::push_back( cv::Vec8i value )

AutoIt:
    $oVectorOfVec8i.push_back( $value ) -> None
```

### VectorOfVec8i::Add

```cpp
void VectorOfVec8i::Add( cv::Vec8i value )

AutoIt:
    $oVectorOfVec8i.Add( $value ) -> None
```

### VectorOfVec8i::Remove

```cpp
void VectorOfVec8i::Remove( size_t index )

AutoIt:
    $oVectorOfVec8i.Remove( $index ) -> None
```

### VectorOfVec8i::at

```cpp
cv::Vec8i VectorOfVec8i::at( size_t index )

AutoIt:
    $oVectorOfVec8i.at( $index ) -> retval
```

```cpp
void VectorOfVec8i::at( size_t    index,
                        cv::Vec8i value )

AutoIt:
    $oVectorOfVec8i.at( $index, $value ) -> None
```

### VectorOfVec8i::size

```cpp
size_t VectorOfVec8i::size()

AutoIt:
    $oVectorOfVec8i.size() -> retval
```

### VectorOfVec8i::empty

```cpp
bool VectorOfVec8i::empty()

AutoIt:
    $oVectorOfVec8i.empty() -> retval
```

### VectorOfVec8i::clear

```cpp
void VectorOfVec8i::clear()

AutoIt:
    $oVectorOfVec8i.clear() -> None
```

### VectorOfVec8i::push_vector

```cpp
void VectorOfVec8i::push_vector( VectorOfVec8i other )

AutoIt:
    $oVectorOfVec8i.push_vector( $other ) -> None
```

```cpp
void VectorOfVec8i::push_vector( VectorOfVec8i other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec8i.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec8i::slice

```cpp
VectorOfVec8i VectorOfVec8i::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec8i.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec8i::sort

```cpp
void VectorOfVec8i::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec8i.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec8i::sort_variant

```cpp
void VectorOfVec8i::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec8i.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec8i::start

```cpp
void* VectorOfVec8i::start()

AutoIt:
    $oVectorOfVec8i.start() -> retval
```

### VectorOfVec8i::end

```cpp
void* VectorOfVec8i::end()

AutoIt:
    $oVectorOfVec8i.end() -> retval
```

### VectorOfVec8i::get_Item

```cpp
cv::Vec8i VectorOfVec8i::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec8i.Item( $vIndex ) -> retval
    VectorOfVec8i( $vIndex ) -> retval
```

### VectorOfVec8i::put_Item

```cpp
void VectorOfVec8i::put_Item( size_t    vIndex,
                              cv::Vec8i vItem )

AutoIt:
    $oVectorOfVec8i.Item( $vIndex ) = $$vItem
```

## VectorOfVec2f

### VectorOfVec2f::create

```cpp
static VectorOfVec2f VectorOfVec2f::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2f").create() -> <VectorOfVec2f object>
```

```cpp
static VectorOfVec2f VectorOfVec2f::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2f").create( $size ) -> <VectorOfVec2f object>
```

```cpp
static VectorOfVec2f VectorOfVec2f::create( VectorOfVec2f other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2f").create( $other ) -> <VectorOfVec2f object>
```

### VectorOfVec2f::Keys

```cpp
std::vector<int> VectorOfVec2f::Keys()

AutoIt:
    $oVectorOfVec2f.Keys() -> retval
```

### VectorOfVec2f::Items

```cpp
VectorOfVec2f VectorOfVec2f::Items()

AutoIt:
    $oVectorOfVec2f.Items() -> retval
```

### VectorOfVec2f::push_back

```cpp
void VectorOfVec2f::push_back( cv::Vec2f value )

AutoIt:
    $oVectorOfVec2f.push_back( $value ) -> None
```

### VectorOfVec2f::Add

```cpp
void VectorOfVec2f::Add( cv::Vec2f value )

AutoIt:
    $oVectorOfVec2f.Add( $value ) -> None
```

### VectorOfVec2f::Remove

```cpp
void VectorOfVec2f::Remove( size_t index )

AutoIt:
    $oVectorOfVec2f.Remove( $index ) -> None
```

### VectorOfVec2f::at

```cpp
cv::Vec2f VectorOfVec2f::at( size_t index )

AutoIt:
    $oVectorOfVec2f.at( $index ) -> retval
```

```cpp
void VectorOfVec2f::at( size_t    index,
                        cv::Vec2f value )

AutoIt:
    $oVectorOfVec2f.at( $index, $value ) -> None
```

### VectorOfVec2f::size

```cpp
size_t VectorOfVec2f::size()

AutoIt:
    $oVectorOfVec2f.size() -> retval
```

### VectorOfVec2f::empty

```cpp
bool VectorOfVec2f::empty()

AutoIt:
    $oVectorOfVec2f.empty() -> retval
```

### VectorOfVec2f::clear

```cpp
void VectorOfVec2f::clear()

AutoIt:
    $oVectorOfVec2f.clear() -> None
```

### VectorOfVec2f::push_vector

```cpp
void VectorOfVec2f::push_vector( VectorOfVec2f other )

AutoIt:
    $oVectorOfVec2f.push_vector( $other ) -> None
```

```cpp
void VectorOfVec2f::push_vector( VectorOfVec2f other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec2f.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec2f::slice

```cpp
VectorOfVec2f VectorOfVec2f::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2f.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec2f::sort

```cpp
void VectorOfVec2f::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2f.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec2f::sort_variant

```cpp
void VectorOfVec2f::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2f.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec2f::start

```cpp
void* VectorOfVec2f::start()

AutoIt:
    $oVectorOfVec2f.start() -> retval
```

### VectorOfVec2f::end

```cpp
void* VectorOfVec2f::end()

AutoIt:
    $oVectorOfVec2f.end() -> retval
```

### VectorOfVec2f::get_Item

```cpp
cv::Vec2f VectorOfVec2f::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec2f.Item( $vIndex ) -> retval
    VectorOfVec2f( $vIndex ) -> retval
```

### VectorOfVec2f::put_Item

```cpp
void VectorOfVec2f::put_Item( size_t    vIndex,
                              cv::Vec2f vItem )

AutoIt:
    $oVectorOfVec2f.Item( $vIndex ) = $$vItem
```

## VectorOfVec3f

### VectorOfVec3f::create

```cpp
static VectorOfVec3f VectorOfVec3f::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3f").create() -> <VectorOfVec3f object>
```

```cpp
static VectorOfVec3f VectorOfVec3f::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3f").create( $size ) -> <VectorOfVec3f object>
```

```cpp
static VectorOfVec3f VectorOfVec3f::create( VectorOfVec3f other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3f").create( $other ) -> <VectorOfVec3f object>
```

### VectorOfVec3f::Keys

```cpp
std::vector<int> VectorOfVec3f::Keys()

AutoIt:
    $oVectorOfVec3f.Keys() -> retval
```

### VectorOfVec3f::Items

```cpp
VectorOfVec3f VectorOfVec3f::Items()

AutoIt:
    $oVectorOfVec3f.Items() -> retval
```

### VectorOfVec3f::push_back

```cpp
void VectorOfVec3f::push_back( cv::Vec3f value )

AutoIt:
    $oVectorOfVec3f.push_back( $value ) -> None
```

### VectorOfVec3f::Add

```cpp
void VectorOfVec3f::Add( cv::Vec3f value )

AutoIt:
    $oVectorOfVec3f.Add( $value ) -> None
```

### VectorOfVec3f::Remove

```cpp
void VectorOfVec3f::Remove( size_t index )

AutoIt:
    $oVectorOfVec3f.Remove( $index ) -> None
```

### VectorOfVec3f::at

```cpp
cv::Vec3f VectorOfVec3f::at( size_t index )

AutoIt:
    $oVectorOfVec3f.at( $index ) -> retval
```

```cpp
void VectorOfVec3f::at( size_t    index,
                        cv::Vec3f value )

AutoIt:
    $oVectorOfVec3f.at( $index, $value ) -> None
```

### VectorOfVec3f::size

```cpp
size_t VectorOfVec3f::size()

AutoIt:
    $oVectorOfVec3f.size() -> retval
```

### VectorOfVec3f::empty

```cpp
bool VectorOfVec3f::empty()

AutoIt:
    $oVectorOfVec3f.empty() -> retval
```

### VectorOfVec3f::clear

```cpp
void VectorOfVec3f::clear()

AutoIt:
    $oVectorOfVec3f.clear() -> None
```

### VectorOfVec3f::push_vector

```cpp
void VectorOfVec3f::push_vector( VectorOfVec3f other )

AutoIt:
    $oVectorOfVec3f.push_vector( $other ) -> None
```

```cpp
void VectorOfVec3f::push_vector( VectorOfVec3f other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec3f.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec3f::slice

```cpp
VectorOfVec3f VectorOfVec3f::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3f.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec3f::sort

```cpp
void VectorOfVec3f::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3f.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec3f::sort_variant

```cpp
void VectorOfVec3f::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3f.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec3f::start

```cpp
void* VectorOfVec3f::start()

AutoIt:
    $oVectorOfVec3f.start() -> retval
```

### VectorOfVec3f::end

```cpp
void* VectorOfVec3f::end()

AutoIt:
    $oVectorOfVec3f.end() -> retval
```

### VectorOfVec3f::get_Item

```cpp
cv::Vec3f VectorOfVec3f::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec3f.Item( $vIndex ) -> retval
    VectorOfVec3f( $vIndex ) -> retval
```

### VectorOfVec3f::put_Item

```cpp
void VectorOfVec3f::put_Item( size_t    vIndex,
                              cv::Vec3f vItem )

AutoIt:
    $oVectorOfVec3f.Item( $vIndex ) = $$vItem
```

## VectorOfVec4f

### VectorOfVec4f::create

```cpp
static VectorOfVec4f VectorOfVec4f::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4f").create() -> <VectorOfVec4f object>
```

```cpp
static VectorOfVec4f VectorOfVec4f::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4f").create( $size ) -> <VectorOfVec4f object>
```

```cpp
static VectorOfVec4f VectorOfVec4f::create( VectorOfVec4f other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4f").create( $other ) -> <VectorOfVec4f object>
```

### VectorOfVec4f::Keys

```cpp
std::vector<int> VectorOfVec4f::Keys()

AutoIt:
    $oVectorOfVec4f.Keys() -> retval
```

### VectorOfVec4f::Items

```cpp
VectorOfVec4f VectorOfVec4f::Items()

AutoIt:
    $oVectorOfVec4f.Items() -> retval
```

### VectorOfVec4f::push_back

```cpp
void VectorOfVec4f::push_back( cv::Vec4f value )

AutoIt:
    $oVectorOfVec4f.push_back( $value ) -> None
```

### VectorOfVec4f::Add

```cpp
void VectorOfVec4f::Add( cv::Vec4f value )

AutoIt:
    $oVectorOfVec4f.Add( $value ) -> None
```

### VectorOfVec4f::Remove

```cpp
void VectorOfVec4f::Remove( size_t index )

AutoIt:
    $oVectorOfVec4f.Remove( $index ) -> None
```

### VectorOfVec4f::at

```cpp
cv::Vec4f VectorOfVec4f::at( size_t index )

AutoIt:
    $oVectorOfVec4f.at( $index ) -> retval
```

```cpp
void VectorOfVec4f::at( size_t    index,
                        cv::Vec4f value )

AutoIt:
    $oVectorOfVec4f.at( $index, $value ) -> None
```

### VectorOfVec4f::size

```cpp
size_t VectorOfVec4f::size()

AutoIt:
    $oVectorOfVec4f.size() -> retval
```

### VectorOfVec4f::empty

```cpp
bool VectorOfVec4f::empty()

AutoIt:
    $oVectorOfVec4f.empty() -> retval
```

### VectorOfVec4f::clear

```cpp
void VectorOfVec4f::clear()

AutoIt:
    $oVectorOfVec4f.clear() -> None
```

### VectorOfVec4f::push_vector

```cpp
void VectorOfVec4f::push_vector( VectorOfVec4f other )

AutoIt:
    $oVectorOfVec4f.push_vector( $other ) -> None
```

```cpp
void VectorOfVec4f::push_vector( VectorOfVec4f other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec4f.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec4f::slice

```cpp
VectorOfVec4f VectorOfVec4f::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4f.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec4f::sort

```cpp
void VectorOfVec4f::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4f.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec4f::sort_variant

```cpp
void VectorOfVec4f::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4f.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec4f::start

```cpp
void* VectorOfVec4f::start()

AutoIt:
    $oVectorOfVec4f.start() -> retval
```

### VectorOfVec4f::end

```cpp
void* VectorOfVec4f::end()

AutoIt:
    $oVectorOfVec4f.end() -> retval
```

### VectorOfVec4f::get_Item

```cpp
cv::Vec4f VectorOfVec4f::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec4f.Item( $vIndex ) -> retval
    VectorOfVec4f( $vIndex ) -> retval
```

### VectorOfVec4f::put_Item

```cpp
void VectorOfVec4f::put_Item( size_t    vIndex,
                              cv::Vec4f vItem )

AutoIt:
    $oVectorOfVec4f.Item( $vIndex ) = $$vItem
```

## VectorOfVec6f

### VectorOfVec6f::create

```cpp
static VectorOfVec6f VectorOfVec6f::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec6f").create() -> <VectorOfVec6f object>
```

```cpp
static VectorOfVec6f VectorOfVec6f::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec6f").create( $size ) -> <VectorOfVec6f object>
```

```cpp
static VectorOfVec6f VectorOfVec6f::create( VectorOfVec6f other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec6f").create( $other ) -> <VectorOfVec6f object>
```

### VectorOfVec6f::Keys

```cpp
std::vector<int> VectorOfVec6f::Keys()

AutoIt:
    $oVectorOfVec6f.Keys() -> retval
```

### VectorOfVec6f::Items

```cpp
VectorOfVec6f VectorOfVec6f::Items()

AutoIt:
    $oVectorOfVec6f.Items() -> retval
```

### VectorOfVec6f::push_back

```cpp
void VectorOfVec6f::push_back( cv::Vec6f value )

AutoIt:
    $oVectorOfVec6f.push_back( $value ) -> None
```

### VectorOfVec6f::Add

```cpp
void VectorOfVec6f::Add( cv::Vec6f value )

AutoIt:
    $oVectorOfVec6f.Add( $value ) -> None
```

### VectorOfVec6f::Remove

```cpp
void VectorOfVec6f::Remove( size_t index )

AutoIt:
    $oVectorOfVec6f.Remove( $index ) -> None
```

### VectorOfVec6f::at

```cpp
cv::Vec6f VectorOfVec6f::at( size_t index )

AutoIt:
    $oVectorOfVec6f.at( $index ) -> retval
```

```cpp
void VectorOfVec6f::at( size_t    index,
                        cv::Vec6f value )

AutoIt:
    $oVectorOfVec6f.at( $index, $value ) -> None
```

### VectorOfVec6f::size

```cpp
size_t VectorOfVec6f::size()

AutoIt:
    $oVectorOfVec6f.size() -> retval
```

### VectorOfVec6f::empty

```cpp
bool VectorOfVec6f::empty()

AutoIt:
    $oVectorOfVec6f.empty() -> retval
```

### VectorOfVec6f::clear

```cpp
void VectorOfVec6f::clear()

AutoIt:
    $oVectorOfVec6f.clear() -> None
```

### VectorOfVec6f::push_vector

```cpp
void VectorOfVec6f::push_vector( VectorOfVec6f other )

AutoIt:
    $oVectorOfVec6f.push_vector( $other ) -> None
```

```cpp
void VectorOfVec6f::push_vector( VectorOfVec6f other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec6f.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec6f::slice

```cpp
VectorOfVec6f VectorOfVec6f::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec6f.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec6f::sort

```cpp
void VectorOfVec6f::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec6f.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec6f::sort_variant

```cpp
void VectorOfVec6f::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec6f.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec6f::start

```cpp
void* VectorOfVec6f::start()

AutoIt:
    $oVectorOfVec6f.start() -> retval
```

### VectorOfVec6f::end

```cpp
void* VectorOfVec6f::end()

AutoIt:
    $oVectorOfVec6f.end() -> retval
```

### VectorOfVec6f::get_Item

```cpp
cv::Vec6f VectorOfVec6f::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec6f.Item( $vIndex ) -> retval
    VectorOfVec6f( $vIndex ) -> retval
```

### VectorOfVec6f::put_Item

```cpp
void VectorOfVec6f::put_Item( size_t    vIndex,
                              cv::Vec6f vItem )

AutoIt:
    $oVectorOfVec6f.Item( $vIndex ) = $$vItem
```

## VectorOfVec2d

### VectorOfVec2d::create

```cpp
static VectorOfVec2d VectorOfVec2d::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2d").create() -> <VectorOfVec2d object>
```

```cpp
static VectorOfVec2d VectorOfVec2d::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2d").create( $size ) -> <VectorOfVec2d object>
```

```cpp
static VectorOfVec2d VectorOfVec2d::create( VectorOfVec2d other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec2d").create( $other ) -> <VectorOfVec2d object>
```

### VectorOfVec2d::Keys

```cpp
std::vector<int> VectorOfVec2d::Keys()

AutoIt:
    $oVectorOfVec2d.Keys() -> retval
```

### VectorOfVec2d::Items

```cpp
VectorOfVec2d VectorOfVec2d::Items()

AutoIt:
    $oVectorOfVec2d.Items() -> retval
```

### VectorOfVec2d::push_back

```cpp
void VectorOfVec2d::push_back( cv::Vec2d value )

AutoIt:
    $oVectorOfVec2d.push_back( $value ) -> None
```

### VectorOfVec2d::Add

```cpp
void VectorOfVec2d::Add( cv::Vec2d value )

AutoIt:
    $oVectorOfVec2d.Add( $value ) -> None
```

### VectorOfVec2d::Remove

```cpp
void VectorOfVec2d::Remove( size_t index )

AutoIt:
    $oVectorOfVec2d.Remove( $index ) -> None
```

### VectorOfVec2d::at

```cpp
cv::Vec2d VectorOfVec2d::at( size_t index )

AutoIt:
    $oVectorOfVec2d.at( $index ) -> retval
```

```cpp
void VectorOfVec2d::at( size_t    index,
                        cv::Vec2d value )

AutoIt:
    $oVectorOfVec2d.at( $index, $value ) -> None
```

### VectorOfVec2d::size

```cpp
size_t VectorOfVec2d::size()

AutoIt:
    $oVectorOfVec2d.size() -> retval
```

### VectorOfVec2d::empty

```cpp
bool VectorOfVec2d::empty()

AutoIt:
    $oVectorOfVec2d.empty() -> retval
```

### VectorOfVec2d::clear

```cpp
void VectorOfVec2d::clear()

AutoIt:
    $oVectorOfVec2d.clear() -> None
```

### VectorOfVec2d::push_vector

```cpp
void VectorOfVec2d::push_vector( VectorOfVec2d other )

AutoIt:
    $oVectorOfVec2d.push_vector( $other ) -> None
```

```cpp
void VectorOfVec2d::push_vector( VectorOfVec2d other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec2d.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec2d::slice

```cpp
VectorOfVec2d VectorOfVec2d::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2d.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec2d::sort

```cpp
void VectorOfVec2d::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2d.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec2d::sort_variant

```cpp
void VectorOfVec2d::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec2d.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec2d::start

```cpp
void* VectorOfVec2d::start()

AutoIt:
    $oVectorOfVec2d.start() -> retval
```

### VectorOfVec2d::end

```cpp
void* VectorOfVec2d::end()

AutoIt:
    $oVectorOfVec2d.end() -> retval
```

### VectorOfVec2d::get_Item

```cpp
cv::Vec2d VectorOfVec2d::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec2d.Item( $vIndex ) -> retval
    VectorOfVec2d( $vIndex ) -> retval
```

### VectorOfVec2d::put_Item

```cpp
void VectorOfVec2d::put_Item( size_t    vIndex,
                              cv::Vec2d vItem )

AutoIt:
    $oVectorOfVec2d.Item( $vIndex ) = $$vItem
```

## VectorOfVec3d

### VectorOfVec3d::create

```cpp
static VectorOfVec3d VectorOfVec3d::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3d").create() -> <VectorOfVec3d object>
```

```cpp
static VectorOfVec3d VectorOfVec3d::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3d").create( $size ) -> <VectorOfVec3d object>
```

```cpp
static VectorOfVec3d VectorOfVec3d::create( VectorOfVec3d other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec3d").create( $other ) -> <VectorOfVec3d object>
```

### VectorOfVec3d::Keys

```cpp
std::vector<int> VectorOfVec3d::Keys()

AutoIt:
    $oVectorOfVec3d.Keys() -> retval
```

### VectorOfVec3d::Items

```cpp
VectorOfVec3d VectorOfVec3d::Items()

AutoIt:
    $oVectorOfVec3d.Items() -> retval
```

### VectorOfVec3d::push_back

```cpp
void VectorOfVec3d::push_back( cv::Vec3d value )

AutoIt:
    $oVectorOfVec3d.push_back( $value ) -> None
```

### VectorOfVec3d::Add

```cpp
void VectorOfVec3d::Add( cv::Vec3d value )

AutoIt:
    $oVectorOfVec3d.Add( $value ) -> None
```

### VectorOfVec3d::Remove

```cpp
void VectorOfVec3d::Remove( size_t index )

AutoIt:
    $oVectorOfVec3d.Remove( $index ) -> None
```

### VectorOfVec3d::at

```cpp
cv::Vec3d VectorOfVec3d::at( size_t index )

AutoIt:
    $oVectorOfVec3d.at( $index ) -> retval
```

```cpp
void VectorOfVec3d::at( size_t    index,
                        cv::Vec3d value )

AutoIt:
    $oVectorOfVec3d.at( $index, $value ) -> None
```

### VectorOfVec3d::size

```cpp
size_t VectorOfVec3d::size()

AutoIt:
    $oVectorOfVec3d.size() -> retval
```

### VectorOfVec3d::empty

```cpp
bool VectorOfVec3d::empty()

AutoIt:
    $oVectorOfVec3d.empty() -> retval
```

### VectorOfVec3d::clear

```cpp
void VectorOfVec3d::clear()

AutoIt:
    $oVectorOfVec3d.clear() -> None
```

### VectorOfVec3d::push_vector

```cpp
void VectorOfVec3d::push_vector( VectorOfVec3d other )

AutoIt:
    $oVectorOfVec3d.push_vector( $other ) -> None
```

```cpp
void VectorOfVec3d::push_vector( VectorOfVec3d other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec3d.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec3d::slice

```cpp
VectorOfVec3d VectorOfVec3d::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3d.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec3d::sort

```cpp
void VectorOfVec3d::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3d.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec3d::sort_variant

```cpp
void VectorOfVec3d::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec3d.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec3d::start

```cpp
void* VectorOfVec3d::start()

AutoIt:
    $oVectorOfVec3d.start() -> retval
```

### VectorOfVec3d::end

```cpp
void* VectorOfVec3d::end()

AutoIt:
    $oVectorOfVec3d.end() -> retval
```

### VectorOfVec3d::get_Item

```cpp
cv::Vec3d VectorOfVec3d::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec3d.Item( $vIndex ) -> retval
    VectorOfVec3d( $vIndex ) -> retval
```

### VectorOfVec3d::put_Item

```cpp
void VectorOfVec3d::put_Item( size_t    vIndex,
                              cv::Vec3d vItem )

AutoIt:
    $oVectorOfVec3d.Item( $vIndex ) = $$vItem
```

## VectorOfVec4d

### VectorOfVec4d::create

```cpp
static VectorOfVec4d VectorOfVec4d::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4d").create() -> <VectorOfVec4d object>
```

```cpp
static VectorOfVec4d VectorOfVec4d::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4d").create( $size ) -> <VectorOfVec4d object>
```

```cpp
static VectorOfVec4d VectorOfVec4d::create( VectorOfVec4d other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec4d").create( $other ) -> <VectorOfVec4d object>
```

### VectorOfVec4d::Keys

```cpp
std::vector<int> VectorOfVec4d::Keys()

AutoIt:
    $oVectorOfVec4d.Keys() -> retval
```

### VectorOfVec4d::Items

```cpp
VectorOfVec4d VectorOfVec4d::Items()

AutoIt:
    $oVectorOfVec4d.Items() -> retval
```

### VectorOfVec4d::push_back

```cpp
void VectorOfVec4d::push_back( cv::Vec4d value )

AutoIt:
    $oVectorOfVec4d.push_back( $value ) -> None
```

### VectorOfVec4d::Add

```cpp
void VectorOfVec4d::Add( cv::Vec4d value )

AutoIt:
    $oVectorOfVec4d.Add( $value ) -> None
```

### VectorOfVec4d::Remove

```cpp
void VectorOfVec4d::Remove( size_t index )

AutoIt:
    $oVectorOfVec4d.Remove( $index ) -> None
```

### VectorOfVec4d::at

```cpp
cv::Vec4d VectorOfVec4d::at( size_t index )

AutoIt:
    $oVectorOfVec4d.at( $index ) -> retval
```

```cpp
void VectorOfVec4d::at( size_t    index,
                        cv::Vec4d value )

AutoIt:
    $oVectorOfVec4d.at( $index, $value ) -> None
```

### VectorOfVec4d::size

```cpp
size_t VectorOfVec4d::size()

AutoIt:
    $oVectorOfVec4d.size() -> retval
```

### VectorOfVec4d::empty

```cpp
bool VectorOfVec4d::empty()

AutoIt:
    $oVectorOfVec4d.empty() -> retval
```

### VectorOfVec4d::clear

```cpp
void VectorOfVec4d::clear()

AutoIt:
    $oVectorOfVec4d.clear() -> None
```

### VectorOfVec4d::push_vector

```cpp
void VectorOfVec4d::push_vector( VectorOfVec4d other )

AutoIt:
    $oVectorOfVec4d.push_vector( $other ) -> None
```

```cpp
void VectorOfVec4d::push_vector( VectorOfVec4d other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec4d.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec4d::slice

```cpp
VectorOfVec4d VectorOfVec4d::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4d.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec4d::sort

```cpp
void VectorOfVec4d::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4d.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec4d::sort_variant

```cpp
void VectorOfVec4d::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec4d.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec4d::start

```cpp
void* VectorOfVec4d::start()

AutoIt:
    $oVectorOfVec4d.start() -> retval
```

### VectorOfVec4d::end

```cpp
void* VectorOfVec4d::end()

AutoIt:
    $oVectorOfVec4d.end() -> retval
```

### VectorOfVec4d::get_Item

```cpp
cv::Vec4d VectorOfVec4d::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec4d.Item( $vIndex ) -> retval
    VectorOfVec4d( $vIndex ) -> retval
```

### VectorOfVec4d::put_Item

```cpp
void VectorOfVec4d::put_Item( size_t    vIndex,
                              cv::Vec4d vItem )

AutoIt:
    $oVectorOfVec4d.Item( $vIndex ) = $$vItem
```

## VectorOfVec6d

### VectorOfVec6d::create

```cpp
static VectorOfVec6d VectorOfVec6d::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec6d").create() -> <VectorOfVec6d object>
```

```cpp
static VectorOfVec6d VectorOfVec6d::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec6d").create( $size ) -> <VectorOfVec6d object>
```

```cpp
static VectorOfVec6d VectorOfVec6d::create( VectorOfVec6d other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVec6d").create( $other ) -> <VectorOfVec6d object>
```

### VectorOfVec6d::Keys

```cpp
std::vector<int> VectorOfVec6d::Keys()

AutoIt:
    $oVectorOfVec6d.Keys() -> retval
```

### VectorOfVec6d::Items

```cpp
VectorOfVec6d VectorOfVec6d::Items()

AutoIt:
    $oVectorOfVec6d.Items() -> retval
```

### VectorOfVec6d::push_back

```cpp
void VectorOfVec6d::push_back( cv::Vec6d value )

AutoIt:
    $oVectorOfVec6d.push_back( $value ) -> None
```

### VectorOfVec6d::Add

```cpp
void VectorOfVec6d::Add( cv::Vec6d value )

AutoIt:
    $oVectorOfVec6d.Add( $value ) -> None
```

### VectorOfVec6d::Remove

```cpp
void VectorOfVec6d::Remove( size_t index )

AutoIt:
    $oVectorOfVec6d.Remove( $index ) -> None
```

### VectorOfVec6d::at

```cpp
cv::Vec6d VectorOfVec6d::at( size_t index )

AutoIt:
    $oVectorOfVec6d.at( $index ) -> retval
```

```cpp
void VectorOfVec6d::at( size_t    index,
                        cv::Vec6d value )

AutoIt:
    $oVectorOfVec6d.at( $index, $value ) -> None
```

### VectorOfVec6d::size

```cpp
size_t VectorOfVec6d::size()

AutoIt:
    $oVectorOfVec6d.size() -> retval
```

### VectorOfVec6d::empty

```cpp
bool VectorOfVec6d::empty()

AutoIt:
    $oVectorOfVec6d.empty() -> retval
```

### VectorOfVec6d::clear

```cpp
void VectorOfVec6d::clear()

AutoIt:
    $oVectorOfVec6d.clear() -> None
```

### VectorOfVec6d::push_vector

```cpp
void VectorOfVec6d::push_vector( VectorOfVec6d other )

AutoIt:
    $oVectorOfVec6d.push_vector( $other ) -> None
```

```cpp
void VectorOfVec6d::push_vector( VectorOfVec6d other,
                                 size_t        count,
                                 size_t        start = 0 )

AutoIt:
    $oVectorOfVec6d.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVec6d::slice

```cpp
VectorOfVec6d VectorOfVec6d::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec6d.slice( [$start[, $count]] ) -> retval
```

### VectorOfVec6d::sort

```cpp
void VectorOfVec6d::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec6d.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec6d::sort_variant

```cpp
void VectorOfVec6d::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVec6d.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVec6d::start

```cpp
void* VectorOfVec6d::start()

AutoIt:
    $oVectorOfVec6d.start() -> retval
```

### VectorOfVec6d::end

```cpp
void* VectorOfVec6d::end()

AutoIt:
    $oVectorOfVec6d.end() -> retval
```

### VectorOfVec6d::get_Item

```cpp
cv::Vec6d VectorOfVec6d::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVec6d.Item( $vIndex ) -> retval
    VectorOfVec6d( $vIndex ) -> retval
```

### VectorOfVec6d::put_Item

```cpp
void VectorOfVec6d::put_Item( size_t    vIndex,
                              cv::Vec6d vItem )

AutoIt:
    $oVectorOfVec6d.Item( $vIndex ) = $$vItem
```

## VectorOfPoint2f

### VectorOfPoint2f::create

```cpp
static VectorOfPoint2f VectorOfPoint2f::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfPoint2f").create() -> <VectorOfPoint2f object>
```

```cpp
static VectorOfPoint2f VectorOfPoint2f::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfPoint2f").create( $size ) -> <VectorOfPoint2f object>
```

```cpp
static VectorOfPoint2f VectorOfPoint2f::create( VectorOfPoint2f other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfPoint2f").create( $other ) -> <VectorOfPoint2f object>
```

### VectorOfPoint2f::Keys

```cpp
std::vector<int> VectorOfPoint2f::Keys()

AutoIt:
    $oVectorOfPoint2f.Keys() -> retval
```

### VectorOfPoint2f::Items

```cpp
VectorOfPoint2f VectorOfPoint2f::Items()

AutoIt:
    $oVectorOfPoint2f.Items() -> retval
```

### VectorOfPoint2f::push_back

```cpp
void VectorOfPoint2f::push_back( cv::Point2f value )

AutoIt:
    $oVectorOfPoint2f.push_back( $value ) -> None
```

### VectorOfPoint2f::Add

```cpp
void VectorOfPoint2f::Add( cv::Point2f value )

AutoIt:
    $oVectorOfPoint2f.Add( $value ) -> None
```

### VectorOfPoint2f::Remove

```cpp
void VectorOfPoint2f::Remove( size_t index )

AutoIt:
    $oVectorOfPoint2f.Remove( $index ) -> None
```

### VectorOfPoint2f::at

```cpp
cv::Point2f VectorOfPoint2f::at( size_t index )

AutoIt:
    $oVectorOfPoint2f.at( $index ) -> retval
```

```cpp
void VectorOfPoint2f::at( size_t      index,
                          cv::Point2f value )

AutoIt:
    $oVectorOfPoint2f.at( $index, $value ) -> None
```

### VectorOfPoint2f::size

```cpp
size_t VectorOfPoint2f::size()

AutoIt:
    $oVectorOfPoint2f.size() -> retval
```

### VectorOfPoint2f::empty

```cpp
bool VectorOfPoint2f::empty()

AutoIt:
    $oVectorOfPoint2f.empty() -> retval
```

### VectorOfPoint2f::clear

```cpp
void VectorOfPoint2f::clear()

AutoIt:
    $oVectorOfPoint2f.clear() -> None
```

### VectorOfPoint2f::push_vector

```cpp
void VectorOfPoint2f::push_vector( VectorOfPoint2f other )

AutoIt:
    $oVectorOfPoint2f.push_vector( $other ) -> None
```

```cpp
void VectorOfPoint2f::push_vector( VectorOfPoint2f other,
                                   size_t          count,
                                   size_t          start = 0 )

AutoIt:
    $oVectorOfPoint2f.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfPoint2f::slice

```cpp
VectorOfPoint2f VectorOfPoint2f::slice( size_t start = 0,
                                        size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfPoint2f.slice( [$start[, $count]] ) -> retval
```

### VectorOfPoint2f::sort

```cpp
void VectorOfPoint2f::sort( void*  comparator,
                            size_t start = 0,
                            size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfPoint2f.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPoint2f::sort_variant

```cpp
void VectorOfPoint2f::sort_variant( void*  comparator,
                                    size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfPoint2f.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPoint2f::start

```cpp
void* VectorOfPoint2f::start()

AutoIt:
    $oVectorOfPoint2f.start() -> retval
```

### VectorOfPoint2f::end

```cpp
void* VectorOfPoint2f::end()

AutoIt:
    $oVectorOfPoint2f.end() -> retval
```

### VectorOfPoint2f::get_Item

```cpp
cv::Point2f VectorOfPoint2f::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfPoint2f.Item( $vIndex ) -> retval
    VectorOfPoint2f( $vIndex ) -> retval
```

### VectorOfPoint2f::put_Item

```cpp
void VectorOfPoint2f::put_Item( size_t      vIndex,
                                cv::Point2f vItem )

AutoIt:
    $oVectorOfPoint2f.Item( $vIndex ) = $$vItem
```

## VectorOfVectorOfPoint2f

### VectorOfVectorOfPoint2f::create

```cpp
static VectorOfVectorOfPoint2f VectorOfVectorOfPoint2f::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfPoint2f").create() -> <VectorOfVectorOfPoint2f object>
```

```cpp
static VectorOfVectorOfPoint2f VectorOfVectorOfPoint2f::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfPoint2f").create( $size ) -> <VectorOfVectorOfPoint2f object>
```

```cpp
static VectorOfVectorOfPoint2f VectorOfVectorOfPoint2f::create( VectorOfVectorOfPoint2f other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfPoint2f").create( $other ) -> <VectorOfVectorOfPoint2f object>
```

### VectorOfVectorOfPoint2f::Keys

```cpp
std::vector<int> VectorOfVectorOfPoint2f::Keys()

AutoIt:
    $oVectorOfVectorOfPoint2f.Keys() -> retval
```

### VectorOfVectorOfPoint2f::Items

```cpp
VectorOfVectorOfPoint2f VectorOfVectorOfPoint2f::Items()

AutoIt:
    $oVectorOfVectorOfPoint2f.Items() -> retval
```

### VectorOfVectorOfPoint2f::push_back

```cpp
void VectorOfVectorOfPoint2f::push_back( std::vector<cv::Point2f> value )

AutoIt:
    $oVectorOfVectorOfPoint2f.push_back( $value ) -> None
```

### VectorOfVectorOfPoint2f::Add

```cpp
void VectorOfVectorOfPoint2f::Add( std::vector<cv::Point2f> value )

AutoIt:
    $oVectorOfVectorOfPoint2f.Add( $value ) -> None
```

### VectorOfVectorOfPoint2f::Remove

```cpp
void VectorOfVectorOfPoint2f::Remove( size_t index )

AutoIt:
    $oVectorOfVectorOfPoint2f.Remove( $index ) -> None
```

### VectorOfVectorOfPoint2f::at

```cpp
std::vector<cv::Point2f> VectorOfVectorOfPoint2f::at( size_t index )

AutoIt:
    $oVectorOfVectorOfPoint2f.at( $index ) -> retval
```

```cpp
void VectorOfVectorOfPoint2f::at( size_t                   index,
                                  std::vector<cv::Point2f> value )

AutoIt:
    $oVectorOfVectorOfPoint2f.at( $index, $value ) -> None
```

### VectorOfVectorOfPoint2f::size

```cpp
size_t VectorOfVectorOfPoint2f::size()

AutoIt:
    $oVectorOfVectorOfPoint2f.size() -> retval
```

### VectorOfVectorOfPoint2f::empty

```cpp
bool VectorOfVectorOfPoint2f::empty()

AutoIt:
    $oVectorOfVectorOfPoint2f.empty() -> retval
```

### VectorOfVectorOfPoint2f::clear

```cpp
void VectorOfVectorOfPoint2f::clear()

AutoIt:
    $oVectorOfVectorOfPoint2f.clear() -> None
```

### VectorOfVectorOfPoint2f::push_vector

```cpp
void VectorOfVectorOfPoint2f::push_vector( VectorOfVectorOfPoint2f other )

AutoIt:
    $oVectorOfVectorOfPoint2f.push_vector( $other ) -> None
```

```cpp
void VectorOfVectorOfPoint2f::push_vector( VectorOfVectorOfPoint2f other,
                                           size_t                  count,
                                           size_t                  start = 0 )

AutoIt:
    $oVectorOfVectorOfPoint2f.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVectorOfPoint2f::slice

```cpp
VectorOfVectorOfPoint2f VectorOfVectorOfPoint2f::slice( size_t start = 0,
                                                        size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfPoint2f.slice( [$start[, $count]] ) -> retval
```

### VectorOfVectorOfPoint2f::sort

```cpp
void VectorOfVectorOfPoint2f::sort( void*  comparator,
                                    size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfPoint2f.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfPoint2f::sort_variant

```cpp
void VectorOfVectorOfPoint2f::sort_variant( void*  comparator,
                                            size_t start = 0,
                                            size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfPoint2f.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfPoint2f::start

```cpp
void* VectorOfVectorOfPoint2f::start()

AutoIt:
    $oVectorOfVectorOfPoint2f.start() -> retval
```

### VectorOfVectorOfPoint2f::end

```cpp
void* VectorOfVectorOfPoint2f::end()

AutoIt:
    $oVectorOfVectorOfPoint2f.end() -> retval
```

### VectorOfVectorOfPoint2f::get_Item

```cpp
std::vector<cv::Point2f> VectorOfVectorOfPoint2f::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVectorOfPoint2f.Item( $vIndex ) -> retval
    VectorOfVectorOfPoint2f( $vIndex ) -> retval
```

### VectorOfVectorOfPoint2f::put_Item

```cpp
void VectorOfVectorOfPoint2f::put_Item( size_t                   vIndex,
                                        std::vector<cv::Point2f> vItem )

AutoIt:
    $oVectorOfVectorOfPoint2f.Item( $vIndex ) = $$vItem
```

## VectorOfRect2d

### VectorOfRect2d::create

```cpp
static VectorOfRect2d VectorOfRect2d::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfRect2d").create() -> <VectorOfRect2d object>
```

```cpp
static VectorOfRect2d VectorOfRect2d::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfRect2d").create( $size ) -> <VectorOfRect2d object>
```

```cpp
static VectorOfRect2d VectorOfRect2d::create( VectorOfRect2d other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfRect2d").create( $other ) -> <VectorOfRect2d object>
```

### VectorOfRect2d::Keys

```cpp
std::vector<int> VectorOfRect2d::Keys()

AutoIt:
    $oVectorOfRect2d.Keys() -> retval
```

### VectorOfRect2d::Items

```cpp
VectorOfRect2d VectorOfRect2d::Items()

AutoIt:
    $oVectorOfRect2d.Items() -> retval
```

### VectorOfRect2d::push_back

```cpp
void VectorOfRect2d::push_back( cv::Rect2d value )

AutoIt:
    $oVectorOfRect2d.push_back( $value ) -> None
```

### VectorOfRect2d::Add

```cpp
void VectorOfRect2d::Add( cv::Rect2d value )

AutoIt:
    $oVectorOfRect2d.Add( $value ) -> None
```

### VectorOfRect2d::Remove

```cpp
void VectorOfRect2d::Remove( size_t index )

AutoIt:
    $oVectorOfRect2d.Remove( $index ) -> None
```

### VectorOfRect2d::at

```cpp
cv::Rect2d VectorOfRect2d::at( size_t index )

AutoIt:
    $oVectorOfRect2d.at( $index ) -> retval
```

```cpp
void VectorOfRect2d::at( size_t     index,
                         cv::Rect2d value )

AutoIt:
    $oVectorOfRect2d.at( $index, $value ) -> None
```

### VectorOfRect2d::size

```cpp
size_t VectorOfRect2d::size()

AutoIt:
    $oVectorOfRect2d.size() -> retval
```

### VectorOfRect2d::empty

```cpp
bool VectorOfRect2d::empty()

AutoIt:
    $oVectorOfRect2d.empty() -> retval
```

### VectorOfRect2d::clear

```cpp
void VectorOfRect2d::clear()

AutoIt:
    $oVectorOfRect2d.clear() -> None
```

### VectorOfRect2d::push_vector

```cpp
void VectorOfRect2d::push_vector( VectorOfRect2d other )

AutoIt:
    $oVectorOfRect2d.push_vector( $other ) -> None
```

```cpp
void VectorOfRect2d::push_vector( VectorOfRect2d other,
                                  size_t         count,
                                  size_t         start = 0 )

AutoIt:
    $oVectorOfRect2d.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfRect2d::slice

```cpp
VectorOfRect2d VectorOfRect2d::slice( size_t start = 0,
                                      size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfRect2d.slice( [$start[, $count]] ) -> retval
```

### VectorOfRect2d::sort

```cpp
void VectorOfRect2d::sort( void*  comparator,
                           size_t start = 0,
                           size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfRect2d.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfRect2d::sort_variant

```cpp
void VectorOfRect2d::sort_variant( void*  comparator,
                                   size_t start = 0,
                                   size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfRect2d.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfRect2d::start

```cpp
void* VectorOfRect2d::start()

AutoIt:
    $oVectorOfRect2d.start() -> retval
```

### VectorOfRect2d::end

```cpp
void* VectorOfRect2d::end()

AutoIt:
    $oVectorOfRect2d.end() -> retval
```

### VectorOfRect2d::get_Item

```cpp
cv::Rect2d VectorOfRect2d::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfRect2d.Item( $vIndex ) -> retval
    VectorOfRect2d( $vIndex ) -> retval
```

### VectorOfRect2d::put_Item

```cpp
void VectorOfRect2d::put_Item( size_t     vIndex,
                               cv::Rect2d vItem )

AutoIt:
    $oVectorOfRect2d.Item( $vIndex ) = $$vItem
```

## VectorOfVectorOfMat

### VectorOfVectorOfMat::create

```cpp
static VectorOfVectorOfMat VectorOfVectorOfMat::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfMat").create() -> <VectorOfVectorOfMat object>
```

```cpp
static VectorOfVectorOfMat VectorOfVectorOfMat::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfMat").create( $size ) -> <VectorOfVectorOfMat object>
```

```cpp
static VectorOfVectorOfMat VectorOfVectorOfMat::create( VectorOfVectorOfMat other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfMat").create( $other ) -> <VectorOfVectorOfMat object>
```

### VectorOfVectorOfMat::Keys

```cpp
std::vector<int> VectorOfVectorOfMat::Keys()

AutoIt:
    $oVectorOfVectorOfMat.Keys() -> retval
```

### VectorOfVectorOfMat::Items

```cpp
VectorOfVectorOfMat VectorOfVectorOfMat::Items()

AutoIt:
    $oVectorOfVectorOfMat.Items() -> retval
```

### VectorOfVectorOfMat::push_back

```cpp
void VectorOfVectorOfMat::push_back( std::vector<cv::Mat> value )

AutoIt:
    $oVectorOfVectorOfMat.push_back( $value ) -> None
```

### VectorOfVectorOfMat::Add

```cpp
void VectorOfVectorOfMat::Add( std::vector<cv::Mat> value )

AutoIt:
    $oVectorOfVectorOfMat.Add( $value ) -> None
```

### VectorOfVectorOfMat::Remove

```cpp
void VectorOfVectorOfMat::Remove( size_t index )

AutoIt:
    $oVectorOfVectorOfMat.Remove( $index ) -> None
```

### VectorOfVectorOfMat::at

```cpp
std::vector<cv::Mat> VectorOfVectorOfMat::at( size_t index )

AutoIt:
    $oVectorOfVectorOfMat.at( $index ) -> retval
```

```cpp
void VectorOfVectorOfMat::at( size_t               index,
                              std::vector<cv::Mat> value )

AutoIt:
    $oVectorOfVectorOfMat.at( $index, $value ) -> None
```

### VectorOfVectorOfMat::size

```cpp
size_t VectorOfVectorOfMat::size()

AutoIt:
    $oVectorOfVectorOfMat.size() -> retval
```

### VectorOfVectorOfMat::empty

```cpp
bool VectorOfVectorOfMat::empty()

AutoIt:
    $oVectorOfVectorOfMat.empty() -> retval
```

### VectorOfVectorOfMat::clear

```cpp
void VectorOfVectorOfMat::clear()

AutoIt:
    $oVectorOfVectorOfMat.clear() -> None
```

### VectorOfVectorOfMat::push_vector

```cpp
void VectorOfVectorOfMat::push_vector( VectorOfVectorOfMat other )

AutoIt:
    $oVectorOfVectorOfMat.push_vector( $other ) -> None
```

```cpp
void VectorOfVectorOfMat::push_vector( VectorOfVectorOfMat other,
                                       size_t              count,
                                       size_t              start = 0 )

AutoIt:
    $oVectorOfVectorOfMat.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVectorOfMat::slice

```cpp
VectorOfVectorOfMat VectorOfVectorOfMat::slice( size_t start = 0,
                                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfMat.slice( [$start[, $count]] ) -> retval
```

### VectorOfVectorOfMat::sort

```cpp
void VectorOfVectorOfMat::sort( void*  comparator,
                                size_t start = 0,
                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfMat.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfMat::sort_variant

```cpp
void VectorOfVectorOfMat::sort_variant( void*  comparator,
                                        size_t start = 0,
                                        size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfMat.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfMat::start

```cpp
void* VectorOfVectorOfMat::start()

AutoIt:
    $oVectorOfVectorOfMat.start() -> retval
```

### VectorOfVectorOfMat::end

```cpp
void* VectorOfVectorOfMat::end()

AutoIt:
    $oVectorOfVectorOfMat.end() -> retval
```

### VectorOfVectorOfMat::get_Item

```cpp
std::vector<cv::Mat> VectorOfVectorOfMat::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVectorOfMat.Item( $vIndex ) -> retval
    VectorOfVectorOfMat( $vIndex ) -> retval
```

### VectorOfVectorOfMat::put_Item

```cpp
void VectorOfVectorOfMat::put_Item( size_t               vIndex,
                                    std::vector<cv::Mat> vItem )

AutoIt:
    $oVectorOfVectorOfMat.Item( $vIndex ) = $$vItem
```

## VectorOfVectorOfInt

### VectorOfVectorOfInt::create

```cpp
static VectorOfVectorOfInt VectorOfVectorOfInt::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfInt").create() -> <VectorOfVectorOfInt object>
```

```cpp
static VectorOfVectorOfInt VectorOfVectorOfInt::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfInt").create( $size ) -> <VectorOfVectorOfInt object>
```

```cpp
static VectorOfVectorOfInt VectorOfVectorOfInt::create( VectorOfVectorOfInt other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfInt").create( $other ) -> <VectorOfVectorOfInt object>
```

### VectorOfVectorOfInt::Keys

```cpp
std::vector<int> VectorOfVectorOfInt::Keys()

AutoIt:
    $oVectorOfVectorOfInt.Keys() -> retval
```

### VectorOfVectorOfInt::Items

```cpp
VectorOfVectorOfInt VectorOfVectorOfInt::Items()

AutoIt:
    $oVectorOfVectorOfInt.Items() -> retval
```

### VectorOfVectorOfInt::push_back

```cpp
void VectorOfVectorOfInt::push_back( std::vector<int> value )

AutoIt:
    $oVectorOfVectorOfInt.push_back( $value ) -> None
```

### VectorOfVectorOfInt::Add

```cpp
void VectorOfVectorOfInt::Add( std::vector<int> value )

AutoIt:
    $oVectorOfVectorOfInt.Add( $value ) -> None
```

### VectorOfVectorOfInt::Remove

```cpp
void VectorOfVectorOfInt::Remove( size_t index )

AutoIt:
    $oVectorOfVectorOfInt.Remove( $index ) -> None
```

### VectorOfVectorOfInt::at

```cpp
std::vector<int> VectorOfVectorOfInt::at( size_t index )

AutoIt:
    $oVectorOfVectorOfInt.at( $index ) -> retval
```

```cpp
void VectorOfVectorOfInt::at( size_t           index,
                              std::vector<int> value )

AutoIt:
    $oVectorOfVectorOfInt.at( $index, $value ) -> None
```

### VectorOfVectorOfInt::size

```cpp
size_t VectorOfVectorOfInt::size()

AutoIt:
    $oVectorOfVectorOfInt.size() -> retval
```

### VectorOfVectorOfInt::empty

```cpp
bool VectorOfVectorOfInt::empty()

AutoIt:
    $oVectorOfVectorOfInt.empty() -> retval
```

### VectorOfVectorOfInt::clear

```cpp
void VectorOfVectorOfInt::clear()

AutoIt:
    $oVectorOfVectorOfInt.clear() -> None
```

### VectorOfVectorOfInt::push_vector

```cpp
void VectorOfVectorOfInt::push_vector( VectorOfVectorOfInt other )

AutoIt:
    $oVectorOfVectorOfInt.push_vector( $other ) -> None
```

```cpp
void VectorOfVectorOfInt::push_vector( VectorOfVectorOfInt other,
                                       size_t              count,
                                       size_t              start = 0 )

AutoIt:
    $oVectorOfVectorOfInt.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVectorOfInt::slice

```cpp
VectorOfVectorOfInt VectorOfVectorOfInt::slice( size_t start = 0,
                                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfInt.slice( [$start[, $count]] ) -> retval
```

### VectorOfVectorOfInt::sort

```cpp
void VectorOfVectorOfInt::sort( void*  comparator,
                                size_t start = 0,
                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfInt.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfInt::sort_variant

```cpp
void VectorOfVectorOfInt::sort_variant( void*  comparator,
                                        size_t start = 0,
                                        size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfInt.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfInt::start

```cpp
void* VectorOfVectorOfInt::start()

AutoIt:
    $oVectorOfVectorOfInt.start() -> retval
```

### VectorOfVectorOfInt::end

```cpp
void* VectorOfVectorOfInt::end()

AutoIt:
    $oVectorOfVectorOfInt.end() -> retval
```

### VectorOfVectorOfInt::get_Item

```cpp
std::vector<int> VectorOfVectorOfInt::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVectorOfInt.Item( $vIndex ) -> retval
    VectorOfVectorOfInt( $vIndex ) -> retval
```

### VectorOfVectorOfInt::put_Item

```cpp
void VectorOfVectorOfInt::put_Item( size_t           vIndex,
                                    std::vector<int> vItem )

AutoIt:
    $oVectorOfVectorOfInt.Item( $vIndex ) = $$vItem
```

## VectorOfVectorOfVectorOfInt

### VectorOfVectorOfVectorOfInt::create

```cpp
static VectorOfVectorOfVectorOfInt VectorOfVectorOfVectorOfInt::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfVectorOfInt").create() -> <VectorOfVectorOfVectorOfInt object>
```

```cpp
static VectorOfVectorOfVectorOfInt VectorOfVectorOfVectorOfInt::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfVectorOfInt").create( $size ) -> <VectorOfVectorOfVectorOfInt object>
```

```cpp
static VectorOfVectorOfVectorOfInt VectorOfVectorOfVectorOfInt::create( VectorOfVectorOfVectorOfInt other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfVectorOfInt").create( $other ) -> <VectorOfVectorOfVectorOfInt object>
```

### VectorOfVectorOfVectorOfInt::Keys

```cpp
std::vector<int> VectorOfVectorOfVectorOfInt::Keys()

AutoIt:
    $oVectorOfVectorOfVectorOfInt.Keys() -> retval
```

### VectorOfVectorOfVectorOfInt::Items

```cpp
VectorOfVectorOfVectorOfInt VectorOfVectorOfVectorOfInt::Items()

AutoIt:
    $oVectorOfVectorOfVectorOfInt.Items() -> retval
```

### VectorOfVectorOfVectorOfInt::push_back

```cpp
void VectorOfVectorOfVectorOfInt::push_back( std::vector<std::vector<int>> value )

AutoIt:
    $oVectorOfVectorOfVectorOfInt.push_back( $value ) -> None
```

### VectorOfVectorOfVectorOfInt::Add

```cpp
void VectorOfVectorOfVectorOfInt::Add( std::vector<std::vector<int>> value )

AutoIt:
    $oVectorOfVectorOfVectorOfInt.Add( $value ) -> None
```

### VectorOfVectorOfVectorOfInt::Remove

```cpp
void VectorOfVectorOfVectorOfInt::Remove( size_t index )

AutoIt:
    $oVectorOfVectorOfVectorOfInt.Remove( $index ) -> None
```

### VectorOfVectorOfVectorOfInt::at

```cpp
std::vector<std::vector<int>> VectorOfVectorOfVectorOfInt::at( size_t index )

AutoIt:
    $oVectorOfVectorOfVectorOfInt.at( $index ) -> retval
```

```cpp
void VectorOfVectorOfVectorOfInt::at( size_t                        index,
                                      std::vector<std::vector<int>> value )

AutoIt:
    $oVectorOfVectorOfVectorOfInt.at( $index, $value ) -> None
```

### VectorOfVectorOfVectorOfInt::size

```cpp
size_t VectorOfVectorOfVectorOfInt::size()

AutoIt:
    $oVectorOfVectorOfVectorOfInt.size() -> retval
```

### VectorOfVectorOfVectorOfInt::empty

```cpp
bool VectorOfVectorOfVectorOfInt::empty()

AutoIt:
    $oVectorOfVectorOfVectorOfInt.empty() -> retval
```

### VectorOfVectorOfVectorOfInt::clear

```cpp
void VectorOfVectorOfVectorOfInt::clear()

AutoIt:
    $oVectorOfVectorOfVectorOfInt.clear() -> None
```

### VectorOfVectorOfVectorOfInt::push_vector

```cpp
void VectorOfVectorOfVectorOfInt::push_vector( VectorOfVectorOfVectorOfInt other )

AutoIt:
    $oVectorOfVectorOfVectorOfInt.push_vector( $other ) -> None
```

```cpp
void VectorOfVectorOfVectorOfInt::push_vector( VectorOfVectorOfVectorOfInt other,
                                               size_t                      count,
                                               size_t                      start = 0 )

AutoIt:
    $oVectorOfVectorOfVectorOfInt.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVectorOfVectorOfInt::slice

```cpp
VectorOfVectorOfVectorOfInt VectorOfVectorOfVectorOfInt::slice( size_t start = 0,
                                                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfVectorOfInt.slice( [$start[, $count]] ) -> retval
```

### VectorOfVectorOfVectorOfInt::sort

```cpp
void VectorOfVectorOfVectorOfInt::sort( void*  comparator,
                                        size_t start = 0,
                                        size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfVectorOfInt.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfVectorOfInt::sort_variant

```cpp
void VectorOfVectorOfVectorOfInt::sort_variant( void*  comparator,
                                                size_t start = 0,
                                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfVectorOfInt.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfVectorOfInt::start

```cpp
void* VectorOfVectorOfVectorOfInt::start()

AutoIt:
    $oVectorOfVectorOfVectorOfInt.start() -> retval
```

### VectorOfVectorOfVectorOfInt::end

```cpp
void* VectorOfVectorOfVectorOfInt::end()

AutoIt:
    $oVectorOfVectorOfVectorOfInt.end() -> retval
```

### VectorOfVectorOfVectorOfInt::get_Item

```cpp
std::vector<std::vector<int>> VectorOfVectorOfVectorOfInt::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVectorOfVectorOfInt.Item( $vIndex ) -> retval
    VectorOfVectorOfVectorOfInt( $vIndex ) -> retval
```

### VectorOfVectorOfVectorOfInt::put_Item

```cpp
void VectorOfVectorOfVectorOfInt::put_Item( size_t                        vIndex,
                                            std::vector<std::vector<int>> vItem )

AutoIt:
    $oVectorOfVectorOfVectorOfInt.Item( $vIndex ) = $$vItem
```

## VectorOfVectorOfPoint

### VectorOfVectorOfPoint::create

```cpp
static VectorOfVectorOfPoint VectorOfVectorOfPoint::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfPoint").create() -> <VectorOfVectorOfPoint object>
```

```cpp
static VectorOfVectorOfPoint VectorOfVectorOfPoint::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfPoint").create( $size ) -> <VectorOfVectorOfPoint object>
```

```cpp
static VectorOfVectorOfPoint VectorOfVectorOfPoint::create( VectorOfVectorOfPoint other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfPoint").create( $other ) -> <VectorOfVectorOfPoint object>
```

### VectorOfVectorOfPoint::Keys

```cpp
std::vector<int> VectorOfVectorOfPoint::Keys()

AutoIt:
    $oVectorOfVectorOfPoint.Keys() -> retval
```

### VectorOfVectorOfPoint::Items

```cpp
VectorOfVectorOfPoint VectorOfVectorOfPoint::Items()

AutoIt:
    $oVectorOfVectorOfPoint.Items() -> retval
```

### VectorOfVectorOfPoint::push_back

```cpp
void VectorOfVectorOfPoint::push_back( std::vector<cv::Point> value )

AutoIt:
    $oVectorOfVectorOfPoint.push_back( $value ) -> None
```

### VectorOfVectorOfPoint::Add

```cpp
void VectorOfVectorOfPoint::Add( std::vector<cv::Point> value )

AutoIt:
    $oVectorOfVectorOfPoint.Add( $value ) -> None
```

### VectorOfVectorOfPoint::Remove

```cpp
void VectorOfVectorOfPoint::Remove( size_t index )

AutoIt:
    $oVectorOfVectorOfPoint.Remove( $index ) -> None
```

### VectorOfVectorOfPoint::at

```cpp
std::vector<cv::Point> VectorOfVectorOfPoint::at( size_t index )

AutoIt:
    $oVectorOfVectorOfPoint.at( $index ) -> retval
```

```cpp
void VectorOfVectorOfPoint::at( size_t                 index,
                                std::vector<cv::Point> value )

AutoIt:
    $oVectorOfVectorOfPoint.at( $index, $value ) -> None
```

### VectorOfVectorOfPoint::size

```cpp
size_t VectorOfVectorOfPoint::size()

AutoIt:
    $oVectorOfVectorOfPoint.size() -> retval
```

### VectorOfVectorOfPoint::empty

```cpp
bool VectorOfVectorOfPoint::empty()

AutoIt:
    $oVectorOfVectorOfPoint.empty() -> retval
```

### VectorOfVectorOfPoint::clear

```cpp
void VectorOfVectorOfPoint::clear()

AutoIt:
    $oVectorOfVectorOfPoint.clear() -> None
```

### VectorOfVectorOfPoint::push_vector

```cpp
void VectorOfVectorOfPoint::push_vector( VectorOfVectorOfPoint other )

AutoIt:
    $oVectorOfVectorOfPoint.push_vector( $other ) -> None
```

```cpp
void VectorOfVectorOfPoint::push_vector( VectorOfVectorOfPoint other,
                                         size_t                count,
                                         size_t                start = 0 )

AutoIt:
    $oVectorOfVectorOfPoint.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVectorOfPoint::slice

```cpp
VectorOfVectorOfPoint VectorOfVectorOfPoint::slice( size_t start = 0,
                                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfPoint.slice( [$start[, $count]] ) -> retval
```

### VectorOfVectorOfPoint::sort

```cpp
void VectorOfVectorOfPoint::sort( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfPoint.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfPoint::sort_variant

```cpp
void VectorOfVectorOfPoint::sort_variant( void*  comparator,
                                          size_t start = 0,
                                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfPoint.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfPoint::start

```cpp
void* VectorOfVectorOfPoint::start()

AutoIt:
    $oVectorOfVectorOfPoint.start() -> retval
```

### VectorOfVectorOfPoint::end

```cpp
void* VectorOfVectorOfPoint::end()

AutoIt:
    $oVectorOfVectorOfPoint.end() -> retval
```

### VectorOfVectorOfPoint::get_Item

```cpp
std::vector<cv::Point> VectorOfVectorOfPoint::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVectorOfPoint.Item( $vIndex ) -> retval
    VectorOfVectorOfPoint( $vIndex ) -> retval
```

### VectorOfVectorOfPoint::put_Item

```cpp
void VectorOfVectorOfPoint::put_Item( size_t                 vIndex,
                                      std::vector<cv::Point> vItem )

AutoIt:
    $oVectorOfVectorOfPoint.Item( $vIndex ) = $$vItem
```

## VectorOfVectorOfKeyPoint

### VectorOfVectorOfKeyPoint::create

```cpp
static VectorOfVectorOfKeyPoint VectorOfVectorOfKeyPoint::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfKeyPoint").create() -> <VectorOfVectorOfKeyPoint object>
```

```cpp
static VectorOfVectorOfKeyPoint VectorOfVectorOfKeyPoint::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfKeyPoint").create( $size ) -> <VectorOfVectorOfKeyPoint object>
```

```cpp
static VectorOfVectorOfKeyPoint VectorOfVectorOfKeyPoint::create( VectorOfVectorOfKeyPoint other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfVectorOfKeyPoint").create( $other ) -> <VectorOfVectorOfKeyPoint object>
```

### VectorOfVectorOfKeyPoint::Keys

```cpp
std::vector<int> VectorOfVectorOfKeyPoint::Keys()

AutoIt:
    $oVectorOfVectorOfKeyPoint.Keys() -> retval
```

### VectorOfVectorOfKeyPoint::Items

```cpp
VectorOfVectorOfKeyPoint VectorOfVectorOfKeyPoint::Items()

AutoIt:
    $oVectorOfVectorOfKeyPoint.Items() -> retval
```

### VectorOfVectorOfKeyPoint::push_back

```cpp
void VectorOfVectorOfKeyPoint::push_back( std::vector<cv::KeyPoint> value )

AutoIt:
    $oVectorOfVectorOfKeyPoint.push_back( $value ) -> None
```

### VectorOfVectorOfKeyPoint::Add

```cpp
void VectorOfVectorOfKeyPoint::Add( std::vector<cv::KeyPoint> value )

AutoIt:
    $oVectorOfVectorOfKeyPoint.Add( $value ) -> None
```

### VectorOfVectorOfKeyPoint::Remove

```cpp
void VectorOfVectorOfKeyPoint::Remove( size_t index )

AutoIt:
    $oVectorOfVectorOfKeyPoint.Remove( $index ) -> None
```

### VectorOfVectorOfKeyPoint::at

```cpp
std::vector<cv::KeyPoint> VectorOfVectorOfKeyPoint::at( size_t index )

AutoIt:
    $oVectorOfVectorOfKeyPoint.at( $index ) -> retval
```

```cpp
void VectorOfVectorOfKeyPoint::at( size_t                    index,
                                   std::vector<cv::KeyPoint> value )

AutoIt:
    $oVectorOfVectorOfKeyPoint.at( $index, $value ) -> None
```

### VectorOfVectorOfKeyPoint::size

```cpp
size_t VectorOfVectorOfKeyPoint::size()

AutoIt:
    $oVectorOfVectorOfKeyPoint.size() -> retval
```

### VectorOfVectorOfKeyPoint::empty

```cpp
bool VectorOfVectorOfKeyPoint::empty()

AutoIt:
    $oVectorOfVectorOfKeyPoint.empty() -> retval
```

### VectorOfVectorOfKeyPoint::clear

```cpp
void VectorOfVectorOfKeyPoint::clear()

AutoIt:
    $oVectorOfVectorOfKeyPoint.clear() -> None
```

### VectorOfVectorOfKeyPoint::push_vector

```cpp
void VectorOfVectorOfKeyPoint::push_vector( VectorOfVectorOfKeyPoint other )

AutoIt:
    $oVectorOfVectorOfKeyPoint.push_vector( $other ) -> None
```

```cpp
void VectorOfVectorOfKeyPoint::push_vector( VectorOfVectorOfKeyPoint other,
                                            size_t                   count,
                                            size_t                   start = 0 )

AutoIt:
    $oVectorOfVectorOfKeyPoint.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVectorOfKeyPoint::slice

```cpp
VectorOfVectorOfKeyPoint VectorOfVectorOfKeyPoint::slice( size_t start = 0,
                                                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfKeyPoint.slice( [$start[, $count]] ) -> retval
```

### VectorOfVectorOfKeyPoint::sort

```cpp
void VectorOfVectorOfKeyPoint::sort( void*  comparator,
                                     size_t start = 0,
                                     size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfKeyPoint.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfKeyPoint::sort_variant

```cpp
void VectorOfVectorOfKeyPoint::sort_variant( void*  comparator,
                                             size_t start = 0,
                                             size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfVectorOfKeyPoint.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVectorOfKeyPoint::start

```cpp
void* VectorOfVectorOfKeyPoint::start()

AutoIt:
    $oVectorOfVectorOfKeyPoint.start() -> retval
```

### VectorOfVectorOfKeyPoint::end

```cpp
void* VectorOfVectorOfKeyPoint::end()

AutoIt:
    $oVectorOfVectorOfKeyPoint.end() -> retval
```

### VectorOfVectorOfKeyPoint::get_Item

```cpp
std::vector<cv::KeyPoint> VectorOfVectorOfKeyPoint::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfVectorOfKeyPoint.Item( $vIndex ) -> retval
    VectorOfVectorOfKeyPoint( $vIndex ) -> retval
```

### VectorOfVectorOfKeyPoint::put_Item

```cpp
void VectorOfVectorOfKeyPoint::put_Item( size_t                    vIndex,
                                         std::vector<cv::KeyPoint> vItem )

AutoIt:
    $oVectorOfVectorOfKeyPoint.Item( $vIndex ) = $$vItem
```

## VectorOfCameraParams

### VectorOfCameraParams::create

```cpp
static VectorOfCameraParams VectorOfCameraParams::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfCameraParams").create() -> <VectorOfCameraParams object>
```

```cpp
static VectorOfCameraParams VectorOfCameraParams::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfCameraParams").create( $size ) -> <VectorOfCameraParams object>
```

```cpp
static VectorOfCameraParams VectorOfCameraParams::create( VectorOfCameraParams other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfCameraParams").create( $other ) -> <VectorOfCameraParams object>
```

### VectorOfCameraParams::Keys

```cpp
std::vector<int> VectorOfCameraParams::Keys()

AutoIt:
    $oVectorOfCameraParams.Keys() -> retval
```

### VectorOfCameraParams::Items

```cpp
VectorOfCameraParams VectorOfCameraParams::Items()

AutoIt:
    $oVectorOfCameraParams.Items() -> retval
```

### VectorOfCameraParams::push_back

```cpp
void VectorOfCameraParams::push_back( cv::detail::CameraParams value )

AutoIt:
    $oVectorOfCameraParams.push_back( $value ) -> None
```

### VectorOfCameraParams::Add

```cpp
void VectorOfCameraParams::Add( cv::detail::CameraParams value )

AutoIt:
    $oVectorOfCameraParams.Add( $value ) -> None
```

### VectorOfCameraParams::Remove

```cpp
void VectorOfCameraParams::Remove( size_t index )

AutoIt:
    $oVectorOfCameraParams.Remove( $index ) -> None
```

### VectorOfCameraParams::at

```cpp
cv::detail::CameraParams VectorOfCameraParams::at( size_t index )

AutoIt:
    $oVectorOfCameraParams.at( $index ) -> retval
```

```cpp
void VectorOfCameraParams::at( size_t                   index,
                               cv::detail::CameraParams value )

AutoIt:
    $oVectorOfCameraParams.at( $index, $value ) -> None
```

### VectorOfCameraParams::size

```cpp
size_t VectorOfCameraParams::size()

AutoIt:
    $oVectorOfCameraParams.size() -> retval
```

### VectorOfCameraParams::empty

```cpp
bool VectorOfCameraParams::empty()

AutoIt:
    $oVectorOfCameraParams.empty() -> retval
```

### VectorOfCameraParams::clear

```cpp
void VectorOfCameraParams::clear()

AutoIt:
    $oVectorOfCameraParams.clear() -> None
```

### VectorOfCameraParams::push_vector

```cpp
void VectorOfCameraParams::push_vector( VectorOfCameraParams other )

AutoIt:
    $oVectorOfCameraParams.push_vector( $other ) -> None
```

```cpp
void VectorOfCameraParams::push_vector( VectorOfCameraParams other,
                                        size_t               count,
                                        size_t               start = 0 )

AutoIt:
    $oVectorOfCameraParams.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfCameraParams::slice

```cpp
VectorOfCameraParams VectorOfCameraParams::slice( size_t start = 0,
                                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfCameraParams.slice( [$start[, $count]] ) -> retval
```

### VectorOfCameraParams::sort

```cpp
void VectorOfCameraParams::sort( void*  comparator,
                                 size_t start = 0,
                                 size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfCameraParams.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfCameraParams::sort_variant

```cpp
void VectorOfCameraParams::sort_variant( void*  comparator,
                                         size_t start = 0,
                                         size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfCameraParams.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfCameraParams::start

```cpp
void* VectorOfCameraParams::start()

AutoIt:
    $oVectorOfCameraParams.start() -> retval
```

### VectorOfCameraParams::end

```cpp
void* VectorOfCameraParams::end()

AutoIt:
    $oVectorOfCameraParams.end() -> retval
```

### VectorOfCameraParams::get_Item

```cpp
cv::detail::CameraParams VectorOfCameraParams::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfCameraParams.Item( $vIndex ) -> retval
    VectorOfCameraParams( $vIndex ) -> retval
```

### VectorOfCameraParams::put_Item

```cpp
void VectorOfCameraParams::put_Item( size_t                   vIndex,
                                     cv::detail::CameraParams vItem )

AutoIt:
    $oVectorOfCameraParams.Item( $vIndex ) = $$vItem
```

## VectorOfGCompileArg

### VectorOfGCompileArg::create

```cpp
static VectorOfGCompileArg VectorOfGCompileArg::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfGCompileArg").create() -> <VectorOfGCompileArg object>
```

```cpp
static VectorOfGCompileArg VectorOfGCompileArg::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfGCompileArg").create( $size ) -> <VectorOfGCompileArg object>
```

```cpp
static VectorOfGCompileArg VectorOfGCompileArg::create( VectorOfGCompileArg other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfGCompileArg").create( $other ) -> <VectorOfGCompileArg object>
```

### VectorOfGCompileArg::Keys

```cpp
std::vector<int> VectorOfGCompileArg::Keys()

AutoIt:
    $oVectorOfGCompileArg.Keys() -> retval
```

### VectorOfGCompileArg::Items

```cpp
VectorOfGCompileArg VectorOfGCompileArg::Items()

AutoIt:
    $oVectorOfGCompileArg.Items() -> retval
```

### VectorOfGCompileArg::push_back

```cpp
void VectorOfGCompileArg::push_back( cv::GCompileArg value )

AutoIt:
    $oVectorOfGCompileArg.push_back( $value ) -> None
```

### VectorOfGCompileArg::Add

```cpp
void VectorOfGCompileArg::Add( cv::GCompileArg value )

AutoIt:
    $oVectorOfGCompileArg.Add( $value ) -> None
```

### VectorOfGCompileArg::Remove

```cpp
void VectorOfGCompileArg::Remove( size_t index )

AutoIt:
    $oVectorOfGCompileArg.Remove( $index ) -> None
```

### VectorOfGCompileArg::at

```cpp
cv::GCompileArg VectorOfGCompileArg::at( size_t index )

AutoIt:
    $oVectorOfGCompileArg.at( $index ) -> retval
```

```cpp
void VectorOfGCompileArg::at( size_t          index,
                              cv::GCompileArg value )

AutoIt:
    $oVectorOfGCompileArg.at( $index, $value ) -> None
```

### VectorOfGCompileArg::size

```cpp
size_t VectorOfGCompileArg::size()

AutoIt:
    $oVectorOfGCompileArg.size() -> retval
```

### VectorOfGCompileArg::empty

```cpp
bool VectorOfGCompileArg::empty()

AutoIt:
    $oVectorOfGCompileArg.empty() -> retval
```

### VectorOfGCompileArg::clear

```cpp
void VectorOfGCompileArg::clear()

AutoIt:
    $oVectorOfGCompileArg.clear() -> None
```

### VectorOfGCompileArg::push_vector

```cpp
void VectorOfGCompileArg::push_vector( VectorOfGCompileArg other )

AutoIt:
    $oVectorOfGCompileArg.push_vector( $other ) -> None
```

```cpp
void VectorOfGCompileArg::push_vector( VectorOfGCompileArg other,
                                       size_t              count,
                                       size_t              start = 0 )

AutoIt:
    $oVectorOfGCompileArg.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfGCompileArg::slice

```cpp
VectorOfGCompileArg VectorOfGCompileArg::slice( size_t start = 0,
                                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfGCompileArg.slice( [$start[, $count]] ) -> retval
```

### VectorOfGCompileArg::sort

```cpp
void VectorOfGCompileArg::sort( void*  comparator,
                                size_t start = 0,
                                size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfGCompileArg.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfGCompileArg::sort_variant

```cpp
void VectorOfGCompileArg::sort_variant( void*  comparator,
                                        size_t start = 0,
                                        size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfGCompileArg.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfGCompileArg::start

```cpp
void* VectorOfGCompileArg::start()

AutoIt:
    $oVectorOfGCompileArg.start() -> retval
```

### VectorOfGCompileArg::end

```cpp
void* VectorOfGCompileArg::end()

AutoIt:
    $oVectorOfGCompileArg.end() -> retval
```

### VectorOfGCompileArg::get_Item

```cpp
cv::GCompileArg VectorOfGCompileArg::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfGCompileArg.Item( $vIndex ) -> retval
    VectorOfGCompileArg( $vIndex ) -> retval
```

### VectorOfGCompileArg::put_Item

```cpp
void VectorOfGCompileArg::put_Item( size_t          vIndex,
                                    cv::GCompileArg vItem )

AutoIt:
    $oVectorOfGCompileArg.Item( $vIndex ) = $$vItem
```

## VectorOfGRunArg

### VectorOfGRunArg::create

```cpp
static VectorOfGRunArg VectorOfGRunArg::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfGRunArg").create() -> <VectorOfGRunArg object>
```

```cpp
static VectorOfGRunArg VectorOfGRunArg::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfGRunArg").create( $size ) -> <VectorOfGRunArg object>
```

```cpp
static VectorOfGRunArg VectorOfGRunArg::create( VectorOfGRunArg other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfGRunArg").create( $other ) -> <VectorOfGRunArg object>
```

### VectorOfGRunArg::Keys

```cpp
std::vector<int> VectorOfGRunArg::Keys()

AutoIt:
    $oVectorOfGRunArg.Keys() -> retval
```

### VectorOfGRunArg::Items

```cpp
VectorOfGRunArg VectorOfGRunArg::Items()

AutoIt:
    $oVectorOfGRunArg.Items() -> retval
```

### VectorOfGRunArg::push_back

```cpp
void VectorOfGRunArg::push_back( cv::GRunArg value )

AutoIt:
    $oVectorOfGRunArg.push_back( $value ) -> None
```

### VectorOfGRunArg::Add

```cpp
void VectorOfGRunArg::Add( cv::GRunArg value )

AutoIt:
    $oVectorOfGRunArg.Add( $value ) -> None
```

### VectorOfGRunArg::Remove

```cpp
void VectorOfGRunArg::Remove( size_t index )

AutoIt:
    $oVectorOfGRunArg.Remove( $index ) -> None
```

### VectorOfGRunArg::at

```cpp
cv::GRunArg VectorOfGRunArg::at( size_t index )

AutoIt:
    $oVectorOfGRunArg.at( $index ) -> retval
```

```cpp
void VectorOfGRunArg::at( size_t      index,
                          cv::GRunArg value )

AutoIt:
    $oVectorOfGRunArg.at( $index, $value ) -> None
```

### VectorOfGRunArg::size

```cpp
size_t VectorOfGRunArg::size()

AutoIt:
    $oVectorOfGRunArg.size() -> retval
```

### VectorOfGRunArg::empty

```cpp
bool VectorOfGRunArg::empty()

AutoIt:
    $oVectorOfGRunArg.empty() -> retval
```

### VectorOfGRunArg::clear

```cpp
void VectorOfGRunArg::clear()

AutoIt:
    $oVectorOfGRunArg.clear() -> None
```

### VectorOfGRunArg::push_vector

```cpp
void VectorOfGRunArg::push_vector( VectorOfGRunArg other )

AutoIt:
    $oVectorOfGRunArg.push_vector( $other ) -> None
```

```cpp
void VectorOfGRunArg::push_vector( VectorOfGRunArg other,
                                   size_t          count,
                                   size_t          start = 0 )

AutoIt:
    $oVectorOfGRunArg.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfGRunArg::slice

```cpp
VectorOfGRunArg VectorOfGRunArg::slice( size_t start = 0,
                                        size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfGRunArg.slice( [$start[, $count]] ) -> retval
```

### VectorOfGRunArg::sort

```cpp
void VectorOfGRunArg::sort( void*  comparator,
                            size_t start = 0,
                            size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfGRunArg.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfGRunArg::sort_variant

```cpp
void VectorOfGRunArg::sort_variant( void*  comparator,
                                    size_t start = 0,
                                    size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfGRunArg.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfGRunArg::start

```cpp
void* VectorOfGRunArg::start()

AutoIt:
    $oVectorOfGRunArg.start() -> retval
```

### VectorOfGRunArg::end

```cpp
void* VectorOfGRunArg::end()

AutoIt:
    $oVectorOfGRunArg.end() -> retval
```

### VectorOfGRunArg::get_Item

```cpp
cv::GRunArg VectorOfGRunArg::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfGRunArg.Item( $vIndex ) -> retval
    VectorOfGRunArg( $vIndex ) -> retval
```

### VectorOfGRunArg::put_Item

```cpp
void VectorOfGRunArg::put_Item( size_t      vIndex,
                                cv::GRunArg vItem )

AutoIt:
    $oVectorOfGRunArg.Item( $vIndex ) = $$vItem
```

## VectorOfGMetaArg

### VectorOfGMetaArg::create

```cpp
static VectorOfGMetaArg VectorOfGMetaArg::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfGMetaArg").create() -> <VectorOfGMetaArg object>
```

```cpp
static VectorOfGMetaArg VectorOfGMetaArg::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfGMetaArg").create( $size ) -> <VectorOfGMetaArg object>
```

```cpp
static VectorOfGMetaArg VectorOfGMetaArg::create( VectorOfGMetaArg other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfGMetaArg").create( $other ) -> <VectorOfGMetaArg object>
```

### VectorOfGMetaArg::Keys

```cpp
std::vector<int> VectorOfGMetaArg::Keys()

AutoIt:
    $oVectorOfGMetaArg.Keys() -> retval
```

### VectorOfGMetaArg::Items

```cpp
VectorOfGMetaArg VectorOfGMetaArg::Items()

AutoIt:
    $oVectorOfGMetaArg.Items() -> retval
```

### VectorOfGMetaArg::push_back

```cpp
void VectorOfGMetaArg::push_back( GMetaArg value )

AutoIt:
    $oVectorOfGMetaArg.push_back( $value ) -> None
```

### VectorOfGMetaArg::Add

```cpp
void VectorOfGMetaArg::Add( GMetaArg value )

AutoIt:
    $oVectorOfGMetaArg.Add( $value ) -> None
```

### VectorOfGMetaArg::Remove

```cpp
void VectorOfGMetaArg::Remove( size_t index )

AutoIt:
    $oVectorOfGMetaArg.Remove( $index ) -> None
```

### VectorOfGMetaArg::at

```cpp
GMetaArg VectorOfGMetaArg::at( size_t index )

AutoIt:
    $oVectorOfGMetaArg.at( $index ) -> retval
```

```cpp
void VectorOfGMetaArg::at( size_t   index,
                           GMetaArg value )

AutoIt:
    $oVectorOfGMetaArg.at( $index, $value ) -> None
```

### VectorOfGMetaArg::size

```cpp
size_t VectorOfGMetaArg::size()

AutoIt:
    $oVectorOfGMetaArg.size() -> retval
```

### VectorOfGMetaArg::empty

```cpp
bool VectorOfGMetaArg::empty()

AutoIt:
    $oVectorOfGMetaArg.empty() -> retval
```

### VectorOfGMetaArg::clear

```cpp
void VectorOfGMetaArg::clear()

AutoIt:
    $oVectorOfGMetaArg.clear() -> None
```

### VectorOfGMetaArg::push_vector

```cpp
void VectorOfGMetaArg::push_vector( VectorOfGMetaArg other )

AutoIt:
    $oVectorOfGMetaArg.push_vector( $other ) -> None
```

```cpp
void VectorOfGMetaArg::push_vector( VectorOfGMetaArg other,
                                    size_t           count,
                                    size_t           start = 0 )

AutoIt:
    $oVectorOfGMetaArg.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfGMetaArg::slice

```cpp
VectorOfGMetaArg VectorOfGMetaArg::slice( size_t start = 0,
                                          size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfGMetaArg.slice( [$start[, $count]] ) -> retval
```

### VectorOfGMetaArg::sort

```cpp
void VectorOfGMetaArg::sort( void*  comparator,
                             size_t start = 0,
                             size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfGMetaArg.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfGMetaArg::sort_variant

```cpp
void VectorOfGMetaArg::sort_variant( void*  comparator,
                                     size_t start = 0,
                                     size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfGMetaArg.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfGMetaArg::start

```cpp
void* VectorOfGMetaArg::start()

AutoIt:
    $oVectorOfGMetaArg.start() -> retval
```

### VectorOfGMetaArg::end

```cpp
void* VectorOfGMetaArg::end()

AutoIt:
    $oVectorOfGMetaArg.end() -> retval
```

### VectorOfGMetaArg::get_Item

```cpp
GMetaArg VectorOfGMetaArg::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfGMetaArg.Item( $vIndex ) -> retval
    VectorOfGMetaArg( $vIndex ) -> retval
```

### VectorOfGMetaArg::put_Item

```cpp
void VectorOfGMetaArg::put_Item( size_t   vIndex,
                                 GMetaArg vItem )

AutoIt:
    $oVectorOfGMetaArg.Item( $vIndex ) = $$vItem
```

## VectorOfGNetParam

### VectorOfGNetParam::create

```cpp
static VectorOfGNetParam VectorOfGNetParam::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfGNetParam").create() -> <VectorOfGNetParam object>
```

```cpp
static VectorOfGNetParam VectorOfGNetParam::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfGNetParam").create( $size ) -> <VectorOfGNetParam object>
```

```cpp
static VectorOfGNetParam VectorOfGNetParam::create( VectorOfGNetParam other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfGNetParam").create( $other ) -> <VectorOfGNetParam object>
```

### VectorOfGNetParam::Keys

```cpp
std::vector<int> VectorOfGNetParam::Keys()

AutoIt:
    $oVectorOfGNetParam.Keys() -> retval
```

### VectorOfGNetParam::Items

```cpp
VectorOfGNetParam VectorOfGNetParam::Items()

AutoIt:
    $oVectorOfGNetParam.Items() -> retval
```

### VectorOfGNetParam::push_back

```cpp
void VectorOfGNetParam::push_back( cv::gapi::GNetParam value )

AutoIt:
    $oVectorOfGNetParam.push_back( $value ) -> None
```

### VectorOfGNetParam::Add

```cpp
void VectorOfGNetParam::Add( cv::gapi::GNetParam value )

AutoIt:
    $oVectorOfGNetParam.Add( $value ) -> None
```

### VectorOfGNetParam::Remove

```cpp
void VectorOfGNetParam::Remove( size_t index )

AutoIt:
    $oVectorOfGNetParam.Remove( $index ) -> None
```

### VectorOfGNetParam::at

```cpp
cv::gapi::GNetParam VectorOfGNetParam::at( size_t index )

AutoIt:
    $oVectorOfGNetParam.at( $index ) -> retval
```

```cpp
void VectorOfGNetParam::at( size_t              index,
                            cv::gapi::GNetParam value )

AutoIt:
    $oVectorOfGNetParam.at( $index, $value ) -> None
```

### VectorOfGNetParam::size

```cpp
size_t VectorOfGNetParam::size()

AutoIt:
    $oVectorOfGNetParam.size() -> retval
```

### VectorOfGNetParam::empty

```cpp
bool VectorOfGNetParam::empty()

AutoIt:
    $oVectorOfGNetParam.empty() -> retval
```

### VectorOfGNetParam::clear

```cpp
void VectorOfGNetParam::clear()

AutoIt:
    $oVectorOfGNetParam.clear() -> None
```

### VectorOfGNetParam::push_vector

```cpp
void VectorOfGNetParam::push_vector( VectorOfGNetParam other )

AutoIt:
    $oVectorOfGNetParam.push_vector( $other ) -> None
```

```cpp
void VectorOfGNetParam::push_vector( VectorOfGNetParam other,
                                     size_t            count,
                                     size_t            start = 0 )

AutoIt:
    $oVectorOfGNetParam.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfGNetParam::slice

```cpp
VectorOfGNetParam VectorOfGNetParam::slice( size_t start = 0,
                                            size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfGNetParam.slice( [$start[, $count]] ) -> retval
```

### VectorOfGNetParam::sort

```cpp
void VectorOfGNetParam::sort( void*  comparator,
                              size_t start = 0,
                              size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfGNetParam.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfGNetParam::sort_variant

```cpp
void VectorOfGNetParam::sort_variant( void*  comparator,
                                      size_t start = 0,
                                      size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfGNetParam.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfGNetParam::start

```cpp
void* VectorOfGNetParam::start()

AutoIt:
    $oVectorOfGNetParam.start() -> retval
```

### VectorOfGNetParam::end

```cpp
void* VectorOfGNetParam::end()

AutoIt:
    $oVectorOfGNetParam.end() -> retval
```

### VectorOfGNetParam::get_Item

```cpp
cv::gapi::GNetParam VectorOfGNetParam::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfGNetParam.Item( $vIndex ) -> retval
    VectorOfGNetParam( $vIndex ) -> retval
```

### VectorOfGNetParam::put_Item

```cpp
void VectorOfGNetParam::put_Item( size_t              vIndex,
                                  cv::gapi::GNetParam vItem )

AutoIt:
    $oVectorOfGNetParam.Item( $vIndex ) = $$vItem
```

## VectorOfPrim

### VectorOfPrim::create

```cpp
static VectorOfPrim VectorOfPrim::create()

AutoIt:
    _OpenCV_ObjCreate("VectorOfPrim").create() -> <VectorOfPrim object>
```

```cpp
static VectorOfPrim VectorOfPrim::create( size_t size )

AutoIt:
    _OpenCV_ObjCreate("VectorOfPrim").create( $size ) -> <VectorOfPrim object>
```

```cpp
static VectorOfPrim VectorOfPrim::create( VectorOfPrim other )

AutoIt:
    _OpenCV_ObjCreate("VectorOfPrim").create( $other ) -> <VectorOfPrim object>
```

### VectorOfPrim::Keys

```cpp
std::vector<int> VectorOfPrim::Keys()

AutoIt:
    $oVectorOfPrim.Keys() -> retval
```

### VectorOfPrim::Items

```cpp
VectorOfPrim VectorOfPrim::Items()

AutoIt:
    $oVectorOfPrim.Items() -> retval
```

### VectorOfPrim::push_back

```cpp
void VectorOfPrim::push_back( cv::gapi::wip::draw::Prim value )

AutoIt:
    $oVectorOfPrim.push_back( $value ) -> None
```

### VectorOfPrim::Add

```cpp
void VectorOfPrim::Add( cv::gapi::wip::draw::Prim value )

AutoIt:
    $oVectorOfPrim.Add( $value ) -> None
```

### VectorOfPrim::Remove

```cpp
void VectorOfPrim::Remove( size_t index )

AutoIt:
    $oVectorOfPrim.Remove( $index ) -> None
```

### VectorOfPrim::at

```cpp
cv::gapi::wip::draw::Prim VectorOfPrim::at( size_t index )

AutoIt:
    $oVectorOfPrim.at( $index ) -> retval
```

```cpp
void VectorOfPrim::at( size_t                    index,
                       cv::gapi::wip::draw::Prim value )

AutoIt:
    $oVectorOfPrim.at( $index, $value ) -> None
```

### VectorOfPrim::size

```cpp
size_t VectorOfPrim::size()

AutoIt:
    $oVectorOfPrim.size() -> retval
```

### VectorOfPrim::empty

```cpp
bool VectorOfPrim::empty()

AutoIt:
    $oVectorOfPrim.empty() -> retval
```

### VectorOfPrim::clear

```cpp
void VectorOfPrim::clear()

AutoIt:
    $oVectorOfPrim.clear() -> None
```

### VectorOfPrim::push_vector

```cpp
void VectorOfPrim::push_vector( VectorOfPrim other )

AutoIt:
    $oVectorOfPrim.push_vector( $other ) -> None
```

```cpp
void VectorOfPrim::push_vector( VectorOfPrim other,
                                size_t       count,
                                size_t       start = 0 )

AutoIt:
    $oVectorOfPrim.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfPrim::slice

```cpp
VectorOfPrim VectorOfPrim::slice( size_t start = 0,
                                  size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfPrim.slice( [$start[, $count]] ) -> retval
```

### VectorOfPrim::sort

```cpp
void VectorOfPrim::sort( void*  comparator,
                         size_t start = 0,
                         size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfPrim.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPrim::sort_variant

```cpp
void VectorOfPrim::sort_variant( void*  comparator,
                                 size_t start = 0,
                                 size_t count = this->__self->get()->size() )

AutoIt:
    $oVectorOfPrim.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPrim::start

```cpp
void* VectorOfPrim::start()

AutoIt:
    $oVectorOfPrim.start() -> retval
```

### VectorOfPrim::end

```cpp
void* VectorOfPrim::end()

AutoIt:
    $oVectorOfPrim.end() -> retval
```

### VectorOfPrim::get_Item

```cpp
cv::gapi::wip::draw::Prim VectorOfPrim::get_Item( size_t vIndex )

AutoIt:
    $oVectorOfPrim.Item( $vIndex ) -> retval
    VectorOfPrim( $vIndex ) -> retval
```

### VectorOfPrim::put_Item

```cpp
void VectorOfPrim::put_Item( size_t                    vIndex,
                             cv::gapi::wip::draw::Prim vItem )

AutoIt:
    $oVectorOfPrim.Item( $vIndex ) = $$vItem
```