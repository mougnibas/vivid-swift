
## GNU AFFERO GENERAL PUBLIC LICENSE
## Version 3, 19 November 2007
##
## Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
## Everyone is permitted to copy and distribute verbatim copies
## of this license document, but changing it is not allowed.

# clean
echo "Removing cache ..."
rm -rf ~/Library/Developer/Xcode/DerivedData
echo "Removing cache done !"
echo ""

# restore
echo "Resolving package dependencies ..."
xcodebuild -resolvePackageDependencies -quiet
echo "Resolving package dependencies done !"
echo ""

# build
echo "Building all schemes ..."
xcodebuild -scheme VividKernelDataAccessService         build                                                      && \
xcodebuild -scheme VividKernelDataAccessService         build                                                      && \
xcodebuild -scheme VividKernelDataAccessServiceFluent   build                                                      && \
xcodebuild -scheme VividKernelDataAccessServiceInMemory build                                                      && \
xcodebuild -scheme VividKernelService                   build                                                      && \
xcodebuild -scheme VividKernelServiceConnector          build                                                      && \
xcodebuild -scheme VividKernelServiceImpl               build                                                      && \
xcodebuild -scheme VividKernelWebserviceLib             build                                                      && \
xcodebuild -scheme VividKernelWebserviceLibFluent       build                                                      && \
xcodebuild -scheme VividKernelWebserviceLibFluentExe    build                                                      && \
xcodebuild -scheme VividKernelWebserviceLibInMemory     build                                                      && \
xcodebuild -scheme VividKernelWebserviceLibInMemoryExe  build
echo "Building all schemes done !"
echo ""

# test
echo "Making build/tests/coverage reports on all schemes ..."
rm -Rf reports/VividKernelDataAccessService.xcresult                                                               && \
rm -Rf reports/VividKernelDataAccessServiceFluent.xcresult                                                         && \
rm -Rf reports/VividKernelDataAccessServiceInMemory.xcresult                                                       && \
rm -Rf reports/VividKernelService.xcresult                                                                         && \
rm -Rf reports/VividKernelServiceConnector.xcresult                                                                && \
rm -Rf reports/VividKernelServiceImpl.xcresult                                                                     && \
rm -Rf reports/VividKernelWebserviceLib.xcresult                                                                   && \
rm -Rf reports/VividKernelWebserviceLibFluent.xcresult                                                             && \
rm -Rf reports/VividKernelWebserviceLibInMemory.xcresult                                                           && \
xcodebuild -scheme VividKernelDataAccessService          test -enableCodeCoverage YES -resultBundlePath reports/VividKernelDataAccessService.xcresult         && \
xcodebuild -scheme VividKernelDataAccessServiceFluent    test -enableCodeCoverage YES -resultBundlePath reports/VividKernelDataAccessServiceFluent.xcresult   && \
xcodebuild -scheme VividKernelDataAccessServiceInMemory  test -enableCodeCoverage YES -resultBundlePath reports/VividKernelDataAccessServiceInMemory.xcresult && \
xcodebuild -scheme VividKernelService                    test -enableCodeCoverage YES -resultBundlePath reports/VividKernelService.xcresult                   && \
xcodebuild -scheme VividKernelServiceConnector           test -enableCodeCoverage YES -resultBundlePath reports/VividKernelServiceConnector.xcresult          && \
xcodebuild -scheme VividKernelServiceImpl                test -enableCodeCoverage YES -resultBundlePath reports/VividKernelServiceImpl.xcresult               && \
xcodebuild -scheme VividKernelWebserviceLib              test -enableCodeCoverage YES -resultBundlePath reports/VividKernelWebserviceLib.xcresult             && \
xcodebuild -scheme VividKernelWebserviceLibFluent        test -enableCodeCoverage YES -resultBundlePath reports/VividKernelWebserviceLibFluent.xcresult       && \
xcodebuild -scheme VividKernelWebserviceLibInMemory      test -enableCodeCoverage YES -resultBundlePath reports/VividKernelWebserviceLibInMemory.xcresult
echo "Making build/tests/coverage reports on all schemes done !"
echo ""

# report
echo "Mergin reports ..."
rm -Rf reports/merge.xcresult
xcrun xcresulttool \
  merge \
    reports/VividKernelDataAccessService.xcresult                                                                     \
    reports/VividKernelDataAccessServiceFluent.xcresult                                                               \
    reports/VividKernelDataAccessServiceInMemory.xcresult                                                             \
    reports/VividKernelService.xcresult                                                                               \
    reports/VividKernelServiceConnector.xcresult                                                                      \
    reports/VividKernelServiceImpl.xcresult                                                                           \
    reports/VividKernelWebserviceLib.xcresult                                                                         \
    reports/VividKernelWebserviceLibFluent.xcresult                                                                   \
    reports/VividKernelWebserviceLibInMemory.xcresult                                                                 \
  --output-path reports/merge.xcresult
echo "Mergin reports done !"
echo ""

echo "Cleaning schemes reports ..."
rm -Rf reports/VividKernelDataAccessService.xcresult                                                               && \
rm -Rf reports/VividKernelDataAccessServiceFluent.xcresult                                                         && \
rm -Rf reports/VividKernelDataAccessServiceInMemory.xcresult                                                       && \
rm -Rf reports/VividKernelService.xcresult                                                                         && \
rm -Rf reports/VividKernelServiceConnector.xcresult                                                                && \
rm -Rf reports/VividKernelServiceImpl.xcresult                                                                     && \
rm -Rf reports/VividKernelWebserviceLib.xcresult                                                                   && \
rm -Rf reports/VividKernelWebserviceLibFluent.xcresult                                                             && \
rm -Rf reports/VividKernelWebserviceLibInMemory.xcresult
echo "Cleaning schemes reports done !"
echo ""

echo "Asking Xcode to open the report ..."
xed reports/merge.xcresult
echo "Asking Xcode to open the report done !"
echo ""
