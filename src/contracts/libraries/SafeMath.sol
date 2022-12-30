// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

library SafeMath {
    function add(uint256 a,uint256 b) internal pure returns(uint256){
       uint256 r=a+b;
       require(r >= a,"SafeMath: Addition overflow"); 
       return r;
    }

      function sub(uint256 a,uint256 b) internal pure returns(uint256){
       require(b <= a,"SafeMath: subtraction overflow"); 
        uint256 r=a-b;
       return r;
    }

      function mul(uint256 a,uint256 b) internal pure returns(uint256){
        // gas optimization
        if(a == 0 || b == 0){
            return 0;
        }
         uint256 r = a*b;
       require(r/a == b,"SafeMath: multiplication overflow"); 
       return r;
    }

    function div(uint256 a,uint256 b) internal pure returns(uint256){
       require(b > 0,"SafeMath: division overflow"); 
        uint256 r = a / b;
       return r;
    }

    // gas spending optimization 
    function mod(uint256 a,uint256 b) internal pure returns(uint256){
       require(b != 0,"SafeMath: modulo by zero"); 
       return a % b;
    }
}