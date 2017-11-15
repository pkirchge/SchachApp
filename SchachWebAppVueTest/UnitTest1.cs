using System;
using Xunit;
using SchachWebAppVue.Controllers;


namespace SchachWebAppVueTest
{
    public class PrimeService_IsPrimeShould
    {
        private readonly PrimeService _primeService;

        public PrimeService_IsPrimeShould()
        {
            _primeService = new PrimeService();
        }

        [Fact]
        public void ReturnFalseGivenValueOf1()
        {
            var result = _primeService.IsPrime(1);

            Assert.False(result, "1 should not be prime");
        }
        [Fact]
        public void ReturnFalseGivenValueOfZero()
        {
            var result = _primeService.IsPrime(0);

            Assert.False(result, "0 should not be prime");
        }
        [Fact]
        public void ReturnTrueGivenValueOf2()
        {
            var result = _primeService.IsPrime(2);

            Assert.True(result, "2 should be prime");
        }
    }
}
